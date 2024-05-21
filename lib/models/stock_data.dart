import 'dart:convert';

class StockData {
  final String symbol;
  final Map<String, DailyPrice> dailyPrices;

  StockData({required this.symbol, required this.dailyPrices});

  factory StockData.fromJson(Map<String, dynamic> json) {
    String symbol = json['Meta Data']['2. Symbol'];
    Map<String, DailyPrice> dailyPrices = {};
    Map<String, dynamic> timeSeries = json['Time Series (Daily)'];
    timeSeries.forEach((date, data) {
      dailyPrices[date] = DailyPrice.fromJson(data);
    });
    return StockData(symbol: symbol, dailyPrices: dailyPrices);
  }
  List<DailyPrice> getLast30DaysData() {
    List<String> sortedKeys = dailyPrices.keys.toList()
      ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));
    return sortedKeys
        .take(30)
        .map((date) => dailyPrices[date]!)
        .toList();
  }

  List<double> getCloseValues({int days = 7}) {
    List<String> sortedKeys = dailyPrices.keys.toList()
      ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));
    return sortedKeys
        .take(days)
        .map((date) => dailyPrices[date]?.close ?? 0.0)
        .toList();
  }

  List<double> getCloseValuesForPeriod(DateTime startDate, DateTime endDate) {
    return dailyPrices.entries
        .where((entry) {
      DateTime date = DateTime.parse(entry.key);
      return date.isAfter(startDate) && date.isBefore(endDate);
    })
        .map((entry) => entry.value.close)
        .toList();
  }
}

class DailyPrice {
  final double open;
  final double high;
  final double low;
  final double close;
  final int volume;

  DailyPrice({required this.open, required this.high, required this.low, required this.close, required this.volume});

  factory DailyPrice.fromJson(Map<String, dynamic> json) {
    return DailyPrice(
      open: double.parse(json['1. open']),
      high: double.parse(json['2. high']),
      low: double.parse(json['3. low']),
      close: double.parse(json['4. close']),
      volume: int.parse(json['5. volume']),
    );
  }
}