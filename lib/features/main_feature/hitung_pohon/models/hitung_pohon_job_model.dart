class HitungPohonJobModel {
  final String id;
  final String userId;
  final String status;
  final int progress;
  final String filename;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ClassCounts classCounts;
  final TifInfo tifInfo;
  final int tilesProcessed;
  final int totalGridTiles;
  final int? etaSeconds;
  final int? elapsedSeconds;
  final int? sizeBytes;

  const HitungPohonJobModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.progress,
    required this.filename,
    required this.createdAt,
    required this.updatedAt,
    required this.classCounts,
    required this.tifInfo,
    required this.tilesProcessed,
    required this.totalGridTiles,
    required this.etaSeconds,
    required this.elapsedSeconds,
    required this.sizeBytes,
  });

  bool get isDone => status.toLowerCase() == 'done';
  bool get isFailed => status.toLowerCase() == 'failed';
  bool get isProcessing => !isDone && !isFailed;
  String get formattedFileSize {
    final bytes = sizeBytes != null && sizeBytes! > 0
        ? sizeBytes!
        : tifInfo.fileSizeBytes;

    if (bytes > 0) {
      final mb = bytes / (1024 * 1024);
      return '${mb.toStringAsFixed(2)} MB';
    }

    if (tifInfo.fileSizeMb > 0) {
      return '${tifInfo.fileSizeMb.toStringAsFixed(2)} MB';
    }

    return '-';
  }


  factory HitungPohonJobModel.fromJson(Map<String, dynamic> json) {
    return HitungPohonJobModel(
      id: json['id']?.toString() ?? '-',
      userId: json['user_id']?.toString() ?? 'anonymous',
      status: json['status']?.toString() ?? 'unknown',
      progress: _toInt(json['progress']),
      filename: json['filename']?.toString() ?? '-',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
      classCounts: ClassCounts.fromJson(_asMap(json['counts'] ?? json['class_counts'])),
      tifInfo: TifInfo.fromJson(_asMap(json['image_info'] ?? json['tif_info'])),
      tilesProcessed: _toInt(json['tiles_processed']),
      totalGridTiles: _toInt(json['total_grid_tiles']),
      etaSeconds: json['eta_seconds'] == null ? null : _toInt(json['eta_seconds']),
      elapsedSeconds: json['elapsed_seconds'] == null ? null : _toInt(json['elapsed_seconds']),
      sizeBytes: json['size_bytes'] == null ? null : _toInt(json['size_bytes']),
    );
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class ClassCounts {
  final int palm;
  final int total;
  final int fadePalm;
  final int fadePalmGreenYoung;

  const ClassCounts({
    required this.palm,
    required this.total,
    required this.fadePalm,
    required this.fadePalmGreenYoung,
  });

  factory ClassCounts.fromJson(Map<String, dynamic> json) {
    return ClassCounts(
      palm: HitungPohonJobModel._toInt(json['palm']),
      total: HitungPohonJobModel._toInt(json['total']),
      fadePalm: HitungPohonJobModel._toInt(json['fade_palm']),
      fadePalmGreenYoung: HitungPohonJobModel._toInt(json['fade_palm_green_young']),
    );
  }
}

class TifInfo {
  final String crs;
  final int bands;
  final String dtype;
  final int width;
  final int height;
  final int fullCols;
  final int fullRows;
  final int tileSize;
  final double fileSizeMb;
  final int fileSizeBytes;
  final int totalGridTiles;

  const TifInfo({
    required this.crs,
    required this.bands,
    required this.dtype,
    required this.width,
    required this.height,
    required this.fullCols,
    required this.fullRows,
    required this.tileSize,
    required this.fileSizeMb,
    required this.fileSizeBytes,
    required this.totalGridTiles,
  });

  factory TifInfo.fromJson(Map<String, dynamic> json) {
    return TifInfo(
      crs: json['crs']?.toString() ?? '-',
      bands: HitungPohonJobModel._toInt(json['bands']),
      dtype: json['dtype']?.toString() ?? '-',
      width: HitungPohonJobModel._toInt(json['width']),
      height: HitungPohonJobModel._toInt(json['height']),
      fullCols: HitungPohonJobModel._toInt(json['full_cols']),
      fullRows: HitungPohonJobModel._toInt(json['full_rows']),
      tileSize: HitungPohonJobModel._toInt(json['tile_size']),
      fileSizeMb: double.tryParse(json['file_size_mb']?.toString() ?? '') ?? 0,
      fileSizeBytes: HitungPohonJobModel._toInt(json['file_size_bytes']),
      totalGridTiles: HitungPohonJobModel._toInt(json['total_grid_tiles']),
    );
  }
}
