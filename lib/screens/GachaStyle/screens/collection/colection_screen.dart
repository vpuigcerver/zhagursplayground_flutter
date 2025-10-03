//import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zhagurplayground/screens/GachaStyle/data/data.dart';

import 'package:zhagurplayground/screens/GachaStyle/models/gacha_item.dart';

import 'package:zhagurplayground/screens/GachaStyle/widgets/star_value_rate.dart';
import 'package:zhagurplayground/screens/GachaStyle/utils/utils.dart';
import 'package:zhagurplayground/screens/GachaStyle/providers/collection_provider.dart';
import 'package:provider/provider.dart';

class ColectionScreen extends StatefulWidget {
  const ColectionScreen({super.key});

  @override
  State<ColectionScreen> createState() => _ColectionScreenState();
}

class _ColectionScreenState extends State<ColectionScreen> {
  int sortIndex = 0;
  @override
  Widget build(BuildContext context) {
    // Accedemos al provider de colección
    final collection = context.watch<CollectionProvider>();
    final List<GachaItem> availableGachas = dummyData.map((item) {
      return item.copyWith(unlocked: collection.isUnlocked(item.id));
    }).toList();

    //final availableGachas = context.watch<CollectionProvider>().items;
    const List<Icon?> customizations = [
      Icon(Icons.format_list_numbered),
      Icon(Icons.lock_open_rounded),
      Icon(Icons.star_half_rounded),
    ];

    availableGachas.sort((a, b) {
      switch (sortIndex) {
        case 0:
          print("sort by id");
          //sort by id
          return a.id.compareTo(b.id);
        case 1:
          print("sort by locked");
          //sort by unlocked
          if (a.unlocked && !b.unlocked) return -1;
          if (!a.unlocked && b.unlocked) return 1;
          return a.id.compareTo(b.id);
        case 2:
          print("sort by rarity");
          //sort by rarity
          if (a.rareza.index < b.rareza.index) {
            return 1;
          }
          if (a.rareza.index > b.rareza.index) {
            return -1;
          }
          //sort by id
          return a.id.compareTo(b.id);

        default:
          return 0;
      }
    });

    return Stack(
      children: [
        MaterialApp(
          home: Card(
            child: GridView.builder(
              padding: const EdgeInsets.all(12.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),

              itemCount: availableGachas.length,
              itemBuilder: (BuildContext context, int index) {
                final gacha = availableGachas[index];
                return GridTile(
                  header: GridTileBar(
                    title: Text(
                      '${gacha.id + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      gradient: const RadialGradient(
                        colors: <Color>[Color(0x0F88EEFF), Color(0x2F0099BB)],
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        gacha.unlocked
                            ? print(gacha.title)
                            : null;
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          gacha.unlocked
                              ? Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          rarityBorderColors[gacha
                                              .rareza]!,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      if (gacha.rareza !=
                                          Rarity.common)
                                        BoxShadow(
                                          color:
                                              rarityBorderColors[gacha
                                                      .rareza]!
                                                  .withValues(alpha: 0.6),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.network(
                                      gacha.imagen,
                                    ),
                                  ),
                                )
                              : Image.asset(
                                  "assets/images/gacha/coleccion/blocked.png",
                                ),
                          !gacha.unlocked
                              ? Container()
                              : StarValueRate(
                                  starValue:
                                      gacha.rareza.index,
                                  style: StarStyles.small,
                                  animate: false,
                                ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                sortIndex = (sortIndex + 1) % customizations.length;
              });
            },
            child: customizations[sortIndex],
          ),
        ),
      ],
    );
  }
}

class CustomGridDelegate extends SliverGridDelegate {
  CustomGridDelegate({required this.dimension});

  // This is the desired height of each row (and width of each square).
  // When there is not enough room, we shrink this to the width of the scroll view.
  final double dimension;

  // The layout is two rows of squares, then one very wide cell, repeat.

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    // Determine how many squares we can fit per row.
    int count = constraints.crossAxisExtent ~/ dimension;
    if (count < 1) {
      count = 1; // Always fit at least one regardless.
    }
    final double squareDimension = constraints.crossAxisExtent / count;
    return CustomGridLayout(
      crossAxisCount: count,
      fullRowPeriod:
          3, // Number of rows per block (one of which is the full row).
      dimension: squareDimension,
    );
  }

  @override
  bool shouldRelayout(CustomGridDelegate oldDelegate) {
    return dimension != oldDelegate.dimension;
  }
}

class CustomGridLayout extends SliverGridLayout {
  const CustomGridLayout({
    required this.crossAxisCount,
    required this.dimension,
    required this.fullRowPeriod,
  }) : assert(crossAxisCount > 0),
       assert(fullRowPeriod > 1),
       loopLength = crossAxisCount * (fullRowPeriod - 1) + 1,
       loopHeight = fullRowPeriod * dimension;

