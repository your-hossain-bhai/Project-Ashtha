class DiseasePrediction {
  final String crop;
  final String disease;
  final double confidence;
  final List<String> advice;
  final List<Map<String, dynamic>> recommendations;

  DiseasePrediction({
    required this.crop,
    required this.disease,
    required this.confidence,
    required this.advice,
    required this.recommendations,
  });

  factory DiseasePrediction.fromJson(Map<String, dynamic> json) {
    return DiseasePrediction(
      crop: json['crop'],
      disease: json['disease'],
      confidence: json['confidence'].toDouble(),
      advice: List<String>.from(json['advice']),
      recommendations: List<Map<String, dynamic>>.from(json['recommendations']),
    );
  }
}
