import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:zhagurplayground/screens/CarouselHome/widgets/carousel_item.dart';

class CarouselSliderWidget extends StatelessWidget {
  const CarouselSliderWidget(this.screenList, {super.key});
  final List<CarouselItem> screenList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return CarouselSlider(
            options: CarouselOptions(
              clipBehavior: Clip.antiAlias,
              animateToClosest: true,
              enlargeFactor: 0,
              viewportFraction: 0.6,
              aspectRatio: 0.5,
              enlargeCenterPage: true,
              scrollDirection: Axis.vertical,
            ),
            items: screenList.map((item) => Center(child: item)).toList(),
          );
        },
      ),
    );
  }
}
