import 'package:flutter/material.dart';
import '../controllers/homeScreen.dart';
import '../models/news_card.dart';

class NewSheetWidget extends StatelessWidget {
  final HomeScreenState state;
  final ScrollController scrollController;
  NewSheetWidget (this.state, this.scrollController);

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 28, 28, 30),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          ),
        ),
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 35,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 100, 100, 100),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Business News",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 25,
                padding: const EdgeInsets.symmetric(vertical: 20),
                itemBuilder: (BuildContext context, int index) {
                  return const NewsCardWidget(
                    imageUrl: "assets/btc.jpeg",
                    title:
                    "No surprises in the expected Bitcoin ETF decisions once again.",
                    summary:
                    "The U.S. Securities and Exchange Commission (SEC)...",
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

