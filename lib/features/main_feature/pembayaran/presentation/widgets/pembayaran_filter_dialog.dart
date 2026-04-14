import 'package:flutter/material.dart';

import '../../../../../core/widgets/date_input_field.dart';
import '../../../../../core/widgets/filter_option_button.dart';
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
  PembayaranSortType? _sortType;
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
        : (_endDate ?? _startDate ?? DateTime.now());

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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F6),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: const Color(0xFF3E806D),
            width: 2.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.14),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const Center(
                    child: Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2F2F2F),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(999),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          size: 26,
                          color: Color(0xFF222222),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(
                thickness: 2.0,
                color: Color(0xFF474747),
                indent: 8,
                endIndent: 8,
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tanggal',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2F2F2F),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DateInputField(
                      label: _startDate == null
                          ? 'Dari tanggal'
                          : _formatDate(_startDate),
                      onTap: () => _pickDate(isStart: true),
                      iconPath: 'assets/icons/calendar.png',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DateInputField(
                      label: _endDate == null
                          ? 'Sampe tanggal'
                          : _formatDate(_endDate),
                      onTap: () => _pickDate(isStart: false),
                      iconPath: 'assets/icons/calendar.png',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Urutan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2F2F2F),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilterOptionButton(
                      label: 'Terbaru',
                      isSelected: _sortType == PembayaranSortType.terbaru,
                      onTap: () => setState(() {
                        _sortType = _sortType == PembayaranSortType.terbaru
                            ? null
                            : PembayaranSortType.terbaru;
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilterOptionButton(
                      label: 'Terlama',
                      isSelected: _sortType == PembayaranSortType.terlama,
                      onTap: () => setState(() {
                        _sortType = _sortType == PembayaranSortType.terlama
                            ? null
                            : PembayaranSortType.terlama;
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: FilterOptionButton(
                      label: 'A-Z',
                      isSelected: _sortType == PembayaranSortType.az,
                      onTap: () => setState(() {
                        _sortType = _sortType == PembayaranSortType.az
                            ? null
                            : PembayaranSortType.az;
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilterOptionButton(
                      label: 'Z-A',
                      isSelected: _sortType == PembayaranSortType.za,
                      onTap: () => setState(() {
                        _sortType = _sortType == PembayaranSortType.za
                            ? null
                            : PembayaranSortType.za;
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Status Pembayaran',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2F2F2F),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilterOptionButton(
                      label: 'Pembayaran Selesai',
                      isSelected: _status == PembayaranStatus.selesai,
                      onTap: () => setState(() {
                        _status = _status == PembayaranStatus.selesai
                            ? null
                            : PembayaranStatus.selesai;
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilterOptionButton(
                      label: 'Proses Pembayaran',
                      isSelected: _status == PembayaranStatus.proses,
                      onTap: () => setState(() {
                        _status = _status == PembayaranStatus.proses
                            ? null
                            : PembayaranStatus.proses;
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Spacer(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.42,
                    child: FilterOptionButton(
                      label: 'Belum Pembayaran',
                      isSelected: _status == PembayaranStatus.dibatalkan,
                      onTap: () => setState(() {
                        _status = _status == PembayaranStatus.dibatalkan
                            ? null
                            : PembayaranStatus.dibatalkan;
                      }),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: 220,
                height: 42,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    elevation: 1.5,
                    backgroundColor: const Color(0xFF4A8A76),
                    shadowColor: Colors.black.withOpacity(0.18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Terapkan Filter',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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