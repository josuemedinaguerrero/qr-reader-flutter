import 'package:flutter/material.dart';

import 'package:qr_reader/models/scan_model.dart' as scan_model;
import 'package:qr_reader/providers/db_provider.dart' as db_provider;

class ScanListProvider extends ChangeNotifier {
  List<scan_model.ScanModel> scans = [];
  String tipoSeleccionado = 'http';

  nuevoScan(String valor) async {
    final nuevoScan = scan_model.ScanModel(valor: valor);
    final id = await db_provider.DBProvider.db.nuevoScan(nuevoScan);

    nuevoScan.id = id;

    if (tipoSeleccionado == nuevoScan.tipo) {
      scans.add(nuevoScan);
      notifyListeners();
    }
  }

  cargarScans() async {
    final todosScans = await db_provider.DBProvider.db.getTodosLosScans();
    scans = todosScans != null && todosScans.isNotEmpty ? [...todosScans] : [];
    notifyListeners();
  }

  cargarScanPorTipo(String tipo) async {
    final todosScans = await db_provider.DBProvider.db.getScansPorTipo(tipo);
    scans = todosScans != null && todosScans.isNotEmpty ? [...todosScans] : [];
    tipoSeleccionado = tipo;
    notifyListeners();
  }

  borrarTodos() async {
    await db_provider.DBProvider.db.deleteAllScans();
    scans = [];
    notifyListeners();
  }

  borrarScanPorId(int id) async {
    await db_provider.DBProvider.db.deleteScans(id);
    cargarScanPorTipo(tipoSeleccionado);
  }
}
