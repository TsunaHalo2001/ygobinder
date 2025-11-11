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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(widget.card.name),
              Center(
                child: imageByte == null ?
                  Container() :
                  SizedBox(
                      width: 200,
                      height: 200,
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
    );
  }
}