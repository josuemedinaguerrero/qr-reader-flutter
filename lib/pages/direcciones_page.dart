import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';

class DireccionesPage extends StatelessWidget {
  const DireccionesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);

    return ListView.builder(
      itemCount: scanListProvider.scans.length,
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.directions, color: Theme.of(context).primaryColor),
        title: Text(scanListProvider.scans[index].valor),
        subtitle: Text(scanListProvider.scans[index].id.toString()),
        trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
        onTap: () => print(scanListProvider.scans[index].id),
      ),
    );
  }
}
