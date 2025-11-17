class MarketPrice {
  final String crop;
  final double pricePerKg;
  final String trend;

  MarketPrice({
    required this.crop,
    required this.pricePerKg,
    required this.trend,
  });

  factory MarketPrice.fromJson(Map<String, dynamic> json) {
    return MarketPrice(
      crop: json['crop'],
      pricePerKg: json['price_per_kg'].toDouble(),
      trend: json['trend'],
    );
  }
}

class MarketLatest {
  final String city;
  final List<MarketPrice> prices;

  MarketLatest({required this.city, required this.prices});

  factory MarketLatest.fromJson(Map<String, dynamic> json) {
    return MarketLatest(
      city: json['city'],
      prices: (json['prices'] as List)
          .map((e) => MarketPrice.fromJson(e))
          .toList(),
    );
  }
}
