
import 'dart:math';

import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../homeScreen.dart';

class homeScreenBody extends StatelessWidget {
  final HomeScreenState state;
  homeScreenBody(this.state);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Listener(
          behavior: HitTestBehavior.translucent,
          onPointerUp: (e) {
            if (this.state.scrollController.offset < 28 && this.state.scrollController.offset > 0) {
              this.state.scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.fastOutSlowIn,
              );
            } else if (this.state.scrollController.offset >= 28 &&
                this.state.scrollController.offset < 56) {
              this.state.scrollController.animateTo(
                56,
                duration: const Duration(milliseconds: 200),
                curve: Curves.fastOutSlowIn,
              );
            }
          },
          child: CustomScrollView(
            controller: this.state.scrollController,
            slivers: [
              SliverAppBar(
                toolbarHeight: 35,
                centerTitle: false,
                titleSpacing: 15,
                title: SizedBox(
                  height: 35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: min(35, this.state.searchBarHeight),
                        child: CupertinoSearchTextField(
                          backgroundColor:
                          const Color.fromARGB(255, 29, 29, 31),
                          itemColor: const Color.fromARGB(255, 146, 146, 146)
                              .withOpacity(this.state.opacityRate),
                          placeholderStyle: TextStyle(
                            color: Colors.grey.withOpacity(this.state.opacityRate),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                elevation: 0.0,
              ),
              SliverPadding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      PullDownButton(
                        itemBuilder: (context) => [
                          PullDownMenuItem(
                            onTap: () {},
                            title: 'My Symbols',
                          ),
                          const PullDownMenuDivider.large(),
                          PullDownMenuItem(
                            title: 'New List',
                            onTap: () {},
                            icon: CupertinoIcons.add,
                          ),
                        ],
                        animationBuilder: null,
                        position: PullDownMenuPosition.automatic,
                        buttonBuilder: (context, showMenu) => GestureDetector(
                          onTap: showMenu,
                          child: Row(
                            children: [
                              Text(
                                "My Symbols",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Icon(
                                CupertinoIcons.chevron_up_chevron_down,
                                size: 20,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 15,
                  bottom: 150,
                ),
                sliver: SliverList.separated(
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                  ),
                  itemBuilder: (c, i) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    height: 50,
                    child: GestureDetector(
                      onTap: () => this.state.animatedHide(),
                      child: Container(
                        color: Colors.transparent,
                        child: Row(children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${this.state.stockList.data[i].symbol}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${this.state.stockList.data[i].exchange}",
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            height: 40,
                            child: Sparkline(
                              data: [
                                this.state.stockList.data[i].open ?? 0.0,
                                this.state.stockList.data[i].high ?? 0.0,
                                this.state.stockList.data[i].low ?? 0.0,
                                this.state.stockList.data[i].last ?? 0.0,
                                this.state.stockList.data[i].close ?? 0.0,
                              ],
                              lineColor: const Color.fromARGB(255, 52, 199, 89),
                              fillMode: FillMode.below,
                              lineWidth: 1.5,
                              gridLineLabelColor:
                              const Color.fromARGB(255, 52, 199, 89),
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
                          SizedBox(
                            width: 110,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "\$${this.state.stockList.data[i].open}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  width: 75,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color:
                                    const Color.fromARGB(255, 52, 199, 89),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    "+${(this.state.stockList.data[i].high / 100).toStringAsFixed(2)}",
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]),
                      ),
                    ),
                  ),
                  itemCount: this.state.stockList.data.length,
                ),
              )
            ],
          ),
        ),
        this.state.buildDetailSheet(),
      ],
    );
  }
}
