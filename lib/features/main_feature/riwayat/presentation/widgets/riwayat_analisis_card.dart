import 'package:flutter/material.dart';
import '../../models/riwayat_item_model.dart';
import 'riwayat_sertifikat_status.dart';

class RiwayatAnalysisCard extends StatelessWidget {
  final RiwayatItemModel item;
  final VoidCallback onTapHasilAnalisis;

  const RiwayatAnalysisCard({
    super.key,
    required this.item,
    required this.onTapHasilAnalisis,
  });

  Widget _buildInfoRow({
    required IconData icon,
    required Widget child,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF4D4D4D)),
        const SizedBox(width: 10),
        Expanded(child: child),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    return '$d-$m-$y';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
      child: Column(
        children: [
          Text(
            item.namaProyek,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFFD3D3D3), thickness: 1),

          _buildInfoRow(
            icon: Icons.calendar_month_outlined,
            child: Text(
              _formatDate(item.tanggalAnalisis),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 14),

          _buildInfoRow(
            icon: Icons.business_outlined,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                  fontFamily: 'Roboto',
                ),
                children: [
                  const TextSpan(
                    text: 'Perusahaan: ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: item.namaPerusahaan),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          _buildInfoRow(
            icon: Icons.person_outline,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                  fontFamily: 'Roboto',
                ),
                children: [
                  const TextSpan(
                    text: 'Customer: ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: item.namaCustomer),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          _buildInfoRow(
            icon: Icons.fence_outlined,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                  fontFamily: 'Roboto',
                ),
                children: [
                  const TextSpan(
                    text: 'Kebun: ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: item.namaKebun),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          _buildInfoRow(
            icon: Icons.location_on_outlined,
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                  fontFamily: 'Roboto',
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text: 'Alamat: ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: item.alamatLengkap),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          _buildInfoRow(
            icon: Icons.verified_outlined,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nomor Sertifikat: ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333333),
                  ),
                ),
                Expanded(
                  child: RiwayatCertificateStatus(
                    isTerbit: item.isSertifikatTerbit,
                    label: item.statusSertifikat,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          SizedBox(
            width: 220,
            height: 46,
            child: ElevatedButton(
              onPressed: onTapHasilAnalisis,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F8A78),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Hasil Analisis',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}