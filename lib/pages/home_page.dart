import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:qr_reader/models/scan_model.dart';
import 'package:qr_reader/pages/direcciones_page.dart';
import 'package:qr_reader/pages/mapas_page.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';
import 'package:qr_reader/widgets/custom_navigatorbar.dart';
import 'package:qr_reader/widgets/scan_button.dart';

import 'package:qr_reader/providers/db_provider.dart' as db_provider;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Historial'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () => Provider.of<ScanListProvider>(context, listen: false).borrarTodos(),
          ),
        ],
      ),
      body: _HomePageBody(),
      bottomNavigationBar: const CustomNavigationBar(),
      floatingActionButton: const ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);

    final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);

    switch (uiProvider.selectedMenuOpt) {
      case 0:
        scanListProvider.cargarScanPorTipo('geo');
        return const MapasPage();
      case 1:
        scanListProvider.cargarScanPorTipo('http');
        return const DireccionesPage();
      default:
        return const MapasPage();
    }
  }
}
