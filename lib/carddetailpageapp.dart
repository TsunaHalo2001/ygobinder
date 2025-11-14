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
    final isPortrait = screenSize.width > screenSize.height;

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
          child: Row(
            children: [
              !isPortrait ? Container() :
              SizedBox(
                height: screenSize.height,
                width: screenSize.height,
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8,8,0,8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(
                              color: Colors.black.withAlpha(50),
                              width: 4,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        widget.card.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenSize.width * 0.37 * 0.1,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Matrix',
                                          height: 1,
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
                                SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                    child: widget.card.attribute == null ?
                                    appState.attributeImages[widget.card.frameType] :
                                    appState.attributeImages[widget.card.attribute],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    widget.card.frameType == 'link' ? Container() :
                    widget.card.level == null ?
                    SizedBox(
                      height: screenSize.height * 0.086,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "[$cardType]",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenSize.width * 0.35 * 0.1,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Matrix',
                              height: 0,
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
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(100),
                                  border: widget.card.race == 'Normal' ? null :
                                  Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: appState.attributeImages[widget.card.race]
                            ),
                          ),
                        ],
                      ),
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            child: widget.card.frameType!.contains('xyz') ?
                            appState.attributeImages['rank']! :
                            appState.attributeImages['level']!,
                          ),
                        ),
                      ),
                    ),
                    !isPortrait ? Container() :
                    Center(
                      child: imageByte == null ? Container() :
                      widget.card.frameType == 'link' ?
                      SizedBox(
                        width: screenSize.height * 0.75,
                        height: screenSize.height * 0.75,
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
                                        saiz: screenSize.height * 0.1,
                                      ),
                                      buildLinkArrow(
                                        direction: 3,
                                        isSolid: validMarkers[3],
                                        saiz: screenSize.height * 0.1,
                                      ),
                                      buildLinkArrow(
                                        direction: 4,
                                        isSolid: validMarkers[4],
                                        saiz: screenSize.height * 0.1,
                                      ),
                                    ]
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildLinkArrow(
                                      direction: 1,
                                      isSolid: validMarkers[1],
                                      saiz: screenSize.height * 0.1,
                                    ),
                                    buildLinkArrow(
                                      direction: 5,
                                      isSolid: validMarkers[5],
                                      saiz: screenSize.height * 0.1,
                                    ),
                                  ],
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildLinkArrow(
                                        direction: 0,
                                        isSolid: validMarkers[0],
                                        saiz: screenSize.height * 0.1,
                                      ),
                                      buildLinkArrow(
                                        direction: 7,
                                        isSolid: validMarkers[7],
                                        saiz: screenSize.height * 0.1,
                                      ),
                                      buildLinkArrow(
                                        direction: 6,
                                        isSolid: validMarkers[6],
                                        saiz: screenSize.height * 0.1,
                                      ),
                                    ]
                                ),
                              ],
                            ),
                          ],
                        ),
                      ) :
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: widget.card.type == 'Spell Card' || widget.card.type == 'Trap Card' ?
                            screenSize.height * 0.67 :
                            screenSize.height * 0.67,
                          height: widget.card.type == 'Spell Card' || widget.card.type == 'Trap Card' ?
                            screenSize.height * 0.67 :
                            screenSize.height * 0.67,
                          child: Image.memory(
                            appState.images[widget.card.id]!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      isPortrait ? Container() : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(
                              color: Colors.black.withAlpha(50),
                              width: 4,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      widget.card.name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenSize.width * 0.8 * 0.1,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Matrix',
                                        height: 1,
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
                                SizedBox(
                                  width: 32,
                                  height: 32,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1,
                                      ),
                                    ),
                                    child: widget.card.attribute == null ?
                                      appState.attributeImages[widget.card.frameType] :
                                      appState.attributeImages[widget.card.attribute],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      isPortrait ? Container() :
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
                              fontSize: screenSize.width * 0.8 * 0.1,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Matrix',
                              height: 1,
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
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(100),
                                border: widget.card.race == 'Normal' ? null :
                                Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: appState.attributeImages[widget.card.race]
                            ),
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
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: widget.card.frameType!.contains('xyz') ?
                                  appState.attributeImages['rank']! :
                                  appState.attributeImages['level']!,
                              ),
                            ),
                        ),
                      ),
                      isPortrait ? Container() :
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Center(
                          child: imageByte == null ? Container() :
                            widget.card.frameType == 'link' ?
                            SizedBox(
                              width: screenSize.width,
                              height: screenSize.width,
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
                                width: screenSize.width,
                                height: screenSize.width,
                                child: Image.memory(
                                  appState.images[widget.card.id]!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(200),
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                              color: Colors.amber,
                              width: 5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              widget.card.desc,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: isPortrait ?
                                  screenSize.height * 0.7 * 0.1 :
                                  screenSize.width * 0.7 * 0.1,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Matrix',
                                height: 1,
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
            ],
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