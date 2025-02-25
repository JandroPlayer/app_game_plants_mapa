import 'dart:convert';

class Item {
  final int id;
  final String nom;
  final String? descripcio;
  final String tipus;
  final String? efecte;
  final String imatge;
  final double preu;

  // Constructor
  Item({
    required this.id,
    required this.nom,
    this.descripcio,
    required this.tipus,
    this.efecte,
    required this.imatge,
    required this.preu,
  });

  // Convertir el objeto a un mapa (representación JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'descripcio': descripcio,
      'tipus': tipus,
      'efecte': efecte,
      'imatge': imatge,
      'preu': preu,
    };
  }

  // Convertir el objeto a JSON
  String toJson() => json.encode(toMap());

  // Crear un objeto Item desde un mapa (como el que obtendrás de la base de datos o de una API)
  // Crear un objeto Item desde un mapa (como el que obtendrás de la base de datos o de una API)
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      nom: map['nom'],
      descripcio: map['descripcio'],
      tipus: map['tipus'],
      efecte: map['efecte'],
      imatge: map['imatge'],
      preu: _parsePreu(map['preu']), // Convertimos preu a double
    );
  }

// Función auxiliar para convertir preu a double
  static double _parsePreu(dynamic preu) {
    if (preu is String) {
      return double.tryParse(preu) ??
          0.0; // Convertir el string a double, y si no es posible, asignar 0.0
    } else if (preu is double) {
      return preu; // Si ya es un double, simplemente lo retornamos
    }
    return 0.0; // Valor por defecto en caso de que no sea ni String ni double
  }

  // Crear un objeto Item desde un JSON
  factory Item.fromJson(String source) => Item.fromMap(json.decode(source));
}
