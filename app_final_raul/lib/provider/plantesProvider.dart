import 'package:flutter/material.dart';
import 'package:flutter_loggin/serveis/plantaService.dart';
import '../models/planta.dart';

class PlantaProvider with ChangeNotifier {
  final PlantaService _plantaService = PlantaService();
  List<Planta> _plantas = [];

  List<Planta> get plantas => [..._plantas];

  // Obtenim totes les plantes
  Future<void> fetchPlantas() async {
    try {
      _plantas = await _plantaService.fetchPlantas();
      notifyListeners();
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }

  // Afegim una nova planta
  Future<void> addPlanta(Planta planta) async {
    try {
      final newPlanta = await _plantaService.addPlanta(planta);
      _plantas.add(newPlanta);
      notifyListeners();
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }

  // Actualizam una planta existent
  Future<void> updatePlanta(Planta planta) async {
    try {
      // Pasam l'objecte Planta per a actualitzar
      await _plantaService.updatePlanta(planta);
      final index = _plantas.indexWhere((p) => p.id == planta.id);
      if (index >= 0) {
        _plantas[index] = planta;
        notifyListeners();
      }
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }

  // Eliminam una planta
  Future<void> deletePlanta(int id) async {
    try {
      await _plantaService.deletePlanta(id);
      _plantas.removeWhere((planta) => planta.id == id);
      notifyListeners();
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }
}
