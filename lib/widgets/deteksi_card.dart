import 'package:flutter/material.dart';

import '../models/hasil_deteksi.dart';

class DeteksiCard extends StatelessWidget {
  const DeteksiCard({super.key, required this.hasil, required this.onHapus});

  final HasilDeteksi hasil;
  final VoidCallback onHapus;

  String _formatWaktu(DateTime waktu) {
    final lokal = waktu.toLocal();
    String duaDigit(int angka) => angka.toString().padLeft(2, '0');

    return '${duaDigit(lokal.day)}/${duaDigit(lokal.month)}/${lokal.year} '
        '${duaDigit(lokal.hour)}:${duaDigit(lokal.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;
    final status = hasil.status;

    final (ikon, latar, teks) = switch (status) {
      StatusDeteksi.sehat => (
        Icons.check_circle_outline,
        warna.primaryContainer,
        warna.onPrimaryContainer,
      ),
      StatusDeteksi.tidakPasti => (
        Icons.help_outline,
        warna.tertiaryContainer,
        warna.onTertiaryContainer,
      ),
      StatusDeteksi.perluTindakan => (
        Icons.warning_amber_rounded,
        warna.errorContainer,
        warna.onErrorContainer,
      ),
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${hasil.petak} - ${hasil.kelas}',
                    style: tema.textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: onHapus,
                  tooltip: 'Hapus deteksi',
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            Chip(
              avatar: Icon(ikon, size: 18, color: teks),
              label: Text(status.label, style: TextStyle(color: teks)),
              backgroundColor: latar,
              side: BorderSide.none,
            ),
            const SizedBox(height: 8),
            Text('Skor: ${hasil.skorTeks}'),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: hasil.skor / 100,
              minHeight: 6,
              color: teks,
              backgroundColor: latar,
            ),
            const SizedBox(height: 12),
            Text(hasil.rekomendasi),
            const SizedBox(height: 8),
            Text(
              '${hasil.namaPetugas} · ${_formatWaktu(hasil.waktu)}',
              style: tema.textTheme.bodySmall?.copyWith(
                color: warna.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
