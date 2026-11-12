import 'referensi_deteksi.dart';

enum StatusDeteksi {
  sehat('Sehat'),
  tidakPasti('Tidak Pasti'),
  perluTindakan('Perlu Tindakan');

  const StatusDeteksi(this.label);

  final String label;
}

double? bacaSkorDeteksi(String teks) {
  final skor = double.tryParse(teks.trim().replaceAll(',', '.'));

  if (skor == null || !skor.isFinite || skor < 0 || skor > 100) {
    return null;
  }

  return skor;
}

class HasilDeteksi {
  const HasilDeteksi({
    required this.petak,
    required this.kelas,
    required this.skor,
    required this.namaPetugas,
    required this.waktu,
  }) : assert(skor >= 0 && skor <= 100);

  final String petak;
  final String kelas;
  final double skor;
  final String namaPetugas;
  final DateTime waktu;

  StatusDeteksi get status {
    if (kelas == kelasNormal) return StatusDeteksi.sehat;
    if (skor < 50) return StatusDeteksi.tidakPasti;
    return StatusDeteksi.perluTindakan;
  }

  String get rekomendasi => switch (status) {
    StatusDeteksi.sehat => rekomendasiPenanganan[kelasNormal]!,
    StatusDeteksi.tidakPasti => 'Cek ulang oleh petugas',
    StatusDeteksi.perluTindakan =>
      'Segera tangani: ${rekomendasiPenanganan[kelas]!}',
  };

  String get skorTeks {
    if (skor == skor.truncateToDouble()) return '${skor.toInt()}%';
    return '${skor.toString().replaceAll('.', ',')}%';
  }
}
