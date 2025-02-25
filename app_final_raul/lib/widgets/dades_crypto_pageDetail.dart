// El widget `dadesCryptoPageDetail` mostra diverses dades detallades d'una criptomoneda en una pàgina de detall. Utilitza el widget `DetailRowWidget` per mostrar informació com el preu actual, canvi en 24 hores, màxim i mínim de 24 hores, capitalització de mercat, circulant i total supply, així com l'última actualització. Les dades es mostren amb espais entre cada fila per facilitar la lectura.

import 'package:flutter/material.dart';
import 'package:flutter_loggin/widgets/detail_row_widget.dart';
import '../models/crypto.dart';

class dadesCryptoPageDetail extends StatelessWidget {
  const dadesCryptoPageDetail({
    super.key,
    required this.crypto,
  });

  final Crypto crypto;

  String formatMarketCap(double marketCap) {
    if (marketCap >= 1e12) {
      // Trillions (T)
      return '\$${(marketCap / 1e12).toStringAsFixed(2)} T';
    } else if (marketCap >= 1e9) {
      // Billions (B)
      return '\$${(marketCap / 1e9).toStringAsFixed(2)} B';
    } else if (marketCap >= 1e6) {
      // Millions (M)
      return '\$${(marketCap / 1e6).toStringAsFixed(2)} M';
    } else {
      return '\$${marketCap.toStringAsFixed(2)}'; // Mantener sin formato
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          DetailRowWidget(
            label: 'Preu actual',
            value: '\$${crypto.currentPrice}',
          ),
          const SizedBox(height: 10),
          // Cambio de precio en 24h con color dinámico
          DetailRowWidget(
            label: 'Canvi en 24h',
            value: '${crypto.priceChangePercentage24h}%',
            isPercentage: true,
          ),
          const SizedBox(height: 10),
          // Preu maxim ultimes 24h
          DetailRowWidget(
            label: 'Maxim en 24h',
            value: '\$${crypto.high24h}',
          ),
          const SizedBox(height: 10),
          // Preu minim ultimes 24h
          DetailRowWidget(
            label: 'Minim en 24h',
            value: '\$${crypto.low24h}',
          ),
          const SizedBox(height: 10),
          // Capitalizació de mercat(diners d'intre de la criptomoneda)
          DetailRowWidget(
            label: 'Cap. de mercat',
            value: formatMarketCap(crypto.marketCap),
          ),

          const SizedBox(height: 10),
          // Supply Circulant
          DetailRowWidget(
              label: 'Supply Circulant',
              value: formatMarketCap(crypto.circulatingSupply)),
          const SizedBox(height: 10),
          // Total supply de la criptomoneda
          DetailRowWidget(
              label: 'Supply Total',
              value: formatMarketCap(crypto.totalSupply)),
          const SizedBox(height: 10),
          // Ultima actualització de les dades
          DetailRowWidget(
            label: 'Ultima actualizació',
            value: crypto.lastUpdated.substring(11, 19) ?? 'No disponible',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
