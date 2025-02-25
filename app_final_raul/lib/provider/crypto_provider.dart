// NO UTILITZAT EN AQUESTA VERSIÓ DE L'APLICACIÓ
//

// Aquesta classe CryptoProvider és un ChangeNotifier que gestiona l'estat de les criptomonedes i els memecoins populars dins d'una aplicació Flutter. Té dues llistes: cryptos per emmagatzemar les criptomonedes i popularMemecoins per emmagatzemar els memecoins populars. La classe carrega les dades mitjançant els mètodes _fetchCryptos i _fetchPopularMemecoins que criden a un servei extern (CryptoService) per obtenir les dades, i un cop obtingudes, actualitza les llistes i notifica que les dades han canviat.

import 'package:flutter/material.dart';
import 'package:flutter_loggin/serveis/crypto_service.dart';
import '../models/crypto.dart';

class CryptoProvider extends ChangeNotifier {
  List<Crypto> cryptos = [];
  List<Crypto> popularMemecoins = [];
  bool isLoading = true;

  CryptoProvider() {
    _fetchData();
  }

  Future<void> _fetchData() async {
    final service = CryptoService();
    await Future.wait([
      _fetchCryptos(service),
      _fetchPopularMemecoins(service),
    ]);
    isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchCryptos(CryptoService service) async {
    final data = await service.fetchCryptos();
    cryptos = data.map<Crypto>((crypto) => Crypto.fromJson(crypto)).toList();
    notifyListeners();
  }

  Future<void> _fetchPopularMemecoins(CryptoService service) async {
    final data = await service.fetchPopularMemecoins();
    popularMemecoins =
        data.map<Crypto>((crypto) => Crypto.fromJson(crypto)).toList();
    notifyListeners();
  }
}
