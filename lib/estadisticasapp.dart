part of 'main.dart';

class Estadisticasapp extends StatefulWidget {
  const Estadisticasapp({super.key});

  @override
  State<Estadisticasapp> createState() => _EstadisticasappState();
}

class _EstadisticasappState extends State<Estadisticasapp> {
  late Map<String, int> cardsPerCardSet;
  late Map<String, int> sortedCardsPerCardSet;
  late Map<String, int> cardsPerExpansion;
  late Map<String, int> sortedCardsPerExpansion;
  late Map<int, int> perCardCount;
  late Map<int, int> sortedPerCardCount;
  late int totalCards;
  late String mostCommonSet;
  late Map<String, int> first5sets;
  late List<ChartData> first5setsData;
  late TooltipBehavior first5setsTooltip;
  late String mostCommonCard;
  late Map<String, int> first5cards;
  late List<ChartData> first5cardsData;
  late TooltipBehavior first5cardsTooltip;

  @override
  void initState() {
    var appState = context.read<YGOBinderState>();

    cardsPerCardSet = {};
    for (var cardSet in appState.cardInventory.values) {
      for (var rarity in cardSet.values) {
        cardsPerCardSet.update(
          rarity.setCode,
              (value) => value + rarity.have,
          ifAbsent: () => rarity.have,
        );
      }
    }

    sortedCardsPerCardSet = Map.fromEntries(
      cardsPerCardSet.entries.toList()
        ..sort((e1, e2) => e2.value.compareTo(e1.value)),
    );

    cardsPerExpansion = {};
    for (var entry in sortedCardsPerCardSet.entries) {
      String setCode = entry.key;
      int count = entry.value;

      String expansionName = appState.getExpansionNameFromSetCode(setCode);

      cardsPerExpansion.update(
        expansionName,
            (value) => value + count,
        ifAbsent: () => count,
      );
    }

    sortedCardsPerExpansion = Map.fromEntries(
      cardsPerExpansion.entries.toList()
        ..sort((e1, e2) => e2.value.compareTo(e1.value)),
    );

    perCardCount = {};
    for (var cardSet in appState.cardInventory.values) {
      for (var rarity in cardSet.values) {
        perCardCount.update(
          rarity.id,
              (value) => value + rarity.have,
          ifAbsent: () => rarity.have,
        );
      }
    }

    sortedPerCardCount = Map.fromEntries(
      perCardCount.entries.toList()
        ..sort((e1, e2) => e2.value.compareTo(e1.value)),
    );

    totalCards = 0;
    for (var count in sortedCardsPerCardSet.values) {
      totalCards += count;
    }

    mostCommonSet = sortedCardsPerExpansion.keys.first;

    first5sets = sortedCardsPerExpansion.entries
        .take(5)
        .fold({}, (map, entry) {
      map[entry.key] = entry.value;
      return map;
    });

    first5setsData = first5sets.entries
        .map((entry) => ChartData(entry.key, entry.value))
        .toList();

    first5setsData.add(ChartData('Others', sortedCardsPerExpansion.entries
        .skip(5)
        .fold(0, (sum, entry) => sum + entry.value)));

    first5setsTooltip = TooltipBehavior(enable: true);

    mostCommonCard = appState.cards[sortedPerCardCount.keys.first]?.name ?? 'Desconocida';

    first5cards = sortedPerCardCount.entries
        .take(5)
        .fold({}, (map, entry) {
      map[appState.cards[entry.key]?.name ?? 'Desconocida'] = entry.value;
      return map;
    });

    first5cardsData = first5cards.entries
        .map((entry) => ChartData(entry.key, entry.value))
        .toList();

    first5cardsData.add(ChartData('Others', sortedPerCardCount.entries
        .skip(5)
        .fold(0, (sum, entry) => sum + entry.value)));

    first5cardsTooltip = TooltipBehavior(enable: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<YGOBinderState>();
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLandscape = screenSize.width > screenSize.height;

    return Center(
      child: SingleChildScrollView(
        scrollDirection: isLandscape ? Axis.horizontal : Axis.vertical,
        child: isLandscape ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildStatsBoxes(screenSize, appState),
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildStatsBoxes(screenSize, appState),
        ),
      ),
    );
  }

