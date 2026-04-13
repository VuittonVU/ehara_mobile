import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/app_background.dart';
import '../../providers/pembayaran_provider.dart';

class ProsesPembayaranPage extends StatefulWidget {
  final String pembayaranId;

  const ProsesPembayaranPage({
    super.key,
    required this.pembayaranId,
  });

  @override
  State<ProsesPembayaranPage> createState() => _ProsesPembayaranPageState();
}

class _ProsesPembayaranPageState extends State<ProsesPembayaranPage> {
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

  Widget _buildMethodSection({
    required String title,
    required List<String> items,
    required VoidCallback onTapAny,
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
          spacing: 10,
          runSpacing: 10,
          children: items.map((e) {
            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onTapAny,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  e,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2F2F2F),
                  ),
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
    context.read<PembayaranProvider>().markAsPaid(widget.pembayaranId);

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
    final provider = context.watch<PembayaranProvider>();
    final item = provider.visibleItems.cast<dynamic?>().firstWhere(
          (e) => e?.id == widget.pembayaranId,
      orElse: () => null,
    ) ??
        provider.visibleItems.isNotEmpty
        ? provider.visibleItems.firstWhere(
          (e) => e.id == widget.pembayaranId,
      orElse: () => throw Exception('Pembayaran tidak ditemukan'),
    )
        : throw Exception('Pembayaran tidak ditemukan');

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () => context.pop(),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.arrow_back,
                          size: 36,
                          color: Colors.black,
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
                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 24, 18, 120),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
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
                                          provider.formatCurrency(item.subTotal),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF7A7A7A),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.copy_rounded,
                                        size: 22,
                                        color: Color(0xFF0F5E74),
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
                                    Text(
                                      item.orderId,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.copy_rounded,
                                      size: 22,
                                      color: Color(0xFF0F5E74),
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
                              color: const Color(0xFFF5F5F5),
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
                                  items: const ['QRIS'],
                                  onTapAny: _completePayment,
                                ),
                                _buildMethodSection(
                                  title: 'Virtual Account',
                                  items: const ['mandiri', 'BNI', 'PermataBank'],
                                  onTapAny: _completePayment,
                                ),
                                _buildMethodSection(
                                  title: 'GoPay',
                                  items: const ['gopay'],
                                  onTapAny: _completePayment,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(28, 26, 28, 26),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(22),
                          ),
                          border: Border.all(
                            color: const Color(0xFFBDBDBD),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Pembayaran akan ditutup dalam:   ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              _formatDuration(_remaining),
                              style: const TextStyle(
                                fontSize: 16,
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