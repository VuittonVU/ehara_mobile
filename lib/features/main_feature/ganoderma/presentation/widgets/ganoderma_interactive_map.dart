import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:proj4dart/proj4dart.dart' as proj4;

import '../../models/ganoderma_model.dart';

class GanodermaInteractiveMap extends StatefulWidget {
  final List<GanodermaPointModel> points;
  final bool showLegend;
  final bool showControls;

  const GanodermaInteractiveMap({
    super.key,
    required this.points,
    this.showLegend = true,
    this.showControls = true,
  });

  @override
  State<GanodermaInteractiveMap> createState() => _GanodermaInteractiveMapState();
}

class _GanodermaInteractiveMapState extends State<GanodermaInteractiveMap> {
  static proj4.Projection? _epsg32647;
  static proj4.Projection? _epsg4326;

  late final MapController _mapController;
  late final List<_ProjectedGanodermaPoint> _projectedPoints;
  late final List<CircleMarker> _circleMarkers;

  GanodermaPointModel? _selectedPoint;
  bool _hasFit = false;

  @override
  void initState() {
    super.initState();

    _mapController = MapController();
    _initProjection();

    _projectedPoints = _buildProjectedPoints(widget.points);
    _circleMarkers = _buildCircleMarkers(_projectedPoints);
  }

  void _initProjection() {
    _epsg4326 ??= proj4.Projection.get('EPSG:4326') ??
        proj4.Projection.add(
          'EPSG:4326',
          '+proj=longlat +datum=WGS84 +no_defs',
        );

    _epsg32647 ??= proj4.Projection.get('EPSG:32647') ??
        proj4.Projection.add(
          'EPSG:32647',
          '+proj=utm +zone=47 +datum=WGS84 +units=m +no_defs +type=crs',
        );
  }

  List<_ProjectedGanodermaPoint> _buildProjectedPoints(
      List<GanodermaPointModel> points,
      ) {
    final source = _epsg32647!;
    final target = _epsg4326!;

    return points.map((point) {
      final converted = source.transform(
        target,
        proj4.Point(
          x: point.rawX,
          y: point.rawY,
        ),
      );

      return _ProjectedGanodermaPoint(
        source: point,
        latLng: LatLng(converted.y, converted.x),
      );
    }).toList();
  }

  List<CircleMarker> _buildCircleMarkers(
      List<_ProjectedGanodermaPoint> points,
      ) {
    return points.map((point) {
      return CircleMarker(
        point: point.latLng,
        radius: 3.2,
        color: point.source.isDetected
            ? const Color(0xFFE60012)
            : const Color(0xFF2AF022),
        borderColor: const Color(0xFF2D4A1E),
        borderStrokeWidth: 0.7,
      );
    }).toList();
  }

