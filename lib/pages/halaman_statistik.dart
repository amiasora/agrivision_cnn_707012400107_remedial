import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/referensi_deteksi.dart';
import '../state/deteksi_model.dart';

class HalamanStatistik extends StatelessWidget {
  const HalamanStatistik({super.key});

  static const _label = <String, String>{
    'Hawar daun bakteri': 'Hawar',
    'Penyakit blas (jamur)': 'Blas',
    'Bercak coklat': 'Bercak',
    kelasNormal: 'Normal',
    'Penyakit tungro (virus)': 'Tungro',
  };

  @override
  Widget build(BuildContext context) {
    final jumlah = context.select<DeteksiModel, Map<String, int>>(
      (model) => model.jumlahPerKelas,
    );
    final data = jumlah.entries.toList();
    final tema = Theme.of(context);
    final warna = tema.colorScheme;
    final gayaLabel = TextStyle(fontSize: 11, color: warna.onSurface);
    final ukuranLabel = MediaQuery.textScalerOf(context).scale(11);

    final puncak = jumlah.values.fold<int>(0, (a, b) => max(a, b));
    final interval = max(1, (puncak / 5).ceil()).toDouble();
    final batasY = puncak == 0
        ? 1.0
        : interval * (puncak / interval).ceilToDouble();

    final grafik = BarChart(
      BarChartData(
        minY: 0,
        maxY: batasY,
        alignment: BarChartAlignment.spaceEvenly,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (_) => FlLine(
            color: warna.outlineVariant,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: interval,
              reservedSize: max<double>(
                32,
                (puncak.toString().length + 1) * ukuranLabel,
              ),
              getTitlesWidget: (nilai, meta) => SideTitleWidget(
                meta: meta,
                space: 5,
                child: Text('${nilai.toInt()}', style: gayaLabel),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: max<double>(28, ukuranLabel * 2.1),
              getTitlesWidget: (nilai, meta) {
                final indeks = nilai.toInt();

                if (indeks < 0 || indeks >= data.length) {
                  return const SizedBox.shrink();
                }

                return SideTitleWidget(
                  meta: meta,
                  space: 8,
                  child: Text(_label[data[indeks].key]!, style: gayaLabel),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (var indeks = 0; indeks < data.length; indeks++)
            BarChartGroupData(
              x: indeks,
              barRods: [
                BarChartRodData(
                  toY: data[indeks].value.toDouble(),
                  width: 18,
                  color: warna.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            ),
        ],
      ),
    );

    return ListView(
      primary: false,
      padding: const EdgeInsets.all(16),
      children: [
        Text('Jumlah Deteksi per Kelas', style: tema.textTheme.titleLarge),
        const SizedBox(height: 12),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 24, 12, 8),
            child: LayoutBuilder(
              builder: (context, batas) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: max<double>(
                    batas.maxWidth,
                    max<double>(280, ukuranLabel * 25),
                  ),
                  height: 300,
                  child: grafik,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}