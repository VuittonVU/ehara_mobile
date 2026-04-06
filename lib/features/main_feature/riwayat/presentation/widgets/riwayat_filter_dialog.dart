import 'package:flutter/material.dart';
import '../../models/riwayat_filter_model.dart';

class RiwayatFilterDialog extends StatefulWidget {
  final RiwayatFilterModel initialFilter;

  const RiwayatFilterDialog({
    super.key,
    required this.initialFilter,
  });

  @override
  State<RiwayatFilterDialog> createState() => _RiwayatFilterDialogState();
}

class _RiwayatFilterDialogState extends State<RiwayatFilterDialog> {
  late DateTime? _startDate;
  late DateTime? _endDate;
  late RiwayatSortOption? _sortOption;
  late RiwayatCertificateFilter? _certificateFilter;

  @override
  void initState() {
    super.initState();

    _startDate = widget.initialFilter.startDate;
    _endDate = widget.initialFilter.endDate;

    _sortOption = widget.initialFilter.sortOption ==
        RiwayatFilterModel.initial.sortOption
        ? null
        : widget.initialFilter.sortOption;

    _certificateFilter = widget.initialFilter.certificateFilter ==
        RiwayatFilterModel.initial.certificateFilter
        ? null
        : widget.initialFilter.certificateFilter;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d-$m-$y';
  }

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;

        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _resetFilter() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _sortOption = null;
      _certificateFilter = null;
    });
  }

  void _applyFilter() {
    Navigator.pop(
      context,
      RiwayatFilterModel(
        startDate: _startDate,
        endDate: _endDate,
        sortOption: _sortOption ?? RiwayatSortOption.terbaru,
        certificateFilter:
        _certificateFilter ?? RiwayatCertificateFilter.semua,
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
          ),
        ),
      ),
    );
  }

  Widget _buildDateButton({
    required String placeholder,
    required String value,
    required VoidCallback onTap,
  }) {
    final hasValue = value.isNotEmpty;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFBDBDBD),
              width: 1.1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  hasValue ? value : placeholder,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: hasValue ? 12.5 : 11.5,
                    color: hasValue
                        ? const Color(0xFF333333)
                        : const Color(0xFF9E9E9E),
                    fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                    height: 1.0,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.calendar_month_outlined,
                size: 18,
                color: Color(0xFF4D4D4D),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4F8A78) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF4F8A78)
                  : const Color(0xFFBDBDBD),
              width: isSelected ? 1.4 : 1.1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF333333),
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: const Color(0xFF3E7F69),
            width: 2.3,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  const Expanded(
                    flex: 6,
                    child: Text(
                      'Filter',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          size: 28,
                          color: Color(0xFF222222),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              _buildSectionTitle('Tanggal'),
              Row(
                children: [
                  _buildDateButton(
                    placeholder: 'Dari tanggal',
                    value: _formatDate(_startDate),
                    onTap: _pickStartDate,
                  ),
                  const SizedBox(width: 10),
                  _buildDateButton(
                    placeholder: 'Sampai tanggal',
                    value: _formatDate(_endDate),
                    onTap: _pickEndDate,
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _buildSectionTitle('Urutan'),
              Row(
                children: [
                  _buildChoiceButton(
                    label: 'Terbaru',
                    isSelected: _sortOption == RiwayatSortOption.terbaru,
                    onTap: () {
                      setState(() {
                        _sortOption = _sortOption == RiwayatSortOption.terbaru
                            ? null
                            : RiwayatSortOption.terbaru;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildChoiceButton(
                    label: 'Terlama',
                    isSelected: _sortOption == RiwayatSortOption.terlama,
                    onTap: () {
                      setState(() {
                        _sortOption = _sortOption == RiwayatSortOption.terlama
                            ? null
                            : RiwayatSortOption.terlama;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildChoiceButton(
                    label: 'A-Z',
                    isSelected: _sortOption == RiwayatSortOption.az,
                    onTap: () {
                      setState(() {
                        _sortOption = _sortOption == RiwayatSortOption.az
                            ? null
                            : RiwayatSortOption.az;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildChoiceButton(
                    label: 'Z-A',
                    isSelected: _sortOption == RiwayatSortOption.za,
                    onTap: () {
                      setState(() {
                        _sortOption = _sortOption == RiwayatSortOption.za
                            ? null
                            : RiwayatSortOption.za;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 22),
              _buildSectionTitle('Status Sertifikat'),
              Row(
                children: [
                  _buildChoiceButton(
                    label: 'Sudah Terbit',
                    isSelected: _certificateFilter ==
                        RiwayatCertificateFilter.sudahTerbit,
                    onTap: () {
                      setState(() {
                        _certificateFilter = _certificateFilter ==
                            RiwayatCertificateFilter.sudahTerbit
                            ? null
                            : RiwayatCertificateFilter.sudahTerbit;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  _buildChoiceButton(
                    label: 'Belum Terbit',
                    isSelected: _certificateFilter ==
                        RiwayatCertificateFilter.belumTerbit,
                    onTap: () {
                      setState(() {
                        _certificateFilter = _certificateFilter ==
                            RiwayatCertificateFilter.belumTerbit
                            ? null
                            : RiwayatCertificateFilter.belumTerbit;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: const [
                  Spacer(),
                ],
              ),
              SizedBox(
                width: 140,
                child: _buildChoiceButton(
                  label: 'Semua',
                  isSelected:
                  _certificateFilter == RiwayatCertificateFilter.semua,
                  onTap: () {
                    setState(() {
                      _certificateFilter =
                      _certificateFilter == RiwayatCertificateFilter.semua
                          ? null
                          : RiwayatCertificateFilter.semua;
                    });
                  },
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetFilter,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(46),
                        side: const BorderSide(
                          color: Color(0xFF4F8A78),
                          width: 1.4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          color: Color(0xFF4F8A78),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _applyFilter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F8A78),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Terapkan Filter',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}