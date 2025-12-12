part of 'main.dart';

class Estadisticasapp extends StatelessWidget {
  const Estadisticasapp({super.key});

  @override
  Widget build(BuildContext context) {
    String getExpansionNameFromSetCode(String setCode) {
      //El expansionName es el String antes del - en el setCode
      if (setCode.contains('-')) {
        return setCode.split('-')[0];
      } else {
        return setCode;
      }
    }

    String mostCommon(Map<String, int> map) {
      String mostCommonKey = '';
      int highestValue = 0;

      map.forEach((key, value) {
        if (value > highestValue) {
          highestValue = value;
          mostCommonKey = key;
        }
      });

      return mostCommonKey;
    }

    var appState = context.watch<YGOBinderState>();

    Map<String, int> cardsPerCardSet = {};
    Map<String, int> cardsPerExpansion = {};
    int totalCards = 0;

    for (var cardSet in appState.cardInventory.values) {
      for (var rarity in cardSet.values) {
        cardsPerCardSet.update(
          rarity.setCode,
          (value) => value + rarity.have,
          ifAbsent: () => rarity.have,
        );
      }
    }

    for (var entry in cardsPerCardSet.entries) {
      String setCode = entry.key;
      int count = entry.value;

      String expansionName = getExpansionNameFromSetCode(setCode);

      cardsPerExpansion.update(
        expansionName,
        (value) => value + count,
        ifAbsent: () => count,
      );
    }

    for (var count in cardsPerCardSet.values) {
      totalCards += count;
    }

    String mostCommonSet = mostCommon(cardsPerExpansion);

    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Numero total de cartas: $totalCards',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontFamily: 'Matrix',
              ),
            ),
            Text(
              'Expansion mas abundante: $mostCommonSet',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'Matrix',
              ),
            ),
          ],
        ),
      ),
    );
  }
}