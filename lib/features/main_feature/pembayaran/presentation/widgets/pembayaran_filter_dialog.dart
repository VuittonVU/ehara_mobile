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
  State<PembayaranFilterDialog> createState() =>
      _PembayaranFilterDialogState();
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

  Future<void> _pickDate({required bool isStart}) async {
    final initialDate = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? DateTime.now());

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (pickedDate == null) return;

    setState(() {
      if (isStart) {
        _startDate = pickedDate;
      } else {
        _endDate = pickedDate;
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

  Widget _buildDateField({
    required String text,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFB4B4B4),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 12,
                    color: text.contains('tanggal')
                        ? const Color(0xFF9A9A9A)
                        : const Color(0xFF444444),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.calendar_today_outlined,
                size: 17,
                color: Color(0xFF4D4D4D),
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
    double? width,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: width,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE8F3EF) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? const Color(0xFF3E7F69)
                : const Color(0xFFB4B4B4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: selected
                  ? const Color(0xFF2F6F5C)
                  : const Color(0xFF4D4D4D),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
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
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Spacer(),
                  const Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        size: 28,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 1.5,
                color: const Color(0xFF4A4A4A),
              ),
              const SizedBox(height: 16),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tanggal',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3A3A3A),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildDateField(
                    text: _startDate == null
                        ? 'Dari tanggal'
                        : _formatDate(_startDate),
                    onTap: () => _pickDate(isStart: true),
                  ),
                  const SizedBox(width: 8),
                  _buildDateField(
                    text: _endDate == null
                        ? 'Sampe tanggal'
                        : _formatDate(_endDate),
                    onTap: () => _pickDate(isStart: false),
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
                    color: Color(0xFF3A3A3A),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildOptionButton(
                      text: 'Terbaru',
                      selected: _sortType == PembayaranSortType.terbaru,
                      onTap: () {
                        setState(() {
                          _sortType = PembayaranSortType.terbaru;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildOptionButton(
                      text: 'Terlama',
                      selected: _sortType == PembayaranSortType.terlama,
                      onTap: () {
                        setState(() {
                          _sortType = PembayaranSortType.terlama;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildOptionButton(
                      text: 'A-Z',
                      selected: _sortType == PembayaranSortType.az,
                      onTap: () {
                        setState(() {
                          _sortType = PembayaranSortType.az;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildOptionButton(
                      text: 'Z-A',
                      selected: _sortType == PembayaranSortType.za,
                      onTap: () {
                        setState(() {
                          _sortType = PembayaranSortType.za;
                        });
                      },
                    ),
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
                    color: Color(0xFF3A3A3A),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildOptionButton(
                      text: 'Proses Pembayaran',
                      selected: _status == PembayaranStatus.proses,
                      onTap: () {
                        setState(() {
                          _status = PembayaranStatus.proses;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildOptionButton(
                      text: 'Pembayaran Dibatalkan',
                      selected: _status == PembayaranStatus.dibatalkan,
                      onTap: () {
                        setState(() {
                          _status = PembayaranStatus.dibatalkan;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  width: 150,
                  child: _buildOptionButton(
                    text: 'Pembayaran Selesai',
                    selected: _status == PembayaranStatus.selesai,
                    onTap: () {
                      setState(() {
                        _status = PembayaranStatus.selesai;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),
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
      ),
    );
  }
}