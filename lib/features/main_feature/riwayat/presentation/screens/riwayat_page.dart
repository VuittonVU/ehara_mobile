import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/app_background.dart';
import '../../models/riwayat_filter_model.dart';
import '../../providers/riwayat_provider.dart';
import '../widgets/riwayat_analisis_card.dart';
import '../widgets/riwayat_filter_dialog.dart';
import '../widgets/riwayat_search_bar.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  final ScrollController _scrollController = ScrollController();

  bool _showTopFade = false;
  bool _showBottomFade = false;

  final List<int> limitOptions = [3, 5, 10, 20];

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_handleScrollFade);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RiwayatProvider>().init();
      _handleScrollFade();
    });
  }

  void _handleScrollFade() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    final showTop = position.pixels > 8;
    final showBottom = position.pixels < (position.maxScrollExtent - 8);

    if (showTop != _showTopFade || showBottom != _showBottomFade) {
      setState(() {
        _showTopFade = showTop;
        _showBottomFade = showBottom;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScrollFade);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openFilterDialog(RiwayatProvider provider) async {
    final result = await showDialog<RiwayatFilterModel>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.20),
      builder: (_) {
        return RiwayatFilterDialog(
          initialFilter: provider.filter,
        );
      },
    );

    if (result != null) {
      provider.applyFilter(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RiwayatProvider>(
      builder: (context, provider, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _handleScrollFade();
        });

        return Scaffold(
          body: AppBackground(
            child: SafeArea(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Riwayat Analisis',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(18, 26, 18, 18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(34),
                          border: Border.all(
                            color: const Color(0xFFBDBDBD),
                            width: 1.5,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x22000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            RiwayatSearchBar(
                              controller: provider.searchController,
                              onChanged: provider.onSearchChanged,
                              onFilterTap: () => _openFilterDialog(provider),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Container(
                                  width: 70,
                                  height: 44,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xFFCCCCCC),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      value: provider.selectedLimit,
                                      isExpanded: true,
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down,
                                      ),
                                      items: limitOptions.map((e) {
                                        return DropdownMenuItem<int>(
                                          value: e,
                                          child: Text(
                                            '$e',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        if (value != null) {
                                          provider.onLimitChanged(value);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                if (provider.hasActiveFilter)
                                  Expanded(
                                    child: Container(
                                      height: 44,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE9F4F0),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFF4F8A78),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.filter_alt_outlined,
                                            size: 18,
                                            color: Color(0xFF4F8A78),
                                          ),
                                          const SizedBox(width: 8),
                                          const Expanded(
                                            child: Text(
                                              'Filter aktif',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF4F8A78),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: provider.resetFilter,
                                            child: const Icon(
                                              Icons.close,
                                              size: 18,
                                              color: Color(0xFF4F8A78),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 22),
                            Expanded(
                              child: Stack(
                                children: [
                                  _buildBody(provider),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: IgnorePointer(
                                      child: AnimatedOpacity(
                                        duration:
                                        const Duration(milliseconds: 180),
                                        opacity: _showTopFade ? 1 : 0,
                                        child: Container(
                                          height: 22,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0xDDF5F5F5),
                                                Color(0x00F5F5F5),
                                              ],
                                              stops: [0.0, 1.0],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: IgnorePointer(
                                      child: AnimatedOpacity(
                                        duration:
                                        const Duration(milliseconds: 180),
                                        opacity: _showBottomFade ? 1 : 0,
                                        child: Container(
                                          height: 24,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Color(0x00F5F5F5),
                                                Color(0xDDF5F5F5),
                                              ],
                                              stops: [0.0, 1.0],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(RiwayatProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          provider.errorMessage,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    if (provider.visibleItems.isEmpty) {
      return const Center(
        child: Text(
          'Data riwayat tidak ditemukan.',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      itemCount: provider.visibleItems.length,
      padding: const EdgeInsets.only(bottom: 24),
      separatorBuilder: (_, __) => const SizedBox(height: 22),
      itemBuilder: (context, index) {
        final item = provider.visibleItems[index];

        return RiwayatAnalysisCard(
          item: item,
          onTapHasilAnalisis: () {
            context.push('/hasil-analisis/${item.idAnalisis}');
          },
        );
      },
    );
  }
}