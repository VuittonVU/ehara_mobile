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
    required String title,
    required List<String> assetPaths,
    required VoidCallback onTapAny,
    double logoHeight = 22,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF454545),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: assetPaths.map((path) {
            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onTapAny,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  path,
                  height: logoHeight,
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

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () => context.pop(),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Image.asset(
                          'assets/icons/arrow_back.png',
                          width: 32,
                          height: 32,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Proses\nPembayaran',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 0.95,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          18,
                          24,
                          18,
                          132 + bottomInset,
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(26),
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
                                  const Text(
                                    'Sub Total',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF444444),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: const Color(0xFFC7C7C7),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            notifier.formatCurrency(item.subTotal),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFF7A7A7A),
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
                                            width: 22,
                                            height: 22,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const Text(
                                        'Order ID:    ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF444444),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          item.orderId,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () =>
                                            _copyText(item.orderId, 'Order ID'),
                                        child: Image.asset(
                                          'assets/icons/copy.png',
                                          width: 22,
                                          height: 22,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 36),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(26),
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
                                  const Text(
                                    'Semua Metode Pembayaran',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  _buildMethodSection(
                                    title: 'QRIS',
                                    assetPaths: const [
                                      'assets/icons/qris.png',
                                    ],
                                    onTapAny: _completePayment,
                                    logoHeight: 20,
                                  ),
                                  _buildMethodSection(
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
                          28,
                          20,
                          28,
                          20 + bottomInset,
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
                            const Text(
                              'Pembayaran akan ditutup dalam:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatDuration(_remaining),
                              style: const TextStyle(
                                fontSize: 22,
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.w800,
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