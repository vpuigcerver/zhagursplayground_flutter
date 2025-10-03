import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zhagurplayground/screens/GachaStyle/data/data.dart';
import 'package:zhagurplayground/screens/GachaStyle/models/gacha_item.dart';
import 'package:zhagurplayground/screens/GachaStyle/providers/collection_provider.dart';
import 'package:zhagurplayground/screens/GachaStyle/providers/economy_provider.dart';
import 'package:zhagurplayground/screens/GachaStyle/providers/premium_provider.dart';
import 'package:zhagurplayground/screens/GachaStyle/screens/gacha/gacha_result.dart';
import 'package:zhagurplayground/screens/GachaStyle/screens/gacha/gacha_ten_result.dart';
import 'package:zhagurplayground/screens/GachaStyle/widgets/star_value_rate.dart';
import 'package:zhagurplayground/screens/GachaStyle/utils/utils.dart';

class GachaScreen extends StatefulWidget {
  const GachaScreen({super.key});

  @override
  State<GachaScreen> createState() => _GachaScreenState();
}

class _GachaScreenState extends State<GachaScreen> {
  @override
  void initState() {
    super.initState();
    asignarProbabilidades(dummyData);
  }

  @override
  Widget build(BuildContext context) {
    final economy = context.watch<EconomyProvider>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("⛃ Monedas: ${economy.coins}"),
              SizedBox(width: 20,),
              Text("🎟️ Tickets: ${economy.tickets}"),
            ],
          ),
          Text("1 Ticket 🎟️ = 100 Monedas ⛃"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  bool canProceed = await _checkAndSpendTickets(1);
                  if (canProceed) get1Random();
                },
                child: const Text("Tirada x1🎟️"),
              ),
              ElevatedButton(
                onPressed: () async {
                  bool canProceed = await _checkGems(5);
                  if (canProceed) get1Random();
                },
                child: const Text("Tirada x1 💎x5"),
              ),
              ElevatedButton(
                onPressed: () async {
                  bool canProceed = await _checkAndSpendTickets(10);
                  if (canProceed) get10Random();
                },
                child: const Text("Tirada 10x🎟️"),
              ),
            ],
          ),
          Consumer<EconomyProvider>(
            builder: (context, economy, child) {
              return Column(
                children: [
                  Text("Pity: ${economy.pityCounter}/${economy.pityThreshold}"),
                  if (economy.reachedPity())
                    const Text(
                      "¡Próxima tirada garantiza épico/legendario!",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => showRates(context, dummyData),
            child: const Text("Ver Probabilidades"),
          ),
        ],
      ),
    );
  }

  /// 🎲 Tirada individual
  GachaItem tirar(
    List<GachaItem> pool,
    EconomyProvider economy,
    CollectionProvider collection,
  ) {
    GachaItem result = pool.last;

    // --- pity check ---
    if (economy.reachedPity()) {
      final highRarity = pool
          .where((item) => item.rareza == Rarity.legendary)
          .toList();

      result = highRarity[math.Random().nextInt(highRarity.length)];
      economy.resetPity();
    } else {
      double valor = math.Random().nextDouble() * 100;
      double acumulado = 0;
      for (var p in pool) {
        acumulado += p.probabilidad;
        if (valor <= acumulado) {
          result = p;
          break;
        }
      }

      if (result.rareza == Rarity.common ||
          result.rareza == Rarity.rare ||
          result.rareza == Rarity.epic) {
        economy.incrementPity();
      } else {
        economy.resetPity();
      }
    }

    // --- desbloqueo en colección ---
    bool isNew = collection.unlockItem(result.id);
    return result.copyWith(isNew: isNew);
  }

  /// 🎲 Tirada múltiple con garantizado
  List<GachaItem> rollTenPullGuaranteed(
    List<GachaItem> items,
    EconomyProvider economy,
    CollectionProvider provider,
  ) {
    List<GachaItem> results = [];

    for (int i = 0; i < 9; i++) {
      final resultado = tirar(items, economy, provider);
      results.add(resultado);
    }

    // Último roll: aseguramos rareza >= Rare
    List<GachaItem> filtrados = items
        .where((i) => i.rareza != Rarity.common)
        .toList();
    final resultado = tirar(filtrados, economy, provider);
    results.add(resultado);

    return results;
  }

  /// 👉 Navegación a pantalla de resultado individual
  void _gotoDetailsPage(BuildContext context, GachaItem result) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) {
          return GachaResult(
            starStyles: StarStyles.big,
            initialResult: result, // le pasamos el resultado inicial
            onRepeat: (items) {
              final provider = context.read<CollectionProvider>();
              final economy = context.read<EconomyProvider>();
              return tirar(items, economy, provider);
            },
          );
        },
      ),
    );
  }

  /// 👉 Navegación a pantalla de resultado múltiple
  void _gotoTenDetailsPage(BuildContext context, List<GachaItem> results) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) {
          return Scaffold(
            appBar: AppBar(title: const Text('Resultado multi')),
            body: Center(
              child: GachaTenResult(
                initialResults: results,
                onRepeat: (items) {
                  final provider = context.read<CollectionProvider>();
                  final economy = context.read<EconomyProvider>();
                  return rollTenPullGuaranteed(items, economy, provider);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  /// 📊 Pantalla de rates
  void showRates(BuildContext context, List<GachaItem> items) {
    final grouped = <Rarity, List<GachaItem>>{};
    for (var item in items) {
      grouped.putIfAbsent(item.rareza, () => []).add(item);
    }

    showModalBottomSheet(
      scrollControlDisabledMaxHeightRatio: 0.7,
      useSafeArea: true,
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const Text(
                "Probabilidad de invocación",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Pity: Cada tirada incrementa el pity si no es épico/legendario. Cuando se llega al límite la próxima tirada está garantizada de rareza alta. El contador se resetea al obtener una rareza alta',
                style: TextStyle(fontSize: 14),
              ),
              ...grouped.entries.map((entry) {
                final rarity = entry.key;
                final items = entry.value;
                final prob = items.isNotEmpty
                    ? probRaridad[items.first.rareza]
                    : 0.0;

                return ExpansionTile(
                  title: Text(
                    "${rarity.toString().split('.').last.toUpperCase()} - ${(prob)}%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: rarityBorderColors[rarity],
                    ),
                  ),
                  children: items
                      .map(
                        (i) => ListTile(
                          leading: Image.network(i.imagen, width: 40),
                          title: Text(i.title),
                        ),
                      )
                      .toList(),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void get1Random() {
    final economy = context.read<EconomyProvider>();
    final provider = context.read<CollectionProvider>();
    final result = tirar(dummyData, economy, provider);
    _gotoDetailsPage(context, result);
  }

  void get10Random() {
    final economy = context.read<EconomyProvider>();
    final provider = context.read<CollectionProvider>();
    final results = rollTenPullGuaranteed(dummyData, economy, provider);
    _gotoTenDetailsPage(context, results);
  }

  Future<bool> _checkAndSpendTickets(int requiredTickets) async {
    final economy = context.read<EconomyProvider>();

    if (economy.tickets >= requiredTickets) {
      economy.spendTickets(requiredTickets);
      return true;
    }

    int ticketsNeeded = requiredTickets - economy.tickets;

    // Calcular si puede comprar los tickets faltantes
    int costPerTicket = 100;
    int costTenTickets = 1000;

    bool canBuyExact = economy.coins >= ticketsNeeded * costPerTicket;
    bool canBuyTenBatch =
        ticketsNeeded >= 10 && economy.coins >= costTenTickets;

    if (!canBuyExact && !canBuyTenBatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No tienes tickets ni monedas suficientes"),
        ),
      );
      return false;
    }

    // Mostrar popup de confirmación
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Comprar tickets"),
              content: Text(
                "No tienes suficientes tickets. ¿Quieres comprar $ticketsNeeded ticket(s) con monedas para hacer la tirada?",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    // Comprar los tickets faltantes
                    if (canBuyTenBatch) {
                      economy.spendCoins(1000);
                      economy.addTickets(10);
                    } else if (canBuyExact) {
                      for (int i = 0; i < ticketsNeeded; i++) {
                        economy.spendCoins(100);
                        economy.addTickets(1);
                      }
                    }
                    // Gastar tickets necesarios para la tirada
                    economy.spendTickets(requiredTickets);
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Comprar"),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<bool> _checkGems(int requiredGems) async {
    final premium = context.read<PremiumCurrencyProvider>();

    if (premium.gems >= requiredGems) {
      premium.spendGems(requiredGems);
      return true;
    }

    return false;
  }
}
