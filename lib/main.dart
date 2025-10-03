import 'package:flutter/material.dart';
import 'package:zhagurplayground/screens/Battle/battle_scene.dart';
import 'package:zhagurplayground/screens/GachaStyle/gacha_home_screen.dart';
import 'package:zhagurplayground/screens/GachaStyle/providers/collection_provider.dart';
import 'package:zhagurplayground/screens/GachaStyle/providers/economy_provider.dart';
import 'package:zhagurplayground/screens/GachaStyle/providers/premium_provider.dart';
import 'package:zhagurplayground/screens/GoldenSunBattle/golden_sun_battle.dart';
import 'package:zhagurplayground/screens/gradient/gradient_container.dart';
import 'package:zhagurplayground/screens/CarouselHome/carousel_home_screen.dart';
import 'package:zhagurplayground/screens/FoodRecipies/tabs.dart';
import 'package:provider/provider.dart';

void main() async {

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EconomyProvider()),
        ChangeNotifierProvider(create: (_) => CollectionProvider()),
        ChangeNotifierProvider(create: (_) => PremiumCurrencyProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

final themeMode = ValueNotifier(2);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, value, g) {
        return MaterialApp(
          initialRoute: '/',
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.values.toList()[value],
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (ctx) => CarouselHomeScreen(themeMode: themeMode),
            '/basic': (ctx) => TabsScreen(),
            '/dados': (ctx) => GradientContainer(
              Color.fromARGB(255, 2, 58, 48),
              Color.fromARGB(255, 10, 120, 130),
            ),
            '/gacha': (ctx) => GachaHomeScreen(themeMode: themeMode),
            '/battle': (ctx) => BattleScreen(),
            '/golden': (ctx) => GoldenSunBattle()
          },
        );
      },
      valueListenable: themeMode,
    );
  }
}
