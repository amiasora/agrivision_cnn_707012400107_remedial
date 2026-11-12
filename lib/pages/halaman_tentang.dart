import 'package:flutter/material.dart';

import '../models/referensi_deteksi.dart';

class HalamanTentang extends StatelessWidget {
  const HalamanTentang({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang AgriVision CNN')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'AgriVision CNN membantu kelompok tani mencatat hasil '
              'prediksi penyakit padi serta memantau riwayat dan statistik '
              'di Petak 1 dan Petak 2. Hasil prediksi EfficientNet-B0 '
              'dimasukkan secara manual untuk simulasi praktikum.',
            ),
            const SizedBox(height: 16),
            Text(
              'Kelas Prediksi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            for (final kelas in rekomendasiPenanganan.keys)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  kelas == kelasNormal
                      ? Icons.check_circle_outline
                      : Icons.eco_outlined,
                ),
                title: Text(kelas),
              ),
          ],
        ),
      ),
    );
  }
}
