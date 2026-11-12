import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/hasil_deteksi.dart';
import '../models/referensi_deteksi.dart';
import '../state/deteksi_model.dart';

class HalamanInputDeteksi extends StatefulWidget {
  const HalamanInputDeteksi({super.key});

  @override
  State<HalamanInputDeteksi> createState() => _HalamanInputDeteksiState();
}

class _HalamanInputDeteksiState extends State<HalamanInputDeteksi> {
  final _skorController = TextEditingController();
  final _namaController = TextEditingController();

  String _petak = petakSawah.first;
  String _kelas = rekomendasiPenanganan.keys.first;
  bool _dataBenar = false;
  bool _konfirmasiTerbuka = false;
  String? _errorSkor;
  String? _errorNama;

  @override
  void dispose() {
    _skorController.dispose();
    _namaController.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_dataBenar || _konfirmasiTerbuka) return;

    final skor = bacaSkorDeteksi(_skorController.text);
    final nama = _namaController.text.trim();

    setState(() {
      _errorSkor = skor == null ? 'Masukkan angka dari 0 sampai 100.' : null;
      _errorNama = nama.isEmpty ? 'Nama petugas wajib diisi.' : null;
    });
    if (skor == null || nama.isEmpty) return;

    FocusScope.of(context).unfocus();
    setState(() => _konfirmasiTerbuka = true);

    final disetujui = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Simpan hasil deteksi?'),
        content: Text(
          '$_petak - $_kelas\n'
          'Skor: ${_skorController.text.trim()}%\n'
          'Petugas: $nama',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    if (disetujui != true) {
      setState(() => _konfirmasiTerbuka = false);
      return;
    }

    context.read<DeteksiModel>().tambah(
      HasilDeteksi(
        petak: _petak,
        kelas: _kelas,
        skor: skor,
        namaPetugas: nama,
        waktu: DateTime.now(),
      ),
    );

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(const SnackBar(content: Text('Data tersimpan')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Input Deteksi')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Petak', style: tema.textTheme.titleMedium),
            RadioGroup<String>(
              groupValue: _petak,
              onChanged: (nilai) {
                if (nilai != null) setState(() => _petak = nilai);
              },
              child: Column(
                children: [
                  for (final petak in petakSawah)
                    RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      value: petak,
                      title: Text(petak),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _kelas,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Kelas',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final kelas in rekomendasiPenanganan.keys)
                  DropdownMenuItem(
                    value: kelas,
                    child: Text(kelas, overflow: TextOverflow.ellipsis),
                  ),
              ],
              onChanged: (nilai) {
                if (nilai != null) setState(() => _kelas = nilai);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _skorController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Skor Deteksi (%)',
                errorText: _errorSkor,
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) {
                if (_errorSkor != null) setState(() => _errorSkor = null);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _namaController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Nama Petugas',
                errorText: _errorNama,
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) {
                if (_errorNama != null) setState(() => _errorNama = null);
              },
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Data sudah benar'),
              value: _dataBenar,
              onChanged: (nilai) {
                setState(() => _dataBenar = nilai ?? false);
              },
            ),
            FilledButton(
              onPressed: _dataBenar && !_konfirmasiTerbuka ? _simpan : null,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
