part of 'main.dart';

class CardDetailPageApp extends StatelessWidget {
  final YGOCard card;

  const CardDetailPageApp({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<YGOBinderState>();

    final voidMethod = appState.loadImg(card);

    String auxAttribute = '';
    String auxArchetype = '';
    if (card.attribute != null) {
      auxAttribute = card.attribute!;
    }
    if (card.archetype != null) {
      auxArchetype = card.archetype!;
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(card.name),
              Center(
                child: FutureBuilder<void>(
                  future: voidMethod,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasError) {
                      return Container();
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }
                ),
              ),
              Text(card.type),
              Text(card.desc),
              card.atk == null ? Container() : Text(card.atk.toString()),
              card.def == null ? Container() : Text(card.def.toString()),
              card.level == null ? Container() : Text(card.level.toString()),
              card.race == "null" ? Container() : Text(card.race),
              card.attribute == null ? Container() : Text(auxAttribute),
              card.archetype == null ? Container() : Text(auxArchetype),
            ],
        ),
      ),
    ),
    );
  }
}