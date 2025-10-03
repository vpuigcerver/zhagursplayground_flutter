import 'package:flutter/material.dart';
import 'package:zhagurplayground/screens/CarouselHome/widgets/carousel_item.dart';
import 'package:zhagurplayground/screens/CarouselHome/widgets/carousel_slider.dart';

class CarouselHomeScreen extends StatelessWidget {
  const CarouselHomeScreen({super.key, required this.themeMode});

  final ValueNotifier<int> themeMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zhagur\'s playground'),
        actions: [
          IconButton(
            icon: Icon(Icons.nightlight_round),
            onPressed: () {
              themeMode.value = themeMode.value == 1 ? 2 : 1;
            },
          ),
        ],
      ),
      body: CarouselSliderWidget([
        CarouselItem('Food menu', '/basic', 'assets/images/preview/food.png',),
        CarouselItem('Dados', '/dados', 'assets/images/preview/dice.png',),
        CarouselItem('Gacha', '/gacha', 'assets/images/preview/gacha.png',),
        CarouselItem('Battle', '/battle', 'assets/images/preview/battle.png',),
        CarouselItem('Golden Battle', '/golden', 'assets/images/preview/golden.png',),
      ]),
    );
  }
}
