import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScanTiles extends StatelessWidget {
  final String tipo;

  const ScanTiles({super.key, required this.tipo});

  @override
  Widget build(BuildContext context) {
    final scanListProvider = Provider.of<ScanListProvider>(context);

    return ListView.builder(
      itemCount: scanListProvider.scans.length,
      itemBuilder: (context, index) => Dismissible(
        key: UniqueKey(),
        background: Container(color: Colors.red),
        onDismissed: (DismissDirection direction) {
          Provider.of<ScanListProvider>(context, listen: false)
              .borrarScanPorId(scanListProvider.scans[index].id!);
        },
        child: ListTile(
          leading: Icon(
            tipo == 'http' ? Icons.home_outlined : Icons.map_outlined,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(scanListProvider.scans[index].valor),
          subtitle: Text(scanListProvider.scans[index].id.toString()),
          trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
          onTap: () => print(scanListProvider.scans[index].id),
        ),
      ),
    );
  }
}
