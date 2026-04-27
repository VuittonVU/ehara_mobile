import 'package:flutter/material.dart';

import '../../../../../../../core/widgets/date_input_field.dart';
import '../../../../../../../core/widgets/filter_option_button.dart';
import '../../models/kebun_filter_model.dart';

class KebunFilterDialog extends StatefulWidget {
  final KebunFilterModel initialFilter;

  const KebunFilterDialog({
    super.key,
    required this.initialFilter,
  });

  @override
  State<KebunFilterDialog> createState() => _KebunFilterDialogState();
}

class _KebunFilterDialogState extends State<KebunFilterDialog> {
  DateTime? _startAnalysisDate;
  DateTime? _endAnalysisDate;
  DateTime? _startPickupDate;
  DateTime? _endPickupDate;
  KebunSortType? _sortType;

  @override
  void initState() {
    super.initState();
    _startAnalysisDate = widget.initialFilter.startAnalysisDate;
    _endAnalysisDate = widget.initialFilter.endAnalysisDate;
    _startPickupDate = widget.initialFilter.startPickupDate;
    _endPickupDate = widget.initialFilter.endPickupDate;
    _sortType = widget.initialFilter.sortType;
  }

  Future<void> _pickDate({
    required _DateTarget target,
  }) async {
    final currentDate = switch (target) {
      _DateTarget.startAnalysis => _startAnalysisDate,
      _DateTarget.endAnalysis => _endAnalysisDate,
      _DateTarget.startPickup => _startPickupDate,
      _DateTarget.endPickup => _endPickupDate,
    };

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (pickedDate == null) return;

    setState(() {
      switch (target) {
        case _DateTarget.startAnalysis:
          _startAnalysisDate = pickedDate;
          break;
        case _DateTarget.endAnalysis:
          _endAnalysisDate = pickedDate;
          break;
        case _DateTarget.startPickup:
          _startPickupDate = pickedDate;
          break;
        case _DateTarget.endPickup:
          _endPickupDate = pickedDate;
          break;
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
      KebunFilterModel(
        startAnalysisDate: _startAnalysisDate,
        endAnalysisDate: _endAnalysisDate,
        startPickupDate: _startPickupDate,
        endPickupDate: _endPickupDate,
        sortType: _sortType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 52),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF3E806D),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.14),
              blurRadius: 12,
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
                          size: 22,
                          color: Color(0xFF222222),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(
                thickness: 1.6,
                color: Color(0xFF474747),
                indent: 8,
                endIndent: 8,
              ),
              const SizedBox(height: 14),

              const _SectionTitle(title: 'Tanggal Analisis'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DateInputField(
                      label: _startAnalysisDate == null
                          ? 'Dari tanggal'
                          : _formatDate(_startAnalysisDate),
                      onTap: () => _pickDate(
                        target: _DateTarget.startAnalysis,
                      ),
                      iconPath: 'assets/icons/calendar.png',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DateInputField(
                      label: _endAnalysisDate == null
                          ? 'Sampe tanggal'
                          : _formatDate(_endAnalysisDate),
                      onTap: () => _pickDate(
                        target: _DateTarget.endAnalysis,
                      ),
                      iconPath: 'assets/icons/calendar.png',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const _SectionTitle(title: 'Tanggal Pengambilan Data'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DateInputField(
                      label: _startPickupDate == null
                          ? 'Dari tanggal'
                          : _formatDate(_startPickupDate),
                      onTap: () => _pickDate(
                        target: _DateTarget.startPickup,
                      ),
                      iconPath: 'assets/icons/calendar.png',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DateInputField(
                      label: _endPickupDate == null
                          ? 'Sampe tanggal'
                          : _formatDate(_endPickupDate),
                      onTap: () => _pickDate(
                        target: _DateTarget.endPickup,
                      ),
                      iconPath: 'assets/icons/calendar.png',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const _SectionTitle(title: 'Urutan'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: FilterOptionButton(
                      label: 'Terbaru',
                      isSelected: _sortType == KebunSortType.terbaru,
                      onTap: () => setState(() {
                        _sortType = _sortType == KebunSortType.terbaru
                            ? null
                            : KebunSortType.terbaru;
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilterOptionButton(
                      label: 'Terlama',
                      isSelected: _sortType == KebunSortType.terlama,
                      onTap: () => setState(() {
                        _sortType = _sortType == KebunSortType.terlama
                            ? null
                            : KebunSortType.terlama;
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
                      isSelected: _sortType == KebunSortType.az,
                      onTap: () => setState(() {
                        _sortType = _sortType == KebunSortType.az
                            ? null
                            : KebunSortType.az;
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilterOptionButton(
                      label: 'Z-A',
                      isSelected: _sortType == KebunSortType.za,
                      onTap: () => setState(() {
                        _sortType = _sortType == KebunSortType.za
                            ? null
                            : KebunSortType.za;
                      }),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: 220,
                height: 40,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    elevation: 1.5,
                    backgroundColor: const Color(0xFF3E806D),
                    shadowColor: Colors.black.withOpacity(0.18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text(
                    'Terapkan Filter',
                    style: TextStyle(
                      fontSize: 13,
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

enum _DateTarget {
  startAnalysis,
  endAnalysis,
  startPickup,
  endPickup,
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2F2F2F),
        ),
      ),
    );
  }
}