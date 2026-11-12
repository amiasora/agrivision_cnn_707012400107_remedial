import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/referensi_deteksi.dart';
import '../state/deteksi_model.dart';
import '../widgets/deteksi_card.dart';
import '../widgets/stat_card.dart';

class HalamanDeteksi extends StatelessWidget {
  const HalamanDeteksi({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DeteksiModel>();
    final daftar = model.riwayatTerfilter;
    final ringkasan = model.ringkasan;

    final kepalaDaftar = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Riwayat Deteksi', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final petak in <String?>[null, ...petakSawah])
              ChoiceChip(
                label: Text(petak ?? 'Semua'),
                selected: model.filterPetak == petak,
                onSelected: (dipilih) {
                  if (dipilih) context.read<DeteksiModel>().pilihPetak(petak);
                },
              ),
          ],
        ),
        const SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: StatCard(jumlah: ringkasan.total, label: 'Total'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatCard(jumlah: ringkasan.sehat, label: 'Sehat'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatCard(
                  jumlah: ringkasan.perluTindakan,
                  label: 'Perlu Tindakan',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );

    return ListView.builder(
      primary: false,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      itemCount: daftar.isEmpty ? 2 : daftar.length + 1,
      itemBuilder: (context, indeks) {
        if (indeks == 0) return kepalaDaftar;

        if (daftar.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text('Belum ada data')),
          );
        }

        final hasil = daftar[indeks - 1];
        return DeteksiCard(
          hasil: hasil,
          onHapus: () => context.read<DeteksiModel>().hapus(hasil),
        );
      },
    );
  }
}
