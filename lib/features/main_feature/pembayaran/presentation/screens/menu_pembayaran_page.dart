import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/app_background.dart';
import '../../providers/pembayaran_controller.dart';

class MenuPembayaranPage extends ConsumerWidget {
  final String pembayaranId;

  const MenuPembayaranPage({
    super.key,
    required this.pembayaranId,
  });

  Widget _buildField({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 360;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: isSmall ? 24 : 28,
              color: const Color(0xFF4A4A4A),
            ),
            SizedBox(width: isSmall ? 6 : 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: isSmall ? 14 : 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF4A4A4A),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isSmall ? 14 : 16,
            vertical: isSmall ? 12 : 14,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFEDEDED),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFC9C9C9)),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: isSmall ? 13 : 14,
              color: const Color(0xFF7A7A7A),
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(pembayaranControllerProvider.notifier);
    final item = notifier.findById(pembayaranId);

    if (item == null) {
      return const Scaffold(
        body: Center(
          child: Text('Pembayaran tidak ditemukan'),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 360;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isSmall ? 16 : 20,
                  18,
                  isSmall ? 16 : 20,
                  8,
                ),
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () => context.pop(),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.arrow_back,
                          size: isSmall ? 30 : 36,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Pembayaran',
                          style: TextStyle(
                            fontSize: isSmall ? 22 : 28,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF333333),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: isSmall ? 34 : 40),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    isSmall ? 14 : 18,
                    14,
                    isSmall ? 14 : 18,
                    24,
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      isSmall ? 14 : 18,
                      isSmall ? 16 : 18,
                      isSmall ? 14 : 18,
                      isSmall ? 20 : 24,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(isSmall ? 24 : 30),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: isSmall ? 190 : 230,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFCFCFCF)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sebaran',
                                style: TextStyle(
                                  fontSize: isSmall ? 11 : 12,
                                  color: const Color(0xFF444444),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: isSmall ? 8 : 10),
                              Icon(
                                Icons.scatter_plot_outlined,
                                size: isSmall ? 82 : 100,
                                color: const Color(0xFF4F8A78),
                              ),
                              SizedBox(height: isSmall ? 8 : 10),
                              Text(
                                'Preview peta / chart placeholder',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isSmall ? 11 : 12,
                                  color: const Color(0xFF777777),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: isSmall ? 42 : 46,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Lihat peta masih placeholder'),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3E7F69),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Lihat Peta',
                                style: TextStyle(
                                  fontSize: isSmall ? 13.5 : 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildField(
                          context: context,
                          icon: Icons.forest_outlined,
                          label: 'Kebun',
                          value: item.kebun,
                        ),
                        const SizedBox(height: 16),
                        _buildField(
                          context: context,
                          icon: Icons.location_on_outlined,
                          label: 'Lokasi',
                          value: item.lokasi,
                        ),
                        const SizedBox(height: 16),
                        _buildField(
                          context: context,
                          icon: Icons.park_outlined,
                          label: 'Harga Per Satuan Pohon',
                          value: notifier.formatCurrency(item.hargaPerSatuanPohon),
                        ),
                        const SizedBox(height: 16),
                        _buildField(
                          context: context,
                          icon: Icons.park_outlined,
                          label: 'Total Pohon',
                          value: item.totalPohon.toString(),
                        ),
                        const SizedBox(height: 16),
                        _buildField(
                          context: context,
                          icon: Icons.pie_chart_outline,
                          label: 'Perkiraan Luas',
                          value: '${item.perkiraanLuasHa.toStringAsFixed(2)} Ha',
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Sub Total',
                          style: TextStyle(
                            fontSize: isSmall ? 14 : 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF4A4A4A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmall ? 14 : 16,
                            vertical: isSmall ? 12 : 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDEDED),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFC9C9C9)),
                          ),
                          child: Text(
                            notifier.formatCurrency(item.subTotal),
                            style: TextStyle(
                              fontSize: isSmall ? 13 : 14,
                              color: const Color(0xFF7A7A7A),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final localSmall = constraints.maxWidth < 360;
                            final buttonHeight = localSmall ? 42.0 : 48.0;
                            final fontSize = localSmall ? 11.5 : 13.5;

                            return Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: buttonHeight,
                                    child: ElevatedButton(
                                      onPressed: () => context.pop(),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFFF5B57),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'Batalkan',
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: fontSize,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: localSmall ? 16 : 24),
                                Expanded(
                                  child: SizedBox(
                                    height: buttonHeight,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        context.push('/proses-pembayaran/$pembayaranId');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF3E7F69),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'Bayar Sekarang',
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: fontSize,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
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