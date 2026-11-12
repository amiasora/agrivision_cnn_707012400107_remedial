import 'dart:math';

import 'package:agrivision_cnn_707012400107_remedial/main.dart';
import 'package:agrivision_cnn_707012400107_remedial/models/data_simulasi.dart';
import 'package:agrivision_cnn_707012400107_remedial/models/hasil_deteksi.dart';
import 'package:agrivision_cnn_707012400107_remedial/models/referensi_deteksi.dart';
import 'package:agrivision_cnn_707012400107_remedial/state/deteksi_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

HasilDeteksi contoh(String petak, String kelas, double skor) {
  return HasilDeteksi(
    petak: petak,
    kelas: kelas,
    skor: skor,
    namaPetugas: 'Budi',
    waktu: DateTime(2026, 10, 22, 10, 27),
  );
}

void main() {
  test('Skor valid berada dalam rentang 0 sampai 100', () {
    for (final masukan in ['', 'abc', '-1', '101', 'NaN', 'Infinity']) {
      expect(bacaSkorDeteksi(masukan), isNull, reason: masukan);
    }
    expect(bacaSkorDeteksi('0'), 0);
    expect(bacaSkorDeteksi('49,9'), 49.9);
    expect(bacaSkorDeteksi('100'), 100);
  });

  test('Status mengikuti kelas dan batas 50 persen', () {
    final sehat = contoh('Petak 1', kelasNormal, 0);
    final tidakPasti = contoh('Petak 1', 'Hawar daun bakteri', 49.9);
    final perlu = contoh('Petak 2', 'Bercak coklat', 50);

    expect(sehat.status, StatusDeteksi.sehat);
    expect(sehat.rekomendasi, contains('pemantauan rutin'));
    expect(tidakPasti.status, StatusDeteksi.tidakPasti);
    expect(tidakPasti.rekomendasi, 'Cek ulang oleh petugas');
    expect(perlu.status, StatusDeteksi.perluTindakan);
    expect(
      perlu.rekomendasi,
      startsWith('Segera tangani: Tambah pupuk kalium'),
    );
  });

  test('Filter memengaruhi ringkasan, badge dan grafik tetap global', () {
    final model = DeteksiModel();
    addTearDown(model.dispose);

    final perlu = contoh('Petak 2', 'Bercak coklat', 85);
    model.tambah(contoh('Petak 1', kelasNormal, 10));
    model.tambah(perlu);

    model.pilihPetak('Petak 1');
    expect(model.ringkasan, (total: 1, sehat: 1, perluTindakan: 0));
    expect(model.jumlahPerluTindakan, 1);
    expect(model.jumlahPerKelas['Bercak coklat'], 1);

    model.hapus(perlu);
    expect(model.jumlahPerluTindakan, 0);
    expect(model.jumlahPerKelas['Bercak coklat'], 0);

    model.hapusSemua();
    model.pilihPetak(null);
    expect(model.riwayatTerfilter, isEmpty);
  });

  test('Simulasi membuat 10 data dengan skor bulat 30 sampai 99', () {
    final daftar = buatDataSimulasi(acak: Random(7));

    expect(daftar, hasLength(10));
    for (final hasil in daftar) {
      expect(petakSawah, contains(hasil.petak));
      expect(rekomendasiPenanganan.keys, contains(hasil.kelas));
      expect(hasil.skor, inInclusiveRange(30, 99));
      expect(hasil.skor, hasil.skor.truncateToDouble());
    }
  });

  testWidgets('Beranda membuka Tentang dan tab Deteksi membuka form', (
    tester,
  ) async {
    await tester.pumpWidget(const AgriVisionApp());
    await tester.pumpAndSettle();

    expect(find.text('AgriVision - Beranda'), findsOneWidget);
    await tester.tap(find.text('Tentang Aplikasi'));
    await tester.pumpAndSettle();
    expect(find.text('Tentang AgriVision CNN'), findsOneWidget);
    expect(find.text(kelasNormal), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Deteksi'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada data'), findsOneWidget);

    await tester.tap(find.text('Deteksi Baru'));
    await tester.pumpAndSettle();
    expect(find.text('Input Deteksi'), findsOneWidget);

    final tombol = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Simpan'),
    );
    expect(tombol.onPressed, isNull);
  });
}
