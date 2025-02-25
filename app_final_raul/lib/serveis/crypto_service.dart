// NO UTILITZAT EN AQUESTA VERSIÓ DE L'APLICACIÓ
// Aquest arxiu conté la classe CryptoService.

// La classe CryptoService gestiona les crides a l'API de CoinGecko per obtenir dades sobre criptomonedes i memecoins populars. També té un mètode per obtenir NFTs des d'OpenSea (actualment no disponible).

import 'dart:convert';
import 'package:http/http.dart' as http;

class CryptoService {
  // Metode per a obtenir les criptomonedes
  Future<List<dynamic>> fetchCryptos() async {
    final url = Uri.https(
      'api.coingecko.com',
      '/api/v3/coins/markets',
      {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'per_page': '100',
        'page': '1',
        'sparkline': 'false',
      },
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al obtener las criptomonedas');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Metode per a obtenir les memecoins mes populars
  Future<List<dynamic>> fetchPopularMemecoins() async {
    final url = Uri.https(
      'api.coingecko.com',
      '/api/v3/coins/markets',
      {
        'vs_currency': 'usd',
        'order': 'market_cap_desc',
        'per_page':
            '10000', // El numero de criptomonedes on buscarem les memecoins
        'page': '1',
        'sparkline': 'false',
      },
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Filtrar por las memecoins populares
        final popularMemecoins = data.where((coin) {
          final name = coin['name'].toLowerCase();
          // Filtrem per noms de memecoins mes populars com aquestes.
          return name.contains('dogecoin') ||
              name.contains('shiba inu') ||
              name.contains('pepe') ||
              name.contains('floki') ||
              name.contains('dogwifhat') ||
              name.contains('bonk') ||
              name.contains('brett') ||
              name.contains('mogcoin') ||
              name.contains('dogs') ||
              name.contains('neiro');
        }).toList();

        return popularMemecoins;
      } else {
        throw Exception('Error al obtener las memecoins');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Metode per a obtener NFTs desde OpenSea ENCARA NO DISPONIBLE ESBORRA ABANS D'ENVIAR
  Future<List<dynamic>> fetchNFTs() async {
    final url = Uri.https('api.opensea.io', '/api/v1/assets', {
      'order_direction': 'desc',
      'limit': '10',
    });

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['assets'] ?? [];
      } else {
        throw Exception('Error al obtener los NFTs');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
