import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';


StockList stockListFromJson(String str) => StockList.fromJson(json.decode(str));
String stockListToJson(StockList data) => json.encode(data.toJson());

class StockList {
    List<Stock> data;
    DateTime date;
    List<String> availableStocks = ["AAPL","IBM","HPE","MSFT","ORCL","GOOGL","META","TWTR","INTC","AMZN"];
    List<String> stockNames = ["Apple Inc.","IBM inc.","Hewlett Packard Enterprise","Microsoft Corporation","Oracle Corporation","Alphabet Inc.","Meta Platforms Inc.","Twitter Inc.","Intel Corporation","Amazon.com Inc."];
    static String api = 'https://www.alphavantage.co/query?';
    static String apiKey = 'apikey=AJZSEHCREI4VHYM6';
    static String globalQuote = 'function=GLOBAL_QUOTE';
    static String outputSize = 'outputsize=full';
    static String intraDay = 'function=TIME_SERIES_INTRADAY';
    StockList({
      required this.date,
      required this.data,
    });
    factory StockList.fromJson(Map<String, dynamic> json) => StockList(
          date: DateTime.parse(json["date"]),
          data: List<Stock>.from(json["data"].map((x) => Stock.fromJson(x))),
        );

    Map<String, dynamic> toJson() => {// just year, month and day
          "date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
          "data": List<dynamic>.from(data.map((x) => x.toJson())),
        };

    updateStockList() async {
      List<Stock> lastData = data;
      List<Stock> newData = [];
      for (String stock in availableStocks) {
        final response = await http.get(Uri.parse('$api$globalQuote&symbol=$stock&$apiKey'));
        if (response.statusCode == 200) {
          Map<String, dynamic> stockData = json.decode(response.body);
          if (stockData.containsKey('Global Quote')) {
            Map<String, dynamic> globalQuote = stockData['Global Quote'];
            Stock stockObject = Stock.fromApi(globalQuote, stockNames[availableStocks.indexOf(stock)]);
            newData.add(stockObject);
          }else {
            newData.add(lastData[availableStocks.indexOf(stock)]);
          }
        }

      }
      data = newData;
    }
}

class Stock {
    dynamic open;
    dynamic high;
    dynamic low;
    dynamic last;
    dynamic close;
    dynamic volume;
    dynamic date;
    dynamic symbol;
    dynamic exchange;

    Stock({
      required this.open,
      required this.high,
      required this.low,
      required this.last,
      required this.close,
      required this.volume,
      required this.date,
      required this.symbol,
      required this.exchange,
    });

    factory Stock.fromJson(Map<String, dynamic> json) => Stock(
          open: json["open"]?.toDouble(),
          high: json["high"]?.toDouble(),
          low: json["low"]?.toDouble(),
          last: json["last"]?.toDouble(),
          close: json["close"]?.toDouble(),
          volume: json["volume"],
          date: json["date"],
          symbol: json["symbol"],
          exchange: json["exchange"],
        );

    factory Stock.fromApi(Map<String, dynamic> json,String ex) => Stock(
      open: double.parse(json["02. open"]),
      high: double.parse(json["03. high"]),
      low: double.parse(json["04. low"]),
      last: double.parse(json["05. price"]),
      close: double.parse(json["08. previous close"]),
      volume: json["06. volume"],
      date: json["07. latest trading day"],
      symbol: json["01. symbol"],
      exchange: ex, // This field is not provided by the API
    );

    Map<String, dynamic> toJson() => {
          "open": open,
          "high": high,
          "low": low,
          "last": last,
          "close": close,
          "volume": volume,
          "date": date,
          "symbol": symbol,
          "exchange": exchange,
        };
}

Future<String> _getFilePath() async {
  final directory = await getApplicationDocumentsDirectory();
  return '${directory.path}/data.json';
}

Future<File> writeJson(String json) async {
  final path = await _getFilePath();
  return File(path).writeAsString(json);
}

Future<String> readJson() async {
  final data = await rootBundle.load("assets/data.json");
  return utf8.decode(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}
