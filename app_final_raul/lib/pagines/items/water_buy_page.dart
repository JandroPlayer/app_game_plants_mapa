import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/item.dart';
import 'package:flutter_loggin/provider/items_provider.dart';
import 'package:flutter_loggin/provider/provider.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';

class BuyWaterPage extends StatefulWidget {
  @override
  _BuyWaterPageState createState() => _BuyWaterPageState();
}

class _BuyWaterPageState extends State<BuyWaterPage> {
  Map<int, int> productQuantities = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ItemsProvider>(context, listen: false).fetchItems();
    });
  }

  void _updateQuantity(int itemId, int delta) {
    setState(() {
      productQuantities[itemId] = (productQuantities[itemId] ?? 0) + delta;
      if (productQuantities[itemId]! < 0) productQuantities[itemId] = 0;
    });
  }

  bool _hasProductsToBuy() {
    return productQuantities.values.any((quantity) => quantity > 0);
  }

  double _getPriceBySize(String itemName) {
    if (itemName.contains("10L")) return 10.0;
    if (itemName.contains("1,")) return 1.5;
    return 5.0;
  }

  double _calculateItemTotal(Item item) {
    double price = _getPriceBySize(item.nom);
    return (productQuantities[item.id] ?? 0) * item.preu;
  }

  double _calculateTotal(List<Item> waterItems) {
    return waterItems.fold(
        0.0, (total, item) => total + _calculateItemTotal(item));
  }

  void _purchaseItems(double totalCost, Usuari usuari) async {
    if (usuari.btc < totalCost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No tienes suficiente BTC!")),
      );
      return;
    }

    try {
      final itemsProvider = Provider.of<ItemsProvider>(context, listen: false);

      // Iterar sobre cada producto y enviarlo individualmente
      for (var entry in productQuantities.entries) {
        if (entry.value > 0) {
          // Solo productos con cantidad mayor a 0
          await itemsProvider.comprarItem(usuari.id!, entry.key, entry.value);
        }
      }

      // Actualizar UI después de la compra
      setState(() {
        usuari.restarBTC(totalCost); //modificar
        productQuantities.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Compra realizada con éxito!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error en la compra: $e")),
      );
      print('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsProvider = Provider.of<ItemsProvider>(context);
    List<Item> waterItems =
        itemsProvider.items.where((item) => item.tipus == "bebida").toList();
    final Usuari? usuari =
        ModalRoute.of(context)?.settings.arguments as Usuari?;

    if (usuari == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("Error: Usuario no encontrado")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comprar Bebidas'),
        backgroundColor: Colors.teal,
      ),
      body: itemsProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : waterItems.isEmpty
              ? const Center(
                  child: Text(
                  "No hay bebidas disponibles",
                  style: TextStyle(color: Colors.amber, fontSize: 20),
                ))
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: waterItems.map((item) {
                          double itemTotal = _calculateItemTotal(item);
                          return Card(
                            margin: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.network(
                                        item.imatge,
                                        width: 50,
                                        height: 50,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(Icons.local_drink,
                                              size: 50, color: Colors.blue);
                                        },
                                      ),
                                      const SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.nom,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove),
                                                onPressed: () =>
                                                    _updateQuantity(
                                                        item.id!, -1),
                                              ),
                                              Text(
                                                  (productQuantities[item.id] ??
                                                          0)
                                                      .toString()),
                                              IconButton(
                                                icon: const Icon(Icons.add),
                                                onPressed: () =>
                                                    _updateQuantity(
                                                        item.id!, 1),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text("${itemTotal.toStringAsFixed(2)} BTC",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "Total: ${_calculateTotal(waterItems).toStringAsFixed(2)} BTC",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          Text(
                            "Tu saldo: ${usuari.btc.toStringAsFixed(2)} BTC",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _hasProductsToBuy()
                                ? () => _purchaseItems(
                                    _calculateTotal(waterItems), usuari)
                                : null,
                            child: const Text('Comprar'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
