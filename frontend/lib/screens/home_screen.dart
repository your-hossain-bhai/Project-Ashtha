import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'disease_detection_screen.dart';
import 'crop_recommendation_screen.dart';
import 'market_prices_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('কৃষকধনী'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authProvider.logout(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${authProvider.user?.name ?? 'Farmer'}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildCard(
                    context,
                    'Weather',
                    Icons.wb_sunny,
                    () => _showWeatherDialog(context),
                  ),
                  _buildCard(
                    context,
                    'Disease Detection',
                    Icons.bug_report,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DiseaseDetectionScreen(),
                      ),
                    ),
                  ),
                  _buildCard(
                    context,
                    'Crop Recommendation',
                    Icons.grass,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CropRecommendationScreen(),
                      ),
                    ),
                  ),
                  _buildCard(
                    context,
                    'Market Prices',
                    Icons.attach_money,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MarketPricesScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  void _showWeatherDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Weather'),
        content: const Text('Weather feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
