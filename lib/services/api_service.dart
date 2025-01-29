import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/model.dart';

class ApiService {
  static const String baseUrl = 'http://your-api-url:5000';

  Future<StockPrediction> getPrediction(String symbol) async {
    final response = await http.get(Uri.parse('$baseUrl/predict/$symbol'));
    
    if (response.statusCode == 200) {
      return StockPrediction.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load prediction');
    }
  }
}

