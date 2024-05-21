import 'dart:convert';
import 'dart:math';
import 'package:stock_exchange/controllers/homeScreen/homeScreenBody.dart';
import 'package:intl/intl.dart';
import 'package:stock_exchange/models/stock.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marqueer/marqueer.dart';

import '../widgets/DetailSheetWidget.dart';
import '../widgets/homeScreenWidget.dart';

String getCurrentDate() {
  DateTime now = DateTime.now();
  return DateFormat('MMMM d').format(now);
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController scrollController;
  double searchBarHeight = 35;
  int offset = 0;
  double opacityRate = 1;
  double bottomSheetInitialRate = 0.2;
  bool marqueeVisible = true;
  StockList stockList = StockList(
      date: DateTime.now(),
      data: [
    Stock(
        open: 0.0,
        high: 0.0,
        low: 0.0,
        last: 0.0,
        close: 0.0,
        volume: 0,
        date: 0,
        symbol: 0,
        exchange: 0)
  ]);
  final controller = DraggableScrollableController();

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    scrollController.addListener(() {
      searchBarHeight = (35 - scrollController.offset) > 0
          ? (35 - scrollController.offset)
          : 0;

      offset = scrollController.offset.round();
      opacityRate = min(max(1 - (offset / 10), 0), 1);

      if (offset > 0) FocusScope.of(context).unfocus();

      setState(() {});
    });
    _fetchStocks();
  }

  Future<void> _fetchStocks() async {
    final jsonData = await readJson();
    final map = json.decode(jsonData);
    setState(() {
      stockList = StockList.fromJson(map);
    });
    DateTime currentDate = DateTime.now();
    DateTime storedDate = DateTime(stockList.date.year, stockList.date.month, stockList.date.day);
    DateTime today = DateTime(currentDate.year, currentDate.month, currentDate.day);

    if (storedDate.isBefore(today)) {
      await stockList.updateStockList();
      print(stockList);
      final updatedJson = stockListToJson(stockList);
      await writeJson(updatedJson);

      setState(() {
        stockList = StockList.fromJson(json.decode(updatedJson));
      });
    }

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bottomSheetInitialRate = 120 / MediaQuery.of(context).size.height;
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset:
        false, // This way, bottom sheet will stay behind keyboard
        appBar: _buildAppBar(),
        body: homeScreenBody(this)
    );
  }

  NotificationListener<DraggableScrollableNotification> buildDetailSheet() {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (DraggableScrollableNotification dsNotification) {
        // print("${dsNotification.extent}");
        if (dsNotification.extent > 0.99) {
          marqueeVisible = false;
        } else {
          marqueeVisible = true;
        }
        setState(() {});
        return true;
      },
      child: DraggableScrollableSheet(
        controller: controller,
        minChildSize: 0,
        snap: true,
        initialChildSize: 0,
        maxChildSize: 1,
        builder: ((context, scrollController) => DetailSheetWidget(this, scrollController)),
      ),
    );
  }


  AppBar _buildAppBar() {
    String currentDate = getCurrentDate(); // Get the current date as a formatted string

    return marqueeVisible
        ? AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 15,
      centerTitle: false,
      toolbarHeight: 70,
      actions: [
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
            child: const OverflowBox(
              maxWidth: 30,
              maxHeight: 30,
              child: Icon(
                CupertinoIcons.ellipsis_circle_fill,
                color: Color.fromARGB(255, 28, 28, 30),
                size: 30,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
      ],
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Stocks",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 25,
              height: 1,
            ),
          ),
          Text(
            currentDate, // Use the dynamic date here
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 25,
              color: Color.fromARGB(255, 141, 141, 147),
              height: 1,
            ),
          ),
        ],
      ),
      elevation: 0,
    )
        : AppBar(
      toolbarHeight: 70,
      title: SizedBox(
        height: 60,
        child: Marqueer.builder(
          itemCount: 200,
          itemBuilder: (context, i) {
            return SizedBox(
              width: 200,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${stockList.data[i % 12].symbol}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        "\$${stockList.data[i % 12].high}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        "+2.49",
                        style: TextStyle(
                          color: Color.fromARGB(255, 52, 199, 89),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 60,
                    height: 50,
                    child: Sparkline(
                      data: [
                        stockList.data[i % 12].open ?? 0.0,
                        stockList.data[i % 12].high ?? 0.0,
                        stockList.data[i % 12].low ?? 0.0,
                        stockList.data[i % 12].last ?? 0.0,
                        stockList.data[i % 12].close ?? 0.0,
                      ],
                      lineColor: const Color.fromARGB(255, 52, 199, 89),
                      fillMode: FillMode.below,
                      lineWidth: 1.5,
                      averageLine: true,
                      averageLabel: false,
                      fillGradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 52, 199, 89),
                          Colors.transparent
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void animatedHide() {
    controller.animateTo(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}