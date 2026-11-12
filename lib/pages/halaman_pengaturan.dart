import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/data_simulasi.dart';
import '../state/deteksi_model.dart';

class HalamanPengaturan extends StatelessWidget {
  const HalamanPengaturan({super.key});

  Future<void> _konfirmasiHapus(BuildContext context) async {
    final setuju = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Semua Data?'),
        content: const Text('Semua riwayat deteksi akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (!context.mounted || setuju != true) return;
    context.read<DeteksiModel>().hapusSemua();
  }

  @override
  Widget build(BuildContext context) {
    final modeGelap = context.select<DeteksiModel, bool>(
      (model) => model.modeGelap,
    );

    return ListView(
      primary: false,
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Mode Gelap'),
          value: modeGelap,
          onChanged: (aktif) {
            context.read<DeteksiModel>().ubahModeGelap(aktif);
          },
        ),
        const SizedBox(height: 12),
        FilledButton.tonal(
          onPressed: () {
            context.read<DeteksiModel>().tambahSemua(buatDataSimulasi());

            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                const SnackBar(content: Text('10 data simulasi dimuat')),
              );
          },
          child: const Text('Muat Data Simulasi'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => _konfirmasiHapus(context),
          child: const Text('Hapus Semua Data'),
        ),
      ],
    );
  }
}
