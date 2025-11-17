import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/crop.dart';

class CropRecommendationScreen extends StatefulWidget {
  const CropRecommendationScreen({super.key});

  @override
  State<CropRecommendationScreen> createState() =>
      _CropRecommendationScreenState();
}

class _CropRecommendationScreenState extends State<CropRecommendationScreen> {
  final ApiService _apiService = ApiService();
  final _phController = TextEditingController();
  final _moistureController = TextEditingController();
  final _tempController = TextEditingController();
  CropRecommendation? _recommendation;
  bool _isLoading = false;

  @override
  void dispose() {
    _phController.dispose();
    _moistureController.dispose();
    _tempController.dispose();
    super.dispose();
  }

  Future<void> _getRecommendation() async {
    final ph = double.tryParse(_phController.text);
    final moisture = double.tryParse(_moistureController.text);
    final temp = double.tryParse(_tempController.text);

    if (ph == null || moisture == null || temp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numbers')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await _apiService.recommendCrop(ph, moisture, temp);
      setState(() => _recommendation = CropRecommendation.fromJson(response));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Recommendation failed: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crop Recommendation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phController,
              decoration: const InputDecoration(labelText: 'Soil pH'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _moistureController,
              decoration: const InputDecoration(labelText: 'Moisture (%)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _tempController,
              decoration: const InputDecoration(labelText: 'Temperature (°C)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getRecommendation,
              child: const Text('Get Recommendation'),
            ),
            const SizedBox(height: 16),
            if (_isLoading) const CircularProgressIndicator(),
            if (_recommendation != null) ...[
              const Text(
                'Recommendations:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ..._recommendation!.recommendations.map(
                (r) => Card(
                  child: ListTile(
                    title: Text(r['crop']),
                    subtitle: Text(
                      'Score: ${(r['score'] * 100).toStringAsFixed(1)}%\nReason: ${r['reason']}',
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
