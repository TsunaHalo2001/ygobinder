part of 'main.dart';

class CardDetailPageApp extends StatefulWidget {
  final YGOCard card;

  const CardDetailPageApp({super.key, required this.card});

  @override
  State<CardDetailPageApp> createState() => _CardDetailPageAppState();
}

class _CardDetailPageAppState extends State<CardDetailPageApp> {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<YGOBinderState>();
    final screenSize = MediaQuery.of(context).size;
    final cardGradient = CardColor.getCardGradient(widget.card.frameType);

    final imageByte = appState.images[widget.card.id];

    String auxAttribute = '';
    String auxArchetype = '';
    if (widget.card.attribute != null) {
      auxAttribute = widget.card.attribute!;
    }
    if (widget.card.archetype != null) {
      auxArchetype = widget.card.archetype!;
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: cardGradient
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  widget.card.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenSize.width > screenSize.height ?
                      screenSize.width * 0.35 * 0.1 :
                      screenSize.width * 0.8 * 0.1,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Matrix',
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
                Center(
                  child: imageByte == null ?
                    Container() :
                    SizedBox(
                        width: screenSize.height > screenSize.width ? screenSize.width : 200,
                        height: screenSize.height > screenSize.width ? screenSize.width : 200,
                        child: Image.memory(
                          appState.images[widget.card.id]!,
                          fit: BoxFit.cover,
                        ),
                      ),
                ),
                Text(widget.card.type),
                Text(widget.card.desc),
                widget.card.atk == null ? Container() : Text(widget.card.atk.toString()),
                widget.card.def == null ? Container() : Text(widget.card.def.toString()),
                widget.card.level == null ? Container() : Text(widget.card.level.toString()),
                widget.card.race == "null" ? Container() : Text(widget.card.race),
                widget.card.attribute == null ? Container() : Text(auxAttribute),
                widget.card.archetype == null ? Container() : Text(auxArchetype),
              ],
          ),
        ),
            ),
      ),
    );
  }
}