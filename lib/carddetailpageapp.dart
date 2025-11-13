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
    final cardType = widget.card.type;

    final List<bool> validMarkers = widget.card.frameType == 'link' ? [
      widget.card.linkMarkers!.contains('Bottom-Left'),
      widget.card.linkMarkers!.contains('Left'),
      widget.card.linkMarkers!.contains('Top-Left'),
      widget.card.linkMarkers!.contains('Top'),
      widget.card.linkMarkers!.contains('Top-Right'),
      widget.card.linkMarkers!.contains('Right'),
      widget.card.linkMarkers!.contains('Bottom-Right'),
      widget.card.linkMarkers!.contains('Bottom'),
    ] : List.filled(8, false);

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        widget.card.name,
                        textAlign: TextAlign.center,
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
                    ),
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: widget.card.attribute == null ?
                        appState.attributeImages[widget.card.frameType] :
                        appState.attributeImages[widget.card.attribute],
                    ),
                  ],
                ),
                widget.card.frameType == 'link' ? Container() :
                widget.card.level == null ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "[$cardType]",
                      textAlign: TextAlign.end,
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
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: appState.attributeImages[widget.card.race],
                    ),
                  ],
                )
                    :
                Row(
                  mainAxisAlignment: widget.card.frameType!.contains('xyz') ?
                    MainAxisAlignment.start :
                    MainAxisAlignment.end,
                  children: List.generate(widget.card.level!,
                      (index) => SizedBox(
                        width: 32,
                        height: 32,
                        child: widget.card.frameType!.contains('xyz') ?
                          appState.attributeImages['rank']! :
                          appState.attributeImages['level']!,
                      ),
                  ),
                ),
                Center(
                  child: imageByte == null ? Container() :
                    widget.card.frameType == 'link' ?
                    SizedBox(
                      width: screenSize.height > screenSize.width ? screenSize.width : 200,
                      height: screenSize.height > screenSize.width ? screenSize.width : 200,
                      child: Stack(
                        children: [
                          Image.memory(
                          appState.images[widget.card.id]!,
                          fit: BoxFit.cover,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildLinkArrow(
                                      direction: 2,
                                      isSolid: validMarkers[2],
                                      saiz: screenSize.width * 0.1,
                                    ),
                                    buildLinkArrow(
                                      direction: 3,
                                      isSolid: validMarkers[3],
                                      saiz: screenSize.width * 0.1,
                                    ),
                                    buildLinkArrow(
                                      direction: 4,
                                      isSolid: validMarkers[4],
                                      saiz: screenSize.width * 0.1,
                                    ),
                                  ]
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  buildLinkArrow(
                                    direction: 1,
                                    isSolid: validMarkers[1],
                                    saiz: screenSize.width * 0.1,
                                  ),
                                  buildLinkArrow(
                                    direction: 5,
                                    isSolid: validMarkers[5],
                                    saiz: screenSize.width * 0.1,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  buildLinkArrow(
                                    direction: 0,
                                    isSolid: validMarkers[0],
                                    saiz: screenSize.width * 0.1,
                                  ),
                                  buildLinkArrow(
                                    direction: 7,
                                    isSolid: validMarkers[7],
                                    saiz: screenSize.width * 0.1,
                                  ),
                                  buildLinkArrow(
                                    direction: 6,
                                    isSolid: validMarkers[6],
                                    saiz: screenSize.width * 0.1,
                                  ),
                                ]
                              ),
                            ],
                          ),
                        ],
                      ),
                    ) :
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

  Widget buildLinkArrow({
    required int direction,
    required bool isSolid,
    required double saiz,
  }) {
    return SizedBox(
      width: saiz,
      height: saiz,
      child: Transform.rotate(
        angle: direction * pi / 4,
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CustomPaint(
            painter: LinkArrowPainter(
              isSolid: isSolid,
              saiz: saiz,
            ),
          ),
        ),
      ),
    );
  }
}

class LinkArrowPainter extends CustomPainter {
  final bool isSolid;
  final double saiz;

  LinkArrowPainter({
    this.isSolid = false,
    required this.saiz,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(saiz * 0.95, saiz * 0.95);
    path.lineTo(saiz * 0.05, saiz * 0.95);
    path.lineTo(saiz * 0.05, saiz * 0.05);
    path.close();

    final strokePaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = saiz * 0.1;

    final fillPaint = Paint()
      ..color = isSolid ? Colors.redAccent : Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}