import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../providers/riwayat_state.dart';
import '../../../../../core/widgets/date_input_field.dart';
import '../../../../../core/widgets/filter_option_button.dart';

class RiwayatFilterResult {
  final DateTime? startDate;
  final DateTime? endDate;
  final RiwayatSortType? sortType;

  const RiwayatFilterResult({
    required this.startDate,
    required this.endDate,
    required this.sortType,
  });
}

class RiwayatFilterDialog extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final RiwayatSortType? initialSortType;

  const RiwayatFilterDialog({
    super.key,
    required this.initialStartDate,
    required this.initialEndDate,
    required this.initialSortType,
  });

  @override
  State<RiwayatFilterDialog> createState() => _RiwayatFilterDialogState();
}

class _RiwayatFilterDialogState extends State<RiwayatFilterDialog> {
  late DateTime? _startDate;
  late DateTime? _endDate;
  late RiwayatSortType? _sortType;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
    _sortType = widget.initialSortType;
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return DateFormat('dd-MM-yyyy').format(date);
  }

  void _apply() {
    Navigator.pop(
      context,
      RiwayatFilterResult(
        startDate: _startDate,
        endDate: _endDate,
        sortType: _sortType,
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
                        child: Icon(Icons.close, size: 26, color: Color(0xFF222222)),
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
                      label: _formatDate(_startDate) ?? 'Dari tanggal',
                      onTap: _pickStartDate,
                      iconPath: 'assets/icons/calendar.png',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DateInputField(
                      label: _formatDate(_endDate) ?? 'Sampai tanggal',
                      onTap: _pickEndDate,
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
                      isSelected: _sortType == RiwayatSortType.newest,
                      onTap: () => setState(() {
                        _sortType = _sortType == RiwayatSortType.newest
                            ? null
                            : RiwayatSortType.newest;
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilterOptionButton(
                      label: 'Terlama',
                      isSelected: _sortType == RiwayatSortType.oldest,
                      onTap: () => setState(() {
                        _sortType = _sortType == RiwayatSortType.oldest
                            ? null
                            : RiwayatSortType.oldest;
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
                      isSelected: _sortType == RiwayatSortType.az,
                      onTap: () => setState(() {
                        _sortType = _sortType == RiwayatSortType.az
                            ? null
                            : RiwayatSortType.az;
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilterOptionButton(
                      label: 'Z-A',
                      isSelected: _sortType == RiwayatSortType.za,
                      onTap: () => setState(() {
                        _sortType = _sortType == RiwayatSortType.za
                            ? null
                            : RiwayatSortType.za;
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: 220,
                height: 42,
                child: ElevatedButton(
                  onPressed: _apply,
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