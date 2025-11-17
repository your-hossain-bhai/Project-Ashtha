import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/api_service.dart';
import '../models/disease.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({super.key});

  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  DiseasePrediction? _prediction;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _image = pickedFile);
      await _predictDisease();
    }
  }

  Future<void> _predictDisease() async {
    if (_image == null) return;

    setState(() => _isLoading = true);
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          _image!.path,
          filename: _image!.name,
        ),
      });
      final response = await _apiService.predictDisease(formData);
      setState(() => _prediction = DiseasePrediction.fromJson(response));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Prediction failed: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disease Detection')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_image != null)
              Image.file(File(_image!.path), height: 200, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera),
                  label: const Text('Camera'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo),
                  label: const Text('Gallery'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoading) const CircularProgressIndicator(),
            if (_prediction != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Crop: ${_prediction!.crop}'),
                      Text('Disease: ${_prediction!.disease}'),
                      Text(
                        'Confidence: ${(_prediction!.confidence * 100).toStringAsFixed(1)}%',
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Advice:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ..._prediction!.advice.map((a) => Text('• $a')),
                      const SizedBox(height: 8),
                      ExpansionTile(
                        title: const Text('See Steps'),
                        children: _prediction!.recommendations
                            .map(
                              (r) => ListTile(
                                title: Text(r['name']),
                                subtitle: Text(
                                  'Dose: ${r['dose']}\nApply: ${r['apply']}',
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
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
