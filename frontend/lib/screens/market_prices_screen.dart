import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/market.dart';

class MarketPricesScreen extends StatefulWidget {
  const MarketPricesScreen({super.key});

  @override
  State<MarketPricesScreen> createState() => _MarketPricesScreenState();
}

class _MarketPricesScreenState extends State<MarketPricesScreen> {
  final ApiService _apiService = ApiService();
  MarketLatest? _marketData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMarketPrices();
  }

  Future<void> _loadMarketPrices() async {
    try {
      final response = await _apiService.getMarketLatest('Dhaka');
      setState(() {
        _marketData = MarketLatest.fromJson(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load market prices: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Market Prices')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _marketData == null
          ? const Center(child: Text('No data available'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prices in ${_marketData!.city}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _marketData!.prices.length,
                      itemBuilder: (context, index) {
                        final price = _marketData!.prices[index];
                        return Card(
                          child: ListTile(
                            title: Text(price.crop),
                            subtitle: Text('Trend: ${price.trend}'),
                            trailing: Text(
                              '৳${price.pricePerKg.toStringAsFixed(2)}/kg',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
