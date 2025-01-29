class StockPrediction {
  final String symbol;
  final double prediction;
  final List<String> dates;
  final List<double> prices;

  StockPrediction({
    required this.symbol,
    required this.prediction,
    required this.dates,
    required this.prices,
  });

  factory StockPrediction.fromJson(Map<String, dynamic> json) {
    return StockPrediction(
      symbol: json['symbol'],
      prediction: json['prediction'].toDouble(),
      dates: List<String>.from(json['historical_data']['dates']),
      prices: List<double>.from(json['historical_data']['prices']),
    );
  }
}