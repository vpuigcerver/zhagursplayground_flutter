import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zhagurplayground/screens/GachaStyle/data/data.dart';
import 'package:zhagurplayground/screens/GachaStyle/models/gacha_item.dart';
import 'package:zhagurplayground/screens/GachaStyle/providers/economy_provider.dart';
import 'package:zhagurplayground/screens/GachaStyle/widgets/button_repeat.dart';
import 'package:zhagurplayground/screens/GachaStyle/widgets/star_value_rate.dart';

import 'package:zhagurplayground/screens/GachaStyle/utils/utils.dart'; 

class GachaResult extends StatefulWidget {
  final GachaItem initialResult;
  final GachaItem Function(List<GachaItem> data) onRepeat;
  final StarStyles starStyles;

  const GachaResult({
    required this.initialResult,
    required this.starStyles,
    required this.onRepeat,
    super.key,
  });

  @override
  State<GachaResult> createState() => _GachaResultState();
}

class _GachaResultState extends State<GachaResult> {
  late GachaItem _results;

  @override
  void initState() {
    super.initState();
    _results = widget.initialResult; // usamos el resultado inicial
  }

  Future<void> _loadResults() async {
    final newResult = widget.onRepeat(dummyData);
    setState(() {
      _results = newResult;
    });
  }

  void _onRepeatPressed() async {
    const int requiredTickets = 1;

    bool canProceed = await _checkAndSpendTickets(requiredTickets);
    if (!canProceed) return;

    // Ejecutar tirada
    _loadResults();
  }

  Future<bool> _checkAndSpendTickets(int requiredTickets) async {
    final economy = context.read<EconomyProvider>();

    if (economy.tickets >= requiredTickets) {
      economy.spendTickets(requiredTickets);
      return true;
    }

    int ticketsNeeded = requiredTickets - economy.tickets;

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
                    if (canBuyExact) {
                      for (int i = 0; i < ticketsNeeded; i++) {
                        economy.addTickets(1);
                      }
                    }
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

  @override
  Widget build(BuildContext context) {
    final borderColor = rarityBorderColors[_results.rareza] ?? Colors.white;

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: FutureBuilder(
                future: Future.delayed(const Duration(seconds: 2)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Image.asset(
                      'assets/images/gacha/coleccion/anim_obs.gif',
                      key: const ValueKey('gif'),
                    );
                  } else {
                    return Column(
                      key: const ValueKey('result'),
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: borderColor,
                                  width: 4,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: borderColor.withValues(alpha: 0.6),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.network(
                                  _results.imagen,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            if (_results.isNew)
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.withValues(
                                      alpha: 0.9,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    "¡Nuevo!",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _results.title,
                          style: const TextStyle(fontSize: 21),
                        ),
                        const SizedBox(height: 20),
                        StarValueRate(
                          starValue: _results.rareza.index,
                          style: widget.starStyles,
                          animate: true,
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.home),
                              label: const Text("Menú"),
                            ),
                            ButtonRepeat(onPressed: _onRepeatPressed),
                          ],
                        ),
                      ],
                    )
                    ;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
