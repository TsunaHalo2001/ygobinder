part of 'main.dart';

class CardListApp extends StatefulWidget {
  const CardListApp({super.key});

  @override
  CardListAppState createState() => CardListAppState();
}

class CardListAppState extends State<CardListApp> {
  int _selectedChunk = 0;

  void _updateSelectedChunk(int index) {
    setState(() {
      _selectedChunk = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<YGOBinderState>();
    final Size screenSize = MediaQuery.of(context).size;
    final chunkedCards = YGOCard.chunkList(appState.cards, 20);

    return Scaffold(
      backgroundColor: Color(0xFF4D2C6F),
      body: screenSize.height > screenSize.width ?
      Column(
        children: [
          _buildCardShower(context, chunkedCards),
          _paginationBuilder(context, chunkedCards.length),
        ],
      ) :
      Row(
        children: [
          _buildCardShower(context, chunkedCards),
          _paginationBuilder(context, chunkedCards.length),
        ],
      ),
    );
  }

  Widget _buildCardShower(BuildContext context, List<List<YGOCard>> chunkedCards) {
    return Expanded(
      child: GridView.builder(
          padding: EdgeInsets.all(1.0),

          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            childAspectRatio: 0.8,
          ),

          itemCount: chunkedCards[_selectedChunk].length,

          itemBuilder: (context, index) {
            final card = chunkedCards[_selectedChunk].elementAt(index);
            return _buildCardCard(context, card);
          }
      ),
    );
  }

  Widget _buildCardCard(BuildContext context, YGOCard card) {
    final cardGradient = CardColor.getCardGradient(card.frameType);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: cardGradient,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          card.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _paginationBuilder(BuildContext context, int nPages) {
    var screenSize = MediaQuery.of(context).size;
    if (nPages <= 1) return const SizedBox.shrink();

    return SizedBox(
      height: screenSize.height < screenSize.width ? null :
        screenSize.height * 0.05,
      width: screenSize.width < screenSize.height ? null :
        screenSize.width * 0.05,
      child: ListView.builder(
        scrollDirection: screenSize.height > screenSize.width ?
          Axis.horizontal : Axis.vertical,
        itemCount: nPages,
        itemBuilder: (context, index) {
          final pageN = index + 1;
          final isSelected = index == _selectedChunk;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.0),
            child: ActionChip(
              onPressed: () => _updateSelectedChunk(index),
              backgroundColor: isSelected ? Colors.black : Colors.white,
              label: Text(
                pageN.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}