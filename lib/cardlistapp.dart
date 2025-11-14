part of 'main.dart';

class CardListApp extends StatefulWidget {
  const CardListApp({super.key});

  @override
  CardListAppState createState() => CardListAppState();
}

class CardListAppState extends State<CardListApp> {
  void _updateSelectedChunk(int index, List<List<YGOCard>> chunkedCards,YGOBinderState appState) {
    if (index == appState.selectedIndexCardList) return;
    setState(() {
      appState.setSelectedIndexCardList(index);
    });
    
    appState.updateSelectedChunk(chunkedCards[appState.selectedIndexCardList]);
  }

  @override
  void initState() {
    super.initState();
    final appState = context.read<YGOBinderState>();

    final chunkedCards = YGOCard.chunkList(appState.cards, 20, appState);
    appState.updateSelectedChunk(chunkedCards[appState.selectedIndexCardList]);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<YGOBinderState>();
    final Size screenSize = MediaQuery.of(context).size;
    final chunkedCards = YGOCard.chunkList(appState.cards, 20, appState);

    return Scaffold(
      backgroundColor: Color(0xFF4D2C6F),
      body: screenSize.height > screenSize.width ?
      Column(
        children: [
          _buildCardShower(context, chunkedCards),
          _paginationBuilder(context, chunkedCards.length, chunkedCards),
        ],
      ) :
      Row(
        children: [
          _buildCardShower(context, chunkedCards),
          _paginationBuilder(context, chunkedCards.length, chunkedCards),
        ],
      ),
    );
  }

  Widget _buildCardShower(BuildContext context, List<List<YGOCard>> chunkedCards) {
    final appState = context.watch<YGOBinderState>();
    final Size screenSize = MediaQuery.of(context).size;

    return Expanded(
      child: GridView.builder(
          padding: EdgeInsets.all(1.0),

          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: screenSize.width > 200 ? 200 : screenSize.width,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            childAspectRatio: 0.8,
          ),

          itemCount: chunkedCards[appState.selectedIndexCardList].length,

          itemBuilder: (context, index) {
            final card = chunkedCards[appState.selectedIndexCardList].elementAt(index);
            return _buildCardCard(context, card, appState.images[card.id]);
          }
      ),
    );
  }

  Widget _buildCardCard(BuildContext context, YGOCard card, Uint8List? image) {
    final cardGradient = CardColor.getCardGradient(card.frameType);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CardDetailPageApp(card: card),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: cardGradient,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            children: [
              image == null ?
              Container() :
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.memory(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        card.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Matrix',
                          height: 1.0,
                          fontSize: 21,
                          shadows: [
                            Shadow(
                              color: Colors.black.withAlpha(95),
                              offset: const Offset(2.0, 2.0),
                              blurRadius: 3.0,
                            ),
                            Shadow(
                              color: Colors.white.withAlpha(5),
                              offset: const Offset(1.0, 1.0),
                              blurRadius: 1.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paginationBuilder(BuildContext context, int nPages, List<List<YGOCard>> chunkedCards) {
    var screenSize = MediaQuery.of(context).size;
    var appState = context.watch<YGOBinderState>();
    final isPortrait = screenSize.height > screenSize.width;

    if (nPages <= 1) return const SizedBox.shrink();

    final Color selectedColor = Colors.amber.shade700;
    final Color unselectedColor = Color(0xFF4D2C6F);

    return SizedBox(
      height: isPortrait ? screenSize.height * 0.05 : null,
      width: isPortrait ? null : screenSize.width * 0.05,
      child: ListView.builder(
        scrollDirection: isPortrait ? Axis.horizontal : Axis.vertical,
        itemCount: nPages,
        itemBuilder: (context, index) {
          final pageN = index + 1;
          final isSelected = index == appState.selectedIndexCardList;

          return GestureDetector(
            onTap: () => _updateSelectedChunk(index, chunkedCards, appState),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 32,
              height: 32,
              margin: EdgeInsets.symmetric(
                horizontal: isPortrait ? 4.0 : 0,
                vertical: isPortrait ? 0 : 4.0,
              ),
              decoration: BoxDecoration(
                color: isSelected ? selectedColor : unselectedColor,
                borderRadius: BorderRadius.circular(5),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: selectedColor.withAlpha(70),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  )
                ]
                    : [],

              ),
              child: Center(
                child: Text(
                  pageN.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Matrix',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}