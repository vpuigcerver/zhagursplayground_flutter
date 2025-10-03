import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zhagurplayground/screens/GachaStyle/models/shop_pack.dart';
import 'package:zhagurplayground/screens/GachaStyle/providers/economy_provider.dart';
import 'package:zhagurplayground/screens/GachaStyle/providers/premium_provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final economy = Provider.of<EconomyProvider>(context);
    final premium = context.watch<PremiumCurrencyProvider>();

    final packages = [
      {'gems': 60, 'price': '€0.99'},
      {'gems': 300, 'price': '€4.99'},
      {'gems': 980, 'price': '€14.99'},
      {'gems': 1980, 'price': '€29.99'},
    ];
    return Scaffold(
      appBar: TabBar(
        controller: _tabController,
        tabs: const <Widget>[
          Tab(text: "Monedas",icon: Text("⛃")),
          Tab(text: "Gemas",icon: Text("💎")),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: shopPacks.length,
                itemBuilder: (context, index) {
                  final pack = shopPacks[index];
                  return _buildShopCard(context, pack, economy);
                },
              ),
              ElevatedButton(
                onPressed: () => economy.addCoins(500),
                child: const Text("Comprar 500 monedas"),
              ),
              const SizedBox(height: 12),
            ],
          ),
          ListView.builder(
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final pkg = packages[index];
              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: Icon(Icons.star, color: Colors.purple),
                  title: Text("${pkg['gems']} 💎"),
                  subtitle: Text("Precio: ${pkg['price']} (simulado)"),
                  trailing: ElevatedButton(
                    child: const Text("Comprar"),
                    onPressed: () {
                      context.read<PremiumCurrencyProvider>().addGems(
                        pkg['gems'] as int,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("¡Compraste ${pkg['gems']} 💎!"),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          "💎 disponibles: ${premium.gems}",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildShopCard(
    BuildContext context,
    ShopPack pack,
    EconomyProvider economy,
  ) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.asset(
                pack.image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  pack.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                if (pack.coins > 0) Text("💰 +${pack.coins} monedas"),
                if (pack.tickets > 0) Text("🎟️ +${pack.tickets} tickets"),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    if (pack.price == 0) {
                      // pack gratis
                      economy.addCoins(pack.coins);
                      economy.addTickets(pack.tickets);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("¡Pack obtenido!")),
                      );
                      return;
                    }

                    if (economy.coins >= pack.price) {
                      economy.spendCoins(pack.price);
                      economy.addCoins(pack.coins);
                      economy.addTickets(pack.tickets);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Compraste ${pack.title}!")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("No tienes suficientes monedas"),
                        ),
                      );
                    }
                  },
                  child: Text(pack.price == 0 ? "Gratis" : "${pack.price} 💰"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