  List<Widget> buildStatsBoxes(Size screenSize, YGOBinderState appState) {
    final bool isLandscape = screenSize.width > screenSize.height;

    final titleFont = isLandscape
        ? screenSize.height * 0.05
        : screenSize.width * 0.07;
    final totalFont = isLandscape
        ? screenSize.height * 0.3
        : screenSize.width * 0.15;
    final infoFont = isLandscape
        ? screenSize.height * 0.05
        : screenSize.width * 0.05;

    return [
      buildStatsBox(
        isLandscape ?
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Numero total de cartas: ',
                style: TextStyle(
                  fontSize: titleFont,
                  color: Colors.white,
                  fontFamily: 'Matrix',
                  shadows: [
                    Shadow(
                      color: Colors.black.withAlpha(95),
                      offset: const Offset(1.0, 1.0),
                      blurRadius: 2.0,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            Text(
              '$totalCards',
              style: TextStyle(
                fontSize: totalFont,
                color: Colors.yellow,
                fontFamily: 'Matrix',
                shadows: [
                  Shadow(
                    color: Colors.black.withAlpha(95),
                    offset: const Offset(1.0, 1.0),
                    blurRadius: 2.0,
                  ),
                ],
              ),
            ),
          ],
        ) :
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Numero total de cartas: ',
              style: TextStyle(
                fontSize: titleFont,
                color: Colors.white,
                fontFamily: 'Matrix',
                shadows: [
                  Shadow(
                    color: Colors.black.withAlpha(95),
                    offset: const Offset(1.0, 1.0),
                    blurRadius: 2.0,
                  ),
                ],
              ),
            ),
            Text(
              '$totalCards',
              style: TextStyle(
                fontSize: totalFont,
                color: Colors.yellow,
                fontFamily: 'Matrix',
                shadows: [
                  Shadow(
                    color: Colors.black.withAlpha(95),
                    offset: const Offset(1.0, 1.0),
                    blurRadius: 2.0,
                  ),
                ],
              ),
            ),
          ],
        ),
        screenSize,
      ),
      buildStatsBox(
        Column(
          children: [
            Column(
              children: [
                Text(
                  'Expansion mas abundante: ',
                  style: TextStyle(
                    fontSize: titleFont,
                    color: Colors.white,
                    fontFamily: 'Matrix',
                    shadows: [
                      Shadow(
                        color: Colors.black.withAlpha(95),
                        offset: const Offset(1.0, 1.0),
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                ),
                Text(
                  '${appState.allCardSets[mostCommonSet]}',
                  style: TextStyle(
                    fontSize: infoFont,
                    color: Colors.yellow,
                    fontFamily: 'Matrix',
                    shadows: [
                      Shadow(
                        color: Colors.black.withAlpha(95),
                        offset: const Offset(1.0, 1.0),
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SfCircularChart(
              tooltipBehavior: first5setsTooltip,
              series: <CircularSeries<ChartData, String>>[
                DoughnutSeries<ChartData, String>(
                  strokeWidth: 2,
                  strokeColor: Colors.black.withAlpha(80),
                  explode: true,
                  explodeIndex: 0,
                  explodeOffset: '10%',
                  dataSource: first5setsData,
                  xValueMapper: (ChartData data, _) => data.label,
                  yValueMapper: (ChartData data, _) => data.value,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(
                      fontSize: titleFont * 0.8,
                      color: Colors.white,
                      fontFamily: 'Matrix',
                      shadows: [
                        Shadow(
                          color: Colors.black.withAlpha(95),
                          offset: const Offset(1.0, 1.0),
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        screenSize,
      ),
      buildStatsBox(
        Column(
          children: [
            Column(
              children: [
                Text(
                  'Carta mas abundante: ',
                  style: TextStyle(
                    fontSize: titleFont * 0.8,
                    color: Colors.white,
                    fontFamily: 'Matrix',
                    shadows: [
                      Shadow(
                        color: Colors.black.withAlpha(95),
                        offset: const Offset(1.0, 1.0),
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                ),
                Text(
                  mostCommonCard,
                  style: TextStyle(
                    fontSize: infoFont,
                    color: Colors.yellow,
                    fontFamily: 'Matrix',
                    shadows: [
                      Shadow(
                        color: Colors.black.withAlpha(95),
                        offset: const Offset(1.0, 1.0),
                        blurRadius: 2.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SfCircularChart(
              tooltipBehavior: first5cardsTooltip,
              series: <CircularSeries<ChartData, String>>[
                DoughnutSeries<ChartData, String>(
                  strokeWidth: 2,
                  strokeColor: Colors.black.withAlpha(80),
                  explode: true,
                  explodeIndex: 0,
                  explodeOffset: '10%',
                  dataSource: first5cardsData,
                  xValueMapper: (ChartData data, _) => data.label,
                  yValueMapper: (ChartData data, _) => data.value,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(
                      fontSize: titleFont,
                      color: Colors.white,
                      fontFamily: 'Matrix',
                      shadows: [
                        Shadow(
                          color: Colors.black.withAlpha(95),
                          offset: const Offset(1.0, 1.0),
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        screenSize
      ),
    ];
  }

  Widget buildStatsBox(Widget child, Size screenSize) {
    final boxesWidth = screenSize.width > screenSize.height
        ? screenSize.height * 0.6
        : screenSize.width * 0.9;

    final isLandscape = screenSize.width > screenSize.height;

    final boxesHeight = isLandscape
        ? screenSize.height * 0.8
        : null;

    return Container(
      width: boxesWidth,
      height: boxesHeight,
      margin: EdgeInsets.all(screenSize.height * 0.02),
      padding: EdgeInsets.all(screenSize.height * 0.02),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(80),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(child: child),
    );
  }
}

class ChartData {
  final String label;
  final int value;

  ChartData(this.label, this.value);
}