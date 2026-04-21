import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/app_background.dart';
import '../../providers/pembayaran_controller.dart';

class ProsesPembayaranPage extends ConsumerStatefulWidget {
  final String pembayaranId;

  const ProsesPembayaranPage({
    super.key,
    required this.pembayaranId,
  });

  @override
  ConsumerState<ProsesPembayaranPage> createState() =>
      _ProsesPembayaranPageState();
}

class _ProsesPembayaranPageState extends ConsumerState<ProsesPembayaranPage> {
  Duration _remaining = const Duration(hours: 23, minutes: 59, seconds: 59);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      if (_remaining.inSeconds <= 1) {
        _timer?.cancel();
        setState(() {
          _remaining = Duration.zero;
        });
        return;
      }

      setState(() {
        _remaining -= const Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration value) {
    final h = value.inHours.toString().padLeft(2, '0');
    final m = (value.inMinutes % 60).toString().padLeft(2, '0');
    final s = (value.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  Future<void> _copyText(String text, String label) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label berhasil disalin'),
      ),
    );
  }

  Widget _buildMethodSection({
    required BuildContext context,
    required String title,
    required List<String> assetPaths,
    required VoidCallback onTapAny,
    double logoHeight = 22,
  }) {
    final isSmall = MediaQuery.of(context).size.width < 360;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isSmall ? 14 : 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF454545),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: isSmall ? 8 : 12,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: assetPaths.map((path) {
            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onTapAny,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmall ? 6 : 8,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  path,
                  height: isSmall ? logoHeight - 2 : logoHeight,
                  fit: BoxFit.contain,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 1.2,
          color: const Color(0xFFBEBEBE),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  void _completePayment() {
    ref.read(pembayaranControllerProvider.notifier).markAsPaid(widget.pembayaranId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pembayaran berhasil disimulasikan'),
      ),
    );

    context.pop();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(pembayaranControllerProvider.notifier);
    final item = notifier.findById(widget.pembayaranId);

    if (item == null) {
      return const Scaffold(
        body: Center(
          child: Text('Pembayaran tidak ditemukan'),
        ),
      );
    }

    final bottomInset = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 360;

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          bottom: false,
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
                        child: Image.asset(
                          'assets/icons/arrow_back.png',
                          width: isSmall ? 28 : 32,
                          height: isSmall ? 28 : 32,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Proses\nPembayaran',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 0.98,
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
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          isSmall ? 14 : 18,
                          24,
                          isSmall ? 14 : 18,
                          132 + bottomInset,
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.fromLTRB(
                                isSmall ? 14 : 18,
                                isSmall ? 18 : 22,
                                isSmall ? 14 : 18,
                                isSmall ? 18 : 20,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(isSmall ? 22 : 26),
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
                                  Text(
                                    'Sub Total',
                                    style: TextStyle(
                                      fontSize: isSmall ? 15 : 16,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF444444),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isSmall ? 14 : 18,
                                      vertical: isSmall ? 12 : 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color(0xFFC7C7C7),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            notifier.formatCurrency(item.subTotal),
                                            style: TextStyle(
                                              fontSize: isSmall ? 13.5 : 15,
                                              color: const Color(0xFF7A7A7A),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => _copyText(
                                            notifier.formatCurrency(item.subTotal),
                                            'Sub total',
                                          ),
                                          child: Image.asset(
                                            'assets/icons/copy.png',
                                            width: isSmall ? 20 : 22,
                                            height: isSmall ? 20 : 22,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Text(
                                        'Order ID:    ',
                                        style: TextStyle(
                                          fontSize: isSmall ? 14 : 16,
                                          color: const Color(0xFF444444),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          item.orderId,
                                          style: TextStyle(
                                            fontSize: isSmall ? 14 : 16,
                                            color: const Color(0xFF555555),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () =>
                                            _copyText(item.orderId, 'Order ID'),
                                        child: Image.asset(
                                          'assets/icons/copy.png',
                                          width: isSmall ? 20 : 22,
                                          height: isSmall ? 20 : 22,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: isSmall ? 28 : 36),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.fromLTRB(
                                isSmall ? 14 : 18,
                                isSmall ? 18 : 22,
                                isSmall ? 14 : 18,
                                isSmall ? 16 : 18,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(isSmall ? 22 : 26),
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
                                  Text(
                                    'Semua Metode Pembayaran',
                                    style: TextStyle(
                                      fontSize: isSmall ? 15 : 16,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF333333),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  _buildMethodSection(
                                    context: context,
                                    title: 'QRIS',
                                    assetPaths: const [
                                      'assets/icons/qris.png',
                                    ],
                                    onTapAny: _completePayment,
                                    logoHeight: 20,
                                  ),
                                  _buildMethodSection(
                                    context: context,
                                    title: 'Virtual Account',
                                    assetPaths: const [
                                      'assets/icons/mandiri.png',
                                      'assets/icons/bni.png',
                                      'assets/icons/permata.png',
                                    ],
                                    onTapAny: _completePayment,
                                    logoHeight: 20,
                                  ),
                                  _buildMethodSection(
                                    context: context,
                                    title: 'GoPay',
                                    assetPaths: const [
                                      'assets/icons/gopay.png',
                                    ],
                                    onTapAny: _completePayment,
                                    logoHeight: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                          isSmall ? 20 : 28,
                          isSmall ? 16 : 20,
                          isSmall ? 20 : 28,
                          (isSmall ? 16 : 20) + bottomInset,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          border: Border(
                            top: BorderSide(
                              color: Color(0xFFBDBDBD),
                              width: 1,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x22000000),
                              blurRadius: 10,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Pembayaran akan ditutup dalam:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isSmall ? 14 : 16,
                                color: const Color(0xFF333333),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                _formatDuration(_remaining),
                                style: TextStyle(
                                  fontSize: isSmall ? 20 : 22,
                                  color: const Color(0xFF333333),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}