import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../state/deteksi_model.dart';
import 'halaman_beranda.dart';
import 'halaman_deteksi.dart';
import 'halaman_pengaturan.dart';
import 'halaman_statistik.dart';

class KerangkaNavigasi extends StatefulWidget {
  const KerangkaNavigasi({super.key});

  @override
  State<KerangkaNavigasi> createState() => _KerangkaNavigasiState();
}

class _KerangkaNavigasiState extends State<KerangkaNavigasi> {
  int _indeks = 0;

  static const _judul = ['Beranda', 'Deteksi', 'Statistik', 'Pengaturan'];

  static const _halaman = <Widget>[
    HalamanBeranda(),
    HalamanDeteksi(),
    HalamanStatistik(),
    HalamanPengaturan(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AgriVision - ${_judul[_indeks]}')),
      body: SafeArea(
        top: false,
        bottom: false,
        child: IndexedStack(
          index: _indeks,
          sizing: StackFit.expand,
          children: _halaman,
        ),
      ),
      floatingActionButton: _indeks == 1
          ? FloatingActionButton.extended(
              onPressed: () =>
                  Navigator.pushNamed<void>(context, AppRoutes.inputDeteksi),
              icon: const Icon(Icons.add),
              label: const Text('Deteksi Baru'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indeks,
        onDestinationSelected: (indeks) {
          setState(() => _indeks = indeks);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          NavigationDestination(icon: _IkonDeteksi(), label: 'Deteksi'),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Statistik',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}

class _IkonDeteksi extends StatelessWidget {
  const _IkonDeteksi();

  @override
  Widget build(BuildContext context) {
    final jumlah = context.select<DeteksiModel, int>(
      (model) => model.jumlahPerluTindakan,
    );

    return Badge.count(
      count: jumlah,
      isLabelVisible: jumlah > 0,
      child: const Icon(Icons.search),
    );
  }
}
