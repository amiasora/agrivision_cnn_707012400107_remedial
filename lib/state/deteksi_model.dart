import 'package:flutter/foundation.dart';

import '../models/hasil_deteksi.dart';
import '../models/referensi_deteksi.dart';

class DeteksiModel extends ChangeNotifier {
  final List<HasilDeteksi> _riwayat = [];
  String? _filterPetak;
  bool _modeGelap = false;

  String? get filterPetak => _filterPetak;
  bool get modeGelap => _modeGelap;

  List<HasilDeteksi> get riwayatTerfilter {
    final petak = _filterPetak;

    return List<HasilDeteksi>.unmodifiable(
      petak == null ? _riwayat : _riwayat.where((data) => data.petak == petak),
    );
  }

  ({int total, int sehat, int perluTindakan}) get ringkasan {
    final daftar = riwayatTerfilter;
    return (
      total: daftar.length,
      sehat: daftar.where((data) => data.status == StatusDeteksi.sehat).length,
      perluTindakan: _hitungPerluTindakan(daftar),
    );
  }

  int get jumlahPerluTindakan => _hitungPerluTindakan(_riwayat);

  int _hitungPerluTindakan(Iterable<HasilDeteksi> daftar) {
    return daftar
        .where((data) => data.status == StatusDeteksi.perluTindakan)
        .length;
  }

  Map<String, int> get jumlahPerKelas {
    final jumlah = {for (final kelas in rekomendasiPenanganan.keys) kelas: 0};

    for (final data in _riwayat) {
      jumlah[data.kelas] = jumlah[data.kelas]! + 1;
    }

    return jumlah;
  }

  void tambah(HasilDeteksi data) {
    _riwayat.insert(0, data);
    notifyListeners();
  }

  void tambahSemua(List<HasilDeteksi> daftar) {
    if (daftar.isEmpty) return;
    _riwayat.insertAll(0, daftar);
    notifyListeners();
  }

  void hapus(HasilDeteksi data) {
    if (_riwayat.remove(data)) notifyListeners();
  }

  void hapusSemua() {
    if (_riwayat.isEmpty) return;
    _riwayat.clear();
    notifyListeners();
  }

  void pilihPetak(String? petak) {
    if (_filterPetak == petak) return;
    _filterPetak = petak;
    notifyListeners();
  }

  void ubahModeGelap(bool aktif) {
    if (_modeGelap == aktif) return;
    _modeGelap = aktif;
    notifyListeners();
  }
}
