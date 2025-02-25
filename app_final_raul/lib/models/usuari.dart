class Usuari {
  final int id;
  final String nom;
  final String correu;
  final String contrasenya;
  final int edat;
  final String nacionalitat;
  final String codiPostal;
  final String imatgePerfil;
  double _btc; // Hacer privado para poder modificarlo

  Usuari({
    required this.id,
    required this.nom,
    required this.correu,
    required this.contrasenya,
    required this.edat,
    required this.nacionalitat,
    required this.codiPostal,
    required this.imatgePerfil,
    required double btc,
  }) : _btc = btc;

  double get btc => _btc; // Getter para obtener el valor de btc

  set btc(double valor) {
    if (valor >= 0) {
      _btc = valor;
    } else {
      print('El valor de BTC no puede ser negativo.');
    }
  }

  // Método para restar btc de forma segura
  void restarBTC(double cantidad) {
    if (_btc >= cantidad) {
      _btc -= cantidad;
    } else {
      print('No hay suficiente BTC para restar.');
    }
  }

  // Método para convertir de objeto a JSON
  factory Usuari.fromJson(Map<String, dynamic> json) {
    return Usuari(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      correu: json['correu'] ?? '',
      contrasenya: json['contrasenya'] ?? '',
      edat: json['edat'] ?? 0,
      nacionalitat: json['nacionalitat'] ?? '',
      codiPostal: json['codiPostal'] ?? '',
      imatgePerfil: json['imatgePerfil'] ?? '',
      btc: (json['btc'] is String
              ? double.tryParse(json['btc']) ?? 0.0
              : (json['btc'] is int
                  ? json['btc'].toDouble() // Convierte el int a double
                  : 0.0)) ??
          0.0,
    );
  }

  // Método para convertir de objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'correu': correu,
      'contrasenya': contrasenya,
      'edat': edat,
      'nacionalitat': nacionalitat,
      'codiPostal': codiPostal,
      'imatgePerfil': imatgePerfil,
      'btc': _btc, // Se guarda el valor modificado de btc
    };
  }
}
