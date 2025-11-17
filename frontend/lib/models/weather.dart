class Weather {
  final String city;
  final double temp;
  final String condition;
  final int humidity;
  final double windKmh;
  final List<Map<String, String>> forecast;

  Weather({
    required this.city,
    required this.temp,
    required this.condition,
    required this.humidity,
    required this.windKmh,
    required this.forecast,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['city'],
      temp: json['temp'].toDouble(),
      condition: json['condition'],
      humidity: json['humidity'],
      windKmh: json['wind_kmh'].toDouble(),
      forecast: List<Map<String, String>>.from(json['forecast']),
    );
  }
}
