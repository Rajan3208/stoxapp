import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/model.dart';

class ApiService {
  // Use your computer's IP address instead of localhost
  // For example, if your computer's IP is 192.168.1.100:
  static const String baseUrl = 'http://10.0.2.2:5000';  // Special Android emulator address
  // If using a physical device, use your computer's actual IP address:
  // static const String baseUrl = 'http://192.168.1.100:5000';

  Future<StockPrediction> getPrediction(String symbol) async {
    try {
      final url = Uri.parse('$baseUrl/predict/$symbol');
      print('Requesting URL: $url'); // For debugging
      
      final response = await http.get(url);
      print('Response status: ${response.statusCode}'); // For debugging
      print('Response body: ${response.body}'); // For debugging
      
      if (response.statusCode == 200) {
        return StockPrediction.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load prediction: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getPrediction: $e'); // For debugging
      throw Exception('Failed to load prediction: $e');
    }
  }
}