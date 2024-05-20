import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controllers/homeScreen.dart';

class DetailSheetWidget extends StatelessWidget {
  final HomeScreenState state;
  final ScrollController scrollController;
  DetailSheetWidget (this.state, this.scrollController);

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
            controller: scrollController,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Divider(),
                const Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "\$29.953,60",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "CCC * USD",
                          style: TextStyle(
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
                    thumbColor:
                    const Color.fromARGB(255, 114, 114, 114),
                    groupValue: 1,
                    onValueChanged: (int? value) {},
                    children: const <int, Widget>{
                      0: Text(
                        '1G',
                        style: TextStyle(color: CupertinoColors.white),
                      ),
                      1: Text(
                        '1H',
                        style: TextStyle(color: CupertinoColors.white),
                      ),
                      2: Text(
                        '1A',
                        style: TextStyle(color: CupertinoColors.white),
                      ),
                      3: Text(
                        '3A',
                        style: TextStyle(color: CupertinoColors.white),
                      ),
                      4: Text(
                        '6A',
                        style: TextStyle(color: CupertinoColors.white),
                      ),
                      5: Text(
                        'S1Y',
                        style: TextStyle(color: CupertinoColors.white),
                      ),
                      6: Text(
                        '1Y',
                        style: TextStyle(color: CupertinoColors.white),
                      ),
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Sparkline(
                    data: [
                      this.state.stockList.data[0].open ?? 0.0,
                      this.state.stockList.data[0].high ?? 0.0,
                      this.state.stockList.data[0].low ?? 0.0,
                      this.state.stockList.data[0].last ?? 0.0,
                      this.state.stockList.data[0].close ?? 0.0,
                    ],
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
                const SizedBox(
                  height: 15,
                ),
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
                    itemCount: 15,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => const SizedBox(
                      width: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal:
                                    8.0),
                                child: Text(
                                  'Open',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal:
                                    8.0),
                                child: Text(
                                  '1,057',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.0,
                                    horizontal:
                                    8.0),
                                child: Text(
                                  'High',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.0,
                                    horizontal:
                                    8.0),
                                child: Text(
                                  '1,059',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.0,
                                    horizontal:
                                    8.0),
                                child: Text(
                                  'Low',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0.0,
                                    horizontal:
                                    8.0),
                                child: Text(
                                  '1,056',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "BTC-USD",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              const Text(
                "Bitcoin USD",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).primaryColor,
                ),
                child: const OverflowBox(
                  maxWidth: 35,
                  maxHeight: 35,
                  child: Icon(
                    CupertinoIcons.ellipsis_circle_fill,
                    color: Color.fromARGB(255, 51, 51, 51),
                    size: 35,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
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
      )
    );
  }
}

