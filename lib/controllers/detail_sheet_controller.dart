import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/stock_data.dart';
import '../models/stock.dart';

class DetailSheetController {
  final Stock selectedStock;
  late StockData stockData;

  DetailSheetController(this.selectedStock);

  Future<void> loadStockData() async {
    // Load JSON data from a local asset
    final dataRaw = await rootBundle.load("assets/${selectedStock.symbol}.json");
    final data = json.decode(utf8.decode(dataRaw.buffer.asUint8List(dataRaw.offsetInBytes, dataRaw.lengthInBytes)));
    stockData = StockData.fromJson(data);
  }

  List<double> getCloseValues({int days = 7}) {
    return stockData.getCloseValues(days: days);
  }

  List<double> getCloseValuesForPeriod(DateTime startDate, DateTime endDate) {
    return stockData.getCloseValuesForPeriod(startDate, endDate);
  }

  List<DailyPrice> getLast30DaysData() {
    return stockData.getLast30DaysData();
  }
}