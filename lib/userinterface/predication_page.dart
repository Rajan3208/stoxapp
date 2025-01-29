import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';
import '../models/model.dart';

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _apiService = ApiService();
  final _symbolController = TextEditingController();
  StockPrediction? _prediction;
  bool _loading = false;

  Future<void> _getPrediction() async {
    setState(() => _loading = true);
    try {
      final prediction = await _apiService.getPrediction(_symbolController.text);
      setState(() => _prediction = prediction);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stock Prediction')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _symbolController,
              decoration: InputDecoration(
                labelText: 'Stock Symbol',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _getPrediction,
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_loading)
              CircularProgressIndicator()
            else if (_prediction != null) ...[
              Text(
                'Predicted Price: \$${_prediction!.prediction.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 20),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(show: true),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          _prediction!.prices.length,
                          (i) => FlSpot(i.toDouble(), _prediction!.prices[i]),
                        ),
                        isCurved: true,
                        color: Colors.blue,
                        dotData: FlDotData(show: false),
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