import 'package:flutter/material.dart';

import '../../models/pembayaran_filter_model.dart';
import '../../models/pembayaran_model.dart';

class PembayaranFilterDialog extends StatefulWidget {
  final PembayaranFilterModel initialFilter;

  const PembayaranFilterDialog({
    super.key,
    required this.initialFilter,
  });

  @override
  State<PembayaranFilterDialog> createState() => _PembayaranFilterDialogState();
}

class _PembayaranFilterDialogState extends State<PembayaranFilterDialog> {
  DateTime? _startDate;
  DateTime? _endDate;
  late PembayaranSortType _sortType;
  PembayaranStatus? _status;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialFilter.startDate;
    _endDate = widget.initialFilter.endDate;
    _sortType = widget.initialFilter.sortType;
    _status = widget.initialFilter.status;
  }

  Future<void> _pickDate(bool isStart) async {
    final initialDate =
    isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked == null) return;

    setState(() {
      if (isStart) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day-$month-$year';
  }

  Widget _buildDateBox({
    required String text,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFAEAEAE),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text.isEmpty ? 'Pilih tanggal' : text,
                  style: TextStyle(
                    fontSize: 12,
                    color: text.isEmpty
                        ? const Color(0xFF9A9A9A)
                        : const Color(0xFF3F3F3F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: Color(0xFF444444),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFE5F2EE) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? const Color(0xFF3E7F69)
                  : const Color(0xFFAEAEAE),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: selected
                  ? const Color(0xFF2F6C59)
                  : const Color(0xFF505050),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    Navigator.pop(
      context,
      PembayaranFilterModel(
        startDate: _startDate,
        endDate: _endDate,
        sortType: _sortType,
        status: _status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: const Color(0xFF3E7F69),
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Spacer(),
                const Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF333333),
                  ),
                ),
                const Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.close,
                      size: 28,
                      color: Color(0xFF222222),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 1.5,
              color: const Color(0xFF585858),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tanggal',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3D3D3D),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildDateBox(
                  text: _startDate == null ? 'Dari tanggal' : _formatDate(_startDate),
                  onTap: () => _pickDate(true),
                ),
                const SizedBox(width: 8),
                _buildDateBox(
                  text: _endDate == null ? 'Sampe tanggal' : _formatDate(_endDate),
                  onTap: () => _pickDate(false),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Urutan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3D3D3D),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildOptionButton(
                  text: 'Terbaru',
                  selected: _sortType == PembayaranSortType.terbaru,
                  onTap: () => setState(() {
                    _sortType = PembayaranSortType.terbaru;
                  }),
                ),
                const SizedBox(width: 8),
                _buildOptionButton(
                  text: 'Terlama',
                  selected: _sortType == PembayaranSortType.terlama,
                  onTap: () => setState(() {
                    _sortType = PembayaranSortType.terlama;
                  }),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildOptionButton(
                  text: 'A-Z',
                  selected: _sortType == PembayaranSortType.az,
                  onTap: () => setState(() {
                    _sortType = PembayaranSortType.az;
                  }),
                ),
                const SizedBox(width: 8),
                _buildOptionButton(
                  text: 'Z-A',
                  selected: _sortType == PembayaranSortType.za,
                  onTap: () => setState(() {
                    _sortType = PembayaranSortType.za;
                  }),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Status Pembayaran',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3D3D3D),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildOptionButton(
                  text: 'Proses Pembayaran',
                  selected: _status == PembayaranStatus.proses,
                  onTap: () => setState(() {
                    _status = PembayaranStatus.proses;
                  }),
                ),
                const SizedBox(width: 8),
                _buildOptionButton(
                  text: 'Pembayaran Dibatalkan',
                  selected: _status == PembayaranStatus.dibatalkan,
                  onTap: () => setState(() {
                    _status = PembayaranStatus.dibatalkan;
                  }),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Spacer(),
                SizedBox(
                  width: 140,
                  child: _buildOptionButton(
                    text: 'Pembayaran Selesai',
                    selected: _status == PembayaranStatus.selesai,
                    onTap: () => setState(() {
                      _status = PembayaranStatus.selesai;
                    }),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 190,
              height: 42,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3E7F69),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Terapkan Filter',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}