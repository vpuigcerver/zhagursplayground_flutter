import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zhagurplayground/screens/GachaStyle/data/data.dart';
import 'package:zhagurplayground/screens/GachaStyle/models/gacha_item.dart';
import 'package:zhagurplayground/screens/GachaStyle/providers/economy_provider.dart';
import 'package:zhagurplayground/screens/GachaStyle/widgets/particle_emitter.dart';
import 'package:zhagurplayground/screens/GachaStyle/widgets/star_value_rate.dart';

import 'package:zhagurplayground/screens/GachaStyle/utils/utils.dart';

class GachaTenResult extends StatefulWidget {
  final List<GachaItem> initialResults;
  final List<GachaItem> Function(List<GachaItem> data) onRepeat;

  const GachaTenResult({
    super.key,
    required this.initialResults,
    required this.onRepeat,
  });

  @override
  State<GachaTenResult> createState() => _GachaTenResultState();
}

class _GachaTenResultState extends State<GachaTenResult> {
  int currentIndex = 0;
  bool skip = false;
  late List<GachaItem> _results;

  @override
  void initState() {
    super.initState();
    _results = widget.initialResults; // usamos la lista inicial
    _startAnimation();
  }

  void _doFullProcess() {
    setState(() {
      _results = widget.onRepeat(dummyData);
      skip = false;
      currentIndex = 0;
      _summaryShown = false;
    });
    _startAnimation();
  }

  void _onRepeatPressed() async {
    const int requiredTickets = 10;

    bool canProceed = await _checkAndSpendTickets(requiredTickets);
    if (!canProceed) return;

    _doFullProcess(); // reinicia animación + resultados
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
                "No tienes suficientes tickets. ¿Quieres comprar $ticketsNeeded ticket(s) con monedas para hacer la tirada múltiple?",
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
                      economy.addTickets(10);
                    } else if (canBuyExact) {
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

  void _startAnimation() async {
    for (int i = 0; i < _results.length; i++) {
      if (!mounted || skip) return;
      setState(() => currentIndex = i);
      await Future.delayed(const Duration(seconds: 4));
    }
    if (mounted && !skip) {
      setState(() => skip = true);
    }
  }

  void _skipToEnd() => setState(() => skip = true);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _skipToEnd,
      child: SafeArea(
        child: Center(
          child: skip
              ? _buildFinalResults()
              : _buildSingleResult(_results[currentIndex]),
        ),
      ),
    );
  }

  Widget _buildSingleResult(GachaItem item) {
    final borderColor = rarityBorderColors[item.rareza] ?? Colors.white;
    return Column(
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
                            border: Border.all(color: borderColor, width: 4),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              if (item.rareza != Rarity.common)
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
                              item.imagen,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (item.isNew)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withValues(alpha: 0.9),
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
                    Text(item.title, style: const TextStyle(fontSize: 21)),
                    const SizedBox(height: 20),
                    StarValueRate(
                      starValue: item.rareza.index,
                      style: StarStyles.big,
                      animate: true,
                    ),
                  ],
                );
              }
            },
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          "✨ Doble tap para saltar",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ],
    );
  }

  bool _summaryShown = false;
  Widget _buildFinalResults() {
    final guaranteed = _results.reduce(
      (a, b) => a.rareza.index > b.rareza.index ? a : b,
    );
    final others = _results.where((r) => r != guaranteed).toList();
    if (!_summaryShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSummaryDialog(_results);
        _summaryShown = true;
      });
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: others.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              return _buildResultCard(others[index]);
            },
          ),
          const SizedBox(height: 10),
          _buildResultCard(guaranteed, big: true),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.home),
                label: const Text("Menú"),
              ),
              ElevatedButton.icon(
                onPressed: _onRepeatPressed,
                icon: const Icon(Icons.replay),
                label: const Text("Repetir tirada"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(GachaItem item, {bool big = false}) {
    final borderColor = rarityBorderColors[item.rareza] ?? Colors.white;
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            ParticleEmitter(size: big ? 180 : 40, color: borderColor),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: big ? 4 : 2),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  if (item.rareza != Rarity.common)
                    BoxShadow(
                      color: borderColor.withValues(alpha: 0.6),
                      blurRadius: big ? 16 : 8,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.imagen,
                  height: big ? 160 : 80,
                  width: big ? 160 : 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (item.isNew)
              Positioned(
                top: big ? 6 : 0,
                right: big ? 6 : 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "¡Nuevo!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: big ? 12 : 8,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        StarValueRate(
          starValue: item.rareza.index,
          style: StarStyles.medium,
          animate: true,
        ),
      ],
    );
  }

  void _showSummaryDialog(List<GachaItem> results) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Resumen de tirada x10"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: results.length,
            itemBuilder: (context, index) {
              final item = results[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.imagen,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(item.title),
                subtitle: Text(
                  item.rareza.toString().split('.').last.toUpperCase(),
                  style: TextStyle(
                    color: rarityBorderColors[item.rareza],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: item.isNew
                    ? const Text(
                        "¡Nuevo!",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar"),
          ),
        ],
      ),
    );
  }
}