  void _fitBoundsIfNeeded() {
    if (_hasFit || _projectedPoints.isEmpty) return;
    _hasFit = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final bounds = LatLngBounds.fromPoints(
        _projectedPoints.map((e) => e.latLng).toList(),
      );

      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.all(28),
        ),
      );
    });
  }

  void _zoomIn() {
    final camera = _mapController.camera;

    _mapController.move(
      camera.center,
      camera.zoom + 0.5,
    );
  }

  void _zoomOut() {
    final camera = _mapController.camera;

    _mapController.move(
      camera.center,
      math.max(1, camera.zoom - 0.5),
    );
  }

  void _onMapTap(TapPosition tapPosition, LatLng latLng) {
    if (_projectedPoints.isEmpty) return;

    _ProjectedGanodermaPoint? nearest;
    double nearestDistance = double.infinity;

    for (final point in _projectedPoints) {
      final dLat = point.latLng.latitude - latLng.latitude;
      final dLng = point.latLng.longitude - latLng.longitude;
      final distance = dLat * dLat + dLng * dLng;

      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearest = point;
      }
    }

    if (nearest != null && nearestDistance < 0.0000008) {
      setState(() {
        _selectedPoint = nearest!.source;
      });
    } else {
      setState(() {
        _selectedPoint = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    final legendWidth =
        MediaQuery.of(context).size.width * (isSmall ? 0.42 : 0.36);

    _fitBoundsIfNeeded();

    final selectedProjected = _selectedPoint == null
        ? null
        : _projectedPoints.firstWhere(
          (e) => identical(e.source, _selectedPoint),
      orElse: () => _projectedPoints.first,
    );

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isSmall ? 14 : 18),
        child: Stack(
          children: [
            Positioned.fill(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _projectedPoints.isNotEmpty
                      ? _projectedPoints.first.latLng
                      : const LatLng(3.59, 98.67),
                  initialZoom: 18,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                  onTap: _onMapTap,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'app.ppks.ehara_mobile',
                  ),
                  CircleLayer(
                    circles: _circleMarkers,
                  ),
                  if (selectedProjected != null)
                    CircleLayer(
                      circles: [
                        CircleMarker(
                          point: selectedProjected.latLng,
                          radius: 7.5,
                          color: Colors.transparent,
                          borderColor: Colors.white,
                          borderStrokeWidth: 2.2,
                        ),
                      ],
                    ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (widget.showControls)
              Positioned(
                left: isSmall ? 10 : 12,
                top: isSmall ? 10 : 12,
                child: Column(
                  children: [
                    _MapControlButton(
                      icon: Icons.add,
                      onTap: _zoomIn,
                    ),
                    SizedBox(height: isSmall ? 6 : 8),
                    _MapControlButton(
                      icon: Icons.remove,
                      onTap: _zoomOut,
                    ),
                  ],
                ),
              ),
            if (_selectedPoint != null)
              Positioned(
                top: isSmall ? 10 : 12,
                right: isSmall ? 10 : 12,
                child: _PointInfoCard(
                  point: _selectedPoint!,
                  onClose: () {
                    setState(() {
                      _selectedPoint = null;
                    });
                  },
                ),
              ),
            if (widget.showLegend)
              Positioned(
                right: isSmall ? 10 : 14,
                bottom: isSmall ? 10 : 14,
                child: Container(
                  width: legendWidth,
                  padding: EdgeInsets.fromLTRB(
                    isSmall ? 10 : 12,
                    isSmall ? 8 : 10,
                    isSmall ? 10 : 12,
                    isSmall ? 8 : 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Keterangan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF334A6E),
                        ),
                      ),
                      SizedBox(height: 8),
                      _LegendRow(
                        color: Color(0xFFE60012),
                        label: 'Ganoderma Terdeteksi',
                      ),
                      SizedBox(height: 6),
                      _LegendRow(
                        color: Color(0xFF2AF022),
                        label: 'Tidak Terdeteksi',
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProjectedGanodermaPoint {
  final GanodermaPointModel source;
  final LatLng latLng;

  const _ProjectedGanodermaPoint({
    required this.source,
    required this.latLng,
  });
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapControlButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: isSmall ? 34 : 40,
          height: isSmall ? 34 : 40,
          child: Icon(
            icon,
            color: const Color(0xFF333333),
            size: isSmall ? 20 : 24,
          ),
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendRow({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;

    return Row(
      children: [
        Container(
          width: isSmall ? 10 : 12,
          height: isSmall ? 10 : 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: isSmall ? 6 : 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isSmall ? 11 : 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF223355),
            ),
          ),
        ),
      ],
    );
  }
}

class _PointInfoCard extends StatelessWidget {
  final GanodermaPointModel point;
  final VoidCallback onClose;

  const _PointInfoCard({
    required this.point,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;

    return Container(
      constraints: BoxConstraints(
        maxWidth: isSmall ? 190 : 220,
      ),
      padding: EdgeInsets.fromLTRB(
        isSmall ? 10 : 12,
        isSmall ? 8 : 10,
        isSmall ? 10 : 12,
        isSmall ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: isSmall ? 11 : 12,
          color: const Color(0xFF333333),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Detail Point',
                    style: TextStyle(
                      fontSize: isSmall ? 12 : 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onClose,
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text('No: ${point.pointNo}'),
            Text('X: ${point.displayX.toStringAsFixed(8)}'),
            Text('Y: ${point.displayY.toStringAsFixed(8)}'),
            Text(
              'Ganoderma: ${point.isDetected ? 'Terdeteksi' : 'Tidak Terdeteksi'}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: point.isDetected
                    ? const Color(0xFFE60012)
                    : const Color(0xFF118A17),
              ),
            ),
          ],
        ),
      ),
    );
  }
}