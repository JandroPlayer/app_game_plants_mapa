class Planta {
  final int id;
  final int usuariId;
  final String nom;
  final String tipus;
  final int nivell;
  final int atac;
  final int defensa;
  final int velocitat;
  final String habilitatEspecial;
  final int energia;
  final String estat;
  final String raritat;
  final String imatge;
  final DateTime ultimaActualitzacio; // Campo DateTime agregado

  Planta({
    required this.id,
    required this.usuariId,
    required this.nom,
    required this.tipus,
    required this.nivell,
    required this.atac,
    required this.defensa,
    required this.velocitat,
    required this.habilitatEspecial,
    required this.energia,
    required this.estat,
    required this.raritat,
    required this.imatge,
    required this.ultimaActualitzacio, // Lo hacemos requerido
  });

  // Convertir de JSON a un objeto Planta
  factory Planta.fromJson(Map<String, dynamic> json) {
    return Planta(
      id: json['id'],
      usuariId: json['usuari_id'],
      nom: json['nom'],
      tipus: json['tipus'],
      nivell: json['nivell'],
      atac: json['atac'],
      defensa: json['defensa'],
      velocitat: json['velocitat'],
      habilitatEspecial: json['habilitat_especial'] ?? '',
      energia: json['energia'],
      estat: json['estat'],
      raritat: json['raritat'],
      imatge: json['imatge'],
      ultimaActualitzacio: DateTime.parse(json['ultima_actualitzacio'] ??
          DateTime.now()
              .toIso8601String()), // Si no existe el campo, usar la fecha actual
    );
  }

  // Convertir de un objeto Planta a JSON
  Map<String, dynamic> toJson() {
    return {
      'usuari_id': usuariId,
      'nom': nom,
      'tipus': tipus,
      'nivell': nivell,
      'atac': atac,
      'defensa': defensa,
      'velocitat': velocitat,
      'habilitat_especial': habilitatEspecial,
      'energia': energia,
      'estat': estat,
      'raritat': raritat,
      'imatge': imatge,
      'ultima_actualitzacio': ultimaActualitzacio
          .toIso8601String(), // Convertir la fecha a formato ISO 8601
    };
  }
}
