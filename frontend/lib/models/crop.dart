class CropRecommendation {
  final List<Map<String, dynamic>> recommendations;

  CropRecommendation({required this.recommendations});

  factory CropRecommendation.fromJson(Map<String, dynamic> json) {
    return CropRecommendation(
      recommendations: List<Map<String, dynamic>>.from(json['recommendations']),
    );
  }
}
