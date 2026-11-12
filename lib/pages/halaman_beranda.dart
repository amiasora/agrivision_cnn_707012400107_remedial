import 'package:flutter/material.dart';

import '../app_routes.dart';

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ListView(
      primary: false,
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Selamat Datang di AgriVision CNN',
          style: tema.textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Card(
          child: ListTile(
            leading: Icon(Icons.eco_outlined, color: tema.colorScheme.primary),
            title: const Text('Model: EfficientNet-B0'),
            subtitle: const Text('5 kelas (4 penyakit + 1 Normal / Sehat)'),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () =>
              Navigator.pushNamed<void>(context, AppRoutes.tentang),
          child: const Text('Tentang Aplikasi'),
        ),
      ],
    );
  }
}
