// Aquesta classe Crypto defineix un model de dades per representar la informació d'una criptomoneda, amb atributs com el nom, símbol, preu actual, volum, subministrament circulant, etc. A més, inclou un mètode de fàbrica (fromJson) per crear una instància de Crypto a partir d'un mapa de dades JSON, proporcionant valors per defecte quan els camps són nuls o incomplerts.

class Crypto {
  final String name;
  final String symbol;
  final double currentPrice;
  final double priceChangePercentage24h;
  final String image;
  final double totalVolume;
  final double high24h;
  final double low24h;
  final double circulatingSupply;
  final double totalSupply;
  final double marketCap;
  final String lastUpdated;

  Crypto({
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.image,
    required this.totalVolume,
    required this.high24h,
    required this.low24h,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.marketCap,
    required this.lastUpdated,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      name: json['name'] ?? 'No sa pogut carregar el nom',
      symbol: json['symbol'] ?? 'N/A',
      currentPrice: json['current_price']?.toDouble() ??
          0.0, // Per defecte 0.0 si es null
      priceChangePercentage24h:
          json['price_change_percentage_24h']?.toDouble() ?? 0.0,
      image: json['image'] ?? '', // per defecte buit si no hi ha imatge
      totalVolume: json['total_volume']?.toDouble() ?? 0.0,
      high24h: json['high_24h']?.toDouble() ?? 0.0,
      low24h: json['low_24h']?.toDouble() ?? 0.0,
      circulatingSupply: json['circulating_supply']?.toDouble() ?? 0.0,
      totalSupply: json['total_supply']?.toDouble() ?? 0.0,
      marketCap: json['market_cap']?.toDouble() ?? 0.0,
      lastUpdated: json['last_updated'] ?? 'no s\'ha pogut carregar la data',
    );
  }
}
