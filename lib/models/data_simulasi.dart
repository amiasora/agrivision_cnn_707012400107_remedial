import 'dart:math';

import 'hasil_deteksi.dart';
import 'referensi_deteksi.dart';

List<HasilDeteksi> buatDataSimulasi({Random? acak}) {
  final random = acak ?? Random();
  final daftarKelas = rekomendasiPenanganan.keys.toList();
  final sekarang = DateTime.now();

  return List<HasilDeteksi>.generate(
    10,
    (indeks) => HasilDeteksi(
      petak: petakSawah[random.nextInt(petakSawah.length)],
      kelas: daftarKelas[random.nextInt(daftarKelas.length)],
      skor: (30 + random.nextInt(70)).toDouble(),
      namaPetugas: 'Petugas Simulasi ${indeks + 1}',
      waktu: sekarang.subtract(Duration(minutes: indeks * 5)),
    ),
  );
}