  final int crossAxisCount;
  final double dimension;
  final int fullRowPeriod;

  // Computed values.
  final int loopLength;
  final double loopHeight;

  @override
  double computeMaxScrollOffset(int childCount) {
    // This returns the scroll offset of the end side of the childCount'th child.
    // In the case of this example, this method is not used, since the grid is
    // infinite. However, if one set an itemCount on the GridView above, this
    // function would be used to determine how far to allow the user to scroll.
    if (childCount == 0 || dimension == 0) {
      return 0;
    }
    return (childCount ~/ loopLength) * loopHeight +
        ((childCount % loopLength) ~/ crossAxisCount) * dimension;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    // This returns the position of the index'th tile.
    //
    // The SliverGridGeometry object returned from this method has four
    // properties. For a grid that scrolls down, as in this example, the four
    // properties are equivalent to x,y,width,height. However, since the
    // GridView is direction agnostic, the names used for SliverGridGeometry are
    // also direction-agnostic.
    //
    // Try changing the scrollDirection and reverse properties on the GridView
    // to see how this algorithm works in any direction (and why, therefore, the
    // names are direction-agnostic).
    final int loop = index ~/ loopLength;
    final int loopIndex = index % loopLength;
    if (loopIndex == loopLength - 1) {
      // Full width case.
      return SliverGridGeometry(
        scrollOffset: (loop + 1) * loopHeight - dimension, // "y"
        crossAxisOffset: 0, // "x"
        mainAxisExtent: dimension, // "height"
        crossAxisExtent: crossAxisCount * dimension, // "width"
      );
    }
    // Square case.
    final int rowIndex = loopIndex ~/ crossAxisCount;
    final int columnIndex = loopIndex % crossAxisCount;
    return SliverGridGeometry(
      scrollOffset: (loop * loopHeight) + (rowIndex * dimension), // "y"
      crossAxisOffset: columnIndex * dimension, // "x"
      mainAxisExtent: dimension, // "height"
      crossAxisExtent: dimension, // "width"
    );
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    // This returns the first index that is visible for a given scrollOffset.
    //
    // The GridView only asks for the geometry of children that are visible
    // between the scroll offset passed to getMinChildIndexForScrollOffset and
    // the scroll offset passed to getMaxChildIndexForScrollOffset.
    //
    // It is the responsibility of the SliverGridLayout to ensure that
    // getGeometryForChildIndex is consistent with getMinChildIndexForScrollOffset
    // and getMaxChildIndexForScrollOffset.
    //
    // Not every child between the minimum child index and the maximum child
    // index need be visible (some may have scroll offsets that are outside the
    // view; this happens commonly when the grid view places tiles out of
    // order). However, doing this means the grid view is less efficient, as it
    // will do work for children that are not visible. It is preferred that the
    // children are returned in the order that they are laid out.
    final int rows = scrollOffset ~/ dimension;
    final int loops = rows ~/ fullRowPeriod;
    final int extra = rows % fullRowPeriod;
    return loops * loopLength + extra * crossAxisCount;
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    // (See commentary above.)
    final int rows = scrollOffset ~/ dimension;
    final int loops = rows ~/ fullRowPeriod;
    final int extra = rows % fullRowPeriod;
    final int count = loops * loopLength + extra * crossAxisCount;
    if (extra == fullRowPeriod - 1) {
      return count;
    }
    return count + crossAxisCount - 1;
  }
}
