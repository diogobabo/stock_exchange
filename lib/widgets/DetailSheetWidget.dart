import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_exchange/models/stock_data.dart';

import '../controllers/detail_sheet_controller.dart';
import '../models/stock.dart';

class DetailSheetWidget extends StatefulWidget {
  final ScrollController scrollController;
  final Stock selectedStock;

  DetailSheetWidget(this.selectedStock, this.scrollController);

  @override
  _DetailSheetWidgetState createState() => _DetailSheetWidgetState();
}

class _DetailSheetWidgetState extends State<DetailSheetWidget> {
  late DetailSheetController _controller;
  List<double> _closeValues = [];
  List<DailyPrice> _last30DaysData = [];
  int _selectedSegment = 1; // Default to '7D'

  @override
  void initState() {
    super.initState();
    _controller = DetailSheetController(widget.selectedStock);
    _loadData();
  }

  @override
  void didUpdateWidget(covariant DetailSheetWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedStock.symbol != oldWidget.selectedStock.symbol) {
      _controller = DetailSheetController(widget.selectedStock);
      _loadData();
    }
  }

  Future<void> _loadData() async {
    if (_controller.selectedStock.symbol == 0) {
      return;
    }
    await _controller.loadStockData();
    _updateCloseValues();
    _updateLast30DaysData();
  }

  void _updateLast30DaysData() {
    setState(() {
      _last30DaysData = _controller.getLast30DaysData();
    });
  }

  void _updateCloseValues() {
    setState(() {
      switch (_selectedSegment) {
        case 0:
          _closeValues = _controller.getCloseValues(days: 1);
          break;
        case 1:
          _closeValues = _controller.getCloseValues(days: 7);
          break;
        case 2:
          _closeValues = _controller.getCloseValues(days: 30);
          break;
        case 3:
          _closeValues = _controller.getCloseValues(days: 90);
          break;
        case 4:
          _closeValues = _controller.getCloseValues(days: 180);
          break;
        case 5:
          _closeValues = _controller.getCloseValues(days: 365);
          break;
        case 6:
          _closeValues = _controller.getCloseValues(days: 365 * 10);
          break;
        default:
          _closeValues = _controller.getCloseValues(days: 7);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 28, 28, 30),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: widget.scrollController,
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Divider(),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "\$${widget.selectedStock.last}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${widget.selectedStock.symbol} * USD",
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoSlidingSegmentedControl<int>(
                    backgroundColor: Colors.transparent,
                    thumbColor: const Color.fromARGB(255, 114, 114, 114),
                    groupValue: _selectedSegment,
                    onValueChanged: (int? value) {
                      setState(() {
                        _selectedSegment = value ?? 1;
                        _updateCloseValues();
                      });
                    },
                    children: const <int, Widget>{
                      0: Text('1D', style: TextStyle(color: CupertinoColors.white)),
                      1: Text('7D', style: TextStyle(color: CupertinoColors.white)),
                      2: Text('1M', style: TextStyle(color: CupertinoColors.white)),
                      3: Text('3M', style: TextStyle(color: CupertinoColors.white)),
                      4: Text('6M', style: TextStyle(color: CupertinoColors.white)),
                      5: Text('1Y', style: TextStyle(color: CupertinoColors.white)),
                      6: Text('10Y', style: TextStyle(color: CupertinoColors.white)),
                    },
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Sparkline(
                    data: _closeValues.isNotEmpty ? _closeValues : [0, 0, 0],
                    lineColor: const Color.fromARGB(255, 52, 199, 89),
                    fillMode: FillMode.below,
                    lineWidth: 1.5,
                    enableGridLines: true,
                    gridLineLabelColor: Colors.grey,
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
                const SizedBox(height: 15),
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    separatorBuilder: (context, i) => Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 1,
                        height: 50,
                        color: const Color.fromARGB(255, 71, 71, 71),
                      ),
                    ),
                    itemCount: _last30DaysData.take(7).length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final dayData = _last30DaysData[index];
                      return SizedBox(
                        width: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                                  child: const Text('Open', style: TextStyle(fontSize: 12.0, color: Colors.grey)),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                                  child: Text(dayData.open.toString() ?? 'N/A', style: const TextStyle(fontSize: 12.0, color: Colors.white)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                                  child: const Text('High', style: TextStyle(fontSize: 12.0, color: Colors.grey)),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                                  child: Text(dayData.high.toString() ?? 'N/A', style: const TextStyle(fontSize: 12.0, color: Colors.white)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                                  child: const Text('Low', style: TextStyle(fontSize: 12.0, color: Colors.grey)),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                                  child: Text(dayData.low.toString() ?? 'N/A', style: const TextStyle(fontSize: 12.0, color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${widget.selectedStock.symbol} - USD",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                "${(widget.selectedStock.exchange).toString().substring(0,(widget.selectedStock.exchange).toString().length > 15 ? 15 : (widget.selectedStock.exchange).toString().length)}",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 20),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: const Color.fromARGB(255, 178, 178, 178),
                ),
                child: const OverflowBox(
                  maxWidth: 35,
                  maxHeight: 35,
                  child: Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: Color.fromARGB(255, 51, 51, 51),
                    size: 35,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
