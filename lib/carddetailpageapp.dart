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
    final isLandscape = screenSize.width > screenSize.height * 1.5;
    final fontTitles = isLandscape ? screenSize.height * 0.08 : screenSize.width * 0.8 * 0.1;
    final fontDesc = isLandscape ?
      screenSize.height > 400 ?
        30.0 :
        screenSize.height * 0.7 * 0.1
        :
      screenSize.width > 400 ?
        30.0 :
        screenSize.width * 0.7 * 0.1;
    final fontBold = fontDesc * 1.5;
    final attribSize = isLandscape ?
      screenSize.height * 0.08 :
      screenSize.width * 0.8 * 0.1;

    final imageIds = widget.card.cardImages.entries.map((e) => e.key).toList();
    final hasAltArt = imageIds.length > 1;
    appState.selectedImage = appState.selectedImage > imageIds.length - 1 ? 0 : appState.selectedImage;
    Uint8List? imageByte = appState.images[imageIds[appState.selectedImage]];
    final cardType = widget.card.type;
    Map<String, bool> isSelectedForInventory = {};

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

    void handleImageTap() {
      setState(() {
        if (hasAltArt) {
          appState.selectedImage += 1;
          if (appState.selectedImage >= imageIds.length) {
            appState.selectedImage = 0;
          }
          imageByte = appState.images[imageIds[appState.selectedImage]];
        }
      });
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: cardGradient
        ),
        child: SafeArea(
          child: Row(
            children: [
              !isLandscape ? Container() :
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
                                          fontSize: fontTitles,
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
                                  width: attribSize,
                                  height: attribSize,
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
                              fontSize: fontBold,
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
                    GestureDetector(
                      onTap: handleImageTap,
                      child: !isLandscape ? Container() :
                      Center(
                        child: imageByte == null ? Container() :
                        widget.card.frameType == 'link' ?
                        SizedBox(
                          width: screenSize.height * 0.75,
                          height: screenSize.height * 0.75,
                          child: Stack(
                            children: [
                              Image.memory(
                                imageByte!,
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
                            width: screenSize.height * 0.67,
                            height: screenSize.height * 0.67,
                            child: Image.memory(
                              imageByte!,
                              fit: BoxFit.cover,
                            ),
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
                      isLandscape ? Container() : Padding(
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
                                        fontSize: fontTitles,
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
                                  width: attribSize,
                                  height: attribSize,
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
                      isLandscape ? Container() :
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
                              fontSize: fontBold,
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
                      GestureDetector(
                        onTap: handleImageTap,
                        child: isLandscape ? Container() :
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
                                    SizedBox(
                                      width: screenSize.width,
                                      height: screenSize.width,
                                      child: Image.memory(
                                      imageByte!,
                                      fit: BoxFit.cover,
                                      ),
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
                                    imageByte!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          ),
                        ),
                      ),
                      widget.card.pendDesc == null ? Container() :
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(200),
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                              color: Color(0xFF109B80),
                              width: 5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              widget.card.pendDesc!,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: fontDesc,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Matrix',
                                height: 1,
                              ),
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
                            child: Column(
                              children: [
                                typeLineWriter(
                                  widget.card.typeLine,
                                  isLandscape ?
                                    screenSize.height * 0.7 * 0.1 :
                                    screenSize.width * 0.7 * 0.1
                                ),
                                Text(
                                  widget.card.pendDesc == null ?
                                  widget.card.desc :
                                  widget.card.monsterDesc!,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: fontDesc,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Matrix',
                                    height: 1,
                                  ),
                                ),
                                widget.card.atk == null ? Container() :
                                const Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                                widget.card.atk == null ? Container() :
                                Row(
                                  children: [
                                    Expanded(
                                      child: atkDefLinkWriter(
                                        widget.card.atk,
                                        widget.card.def,
                                        widget.card.linkVal,
                                          isLandscape ?
                                          screenSize.height * 0.7 * 0.1 :
                                          screenSize.width * 0.7 * 0.1
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: widget.card.archetype == null ? Container() : Text(
                                'Archetype: ${widget.card.archetype!}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontDesc,
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
                            widget.card.banlistInfo == null ? Container() :
                            widget.card.banlistInfo!.banTCG == null ? Container() :
                            widget.card.banlistInfo!.banTCG!.contains('Forbidden') ? Stack(
                              children: [
                                Icon(Icons.block, size: fontTitles, color: Colors.red,),
                                Text(
                                  'TCG',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Matrix',
                                    height: 1.0,
                                    fontSize: fontDesc,
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
                              ],
                            ) :
                            widget.card.banlistInfo!.banTCG!.contains('Limited') ? Stack(
                              children: [
                                Icon(Icons.filter_1, size: fontTitles, color: Colors.red,),
                                Text(
                                  'TCG',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Matrix',
                                    height: 1.0,
                                    fontSize: fontDesc,
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
                              ],
                            ) :
                            widget.card.banlistInfo!.banTCG!.contains('Semi-Limited') ? Stack(
                              children: [
                                Icon(Icons.filter_2, size: fontTitles, color: Colors.red,),
                                Text(
                                  'TCG',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Matrix',
                                    height: 1.0,
                                    fontSize: fontDesc,
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
                              ],
                            )
                                : Container(),
                            widget.card.banlistInfo == null ? Container() :
                            widget.card.banlistInfo!.banOCG == null ? Container() :
                            widget.card.banlistInfo!.banOCG!.contains('Forbidden') ? Stack(
                              children: [
                                Icon(Icons.block, size: fontTitles, color: Colors.red,),
                                Text(
                                  'OCG',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Matrix',
                                    height: 1.0,
                                    fontSize: fontDesc,
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
                              ],
                            ) :
                            widget.card.banlistInfo!.banOCG!.contains('Limited') ? Stack(
                              children: [
                                Icon(Icons.filter_1, size: fontTitles, color: Colors.red,),
                                Text(
                                  'OCG',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Matrix',
                                    height: 1.0,
                                    fontSize: fontDesc,
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
                              ],
                            ) :
                            widget.card.banlistInfo!.banOCG!.contains('Semi-Limited') ? Stack(
                              children: [
                                Icon(Icons.filter_2, size: fontTitles, color: Colors.red,),
                                Text(
                                  'OCG',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Matrix',
                                    height: 1.0,
                                    fontSize: fontDesc,
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
                              ],
                            ) : Container(),
                            widget.card.banlistInfo == null ? Container() :
                            widget.card.banlistInfo!.banGoat == null ? Container() :
                            widget.card.banlistInfo!.banGoat!.contains('Forbidden') ? Stack(
                              children: [
                                Icon(Icons.block, size: fontTitles, color: Colors.red,),
                                Text(
                                  'GOAT',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Matrix',
                                    height: 1.0,
                                    fontSize: fontDesc,
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
                              ],
                            ) :
                            widget.card.banlistInfo!.banGoat!.contains('Limited') ? Stack(
                              children: [
                                Icon(Icons.filter_1, size: fontTitles, color: Colors.red,),
                                Text(
                                  'GOAT',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Matrix',
                                    height: 1.0,
                                    fontSize: fontDesc,
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
                              ],
                            ) :
                            widget.card.banlistInfo!.banGoat!.contains('Semi-Limited') ? Stack(
                              children: [
                                Icon(Icons.filter_2, size: fontTitles, color: Colors.red,),
                                Text(
                                  'GOAT',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Matrix',
                                    height: 1.0,
                                    fontSize: fontDesc,
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
                              ],
                            )
                                : Container()
                          ],
                        ),
                      ),
                      ...(widget.card.cardSets == null ?
                      List.generate(0, (index) => Container())
                        :
                      List.generate(
                        widget.card.cardSets!.length,
                        (index) => cardSetWriter(
                          widget.card.id,
                          widget.card.cardSets!.keys.toList()[index],
                          widget.card.cardSets!.values.toList()[index],
                          fontDesc,
                          cardGradient,
                          isSelectedForInventory,
                          appState,
                        ),
                      )),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: BackButton()
                              ),
                            ),
                          ],
                        ),
                      ),
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
              sizeOf: saiz,
            ),
          ),
        ),
      ),
    );
  }

  Widget typeLineWriter(List<String>? types, double fontSize) {
    if (types == null) {
      return Container();
    }

    var text = '[${types[0]}';
    for (var i = 1; i < types.length; i++) {
      text += '/';
      text += types[i];
    }
    text += ']';

    return Text(
      text.toUpperCase(),
      textAlign: TextAlign.right,
      style: TextStyle(
        color: Colors.black,
        fontSize: fontSize * 1.1,
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
    );
  }

  Widget atkDefLinkWriter(int? atk, int? def, int? linkval, double fontSize) {
    if (atk == null && def == null) {
      return Container();
    }

    var text = atk! > -1 ? 'ATK/$atk' : 'ATK/   ?';

    if (def == null) {
      text += ' LINK-$linkval';
    }
    else {
      text += def > -1 ? ' DEF/$def' : ' DEF/   ?';
    }

    return Text(
      text,
      textAlign: TextAlign.right,
      maxLines: 1,
      style: TextStyle(
        color: Colors.black,
        fontSize: fontSize * 1.1,
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
    );
  }

  Widget cardSetWriter(int id, String set, List<CardSet>? sets, double fontSize, LinearGradient cardGradient, Map<String, bool> isSelectedForInventory, YGOBinderState appState) {
    if (sets == null) {
      return Container();
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(80),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: Colors.black.withAlpha(180),
                width: 5,
              ),
            ),
            child: ExpansionTile(
              collapsedBackgroundColor: appState.cardInventory[sets[0].setCode] == null ? Colors.red : 
              appState.cardInventory[sets[0].setCode]!.values.any((item) => item.have == 0) ? Colors.red : Colors.green,
              title: Text(
                set,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize * 1.1,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Matrix',
                  height: 1,
                ),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        sets[0].setName,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Matrix',
                          height: 1,
                        ),
                      ),
                    ...List.generate(
                      sets.length,
                      (index) => Column(
                        children: [
                          Divider(
                            color: Colors.black.withAlpha(180),
                            thickness: 3,
                          ),
                          ExpansionTile(
                            collapsedBackgroundColor: appState.cardInventory[sets[0].setCode] == null ? Colors.red :
                                                      appState.cardInventory[sets[0].setCode]?[sets[index].setRarity] == null ? Colors.red :
                                                      appState.cardInventory[sets[0].setCode]?[sets[index].setRarity]!.have == 0 ? Colors.red : Colors.green,
                            title: Text(
                              sets[index].setRarity,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: fontSize * 0.8,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Matrix',
                                height: 1,
                              ),
                            ),
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap:(){
                                      setState(() {
                                        if(isSelectedForInventory['have${sets[0].setCode}${sets[index].setRarity}'] == null) {
                                          isSelectedForInventory['have${sets[0].setCode}${sets[index].setRarity}'] = true;
                                          isSelectedForInventory['lent${sets[0].setCode}${sets[index].setRarity}'] = false;
                                          isSelectedForInventory['borrowed${sets[0].setCode}${sets[index].setRarity}'] = false;
                                        }
                                        else {
                                          if(isSelectedForInventory['have${sets[0].setCode}${sets[index].setRarity}'] == false) {
                                            isSelectedForInventory['have${sets[0].setCode}${sets[index].setRarity}'] = true;
                                            isSelectedForInventory['lent${sets[0].setCode}${sets[index].setRarity}'] = false;
                                            isSelectedForInventory['borrowed${sets[0].setCode}${sets[index].setRarity}'] = false;
                                          }
                                          else {
                                            isSelectedForInventory['have${sets[0].setCode}${sets[index].setRarity}'] = false;
                                          }}
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          'Have',
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color:
                                              isSelectedForInventory['have${sets[0].setCode}${sets[index].setRarity}'] == true ?
                                              Colors.black : Colors.white,
                                            fontSize: fontSize * 0.8,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Matrix',
                                            height: 1,
                                          ),
                                        ),
                                        appState.cardInventory[sets[0].setCode] == null ? Container() :
                                        appState.cardInventory[sets[0].setCode]?[sets[index].setRarity] == null ? Container() :
                                        Text(
                                          appState.cardInventory[sets[0].setCode]![sets[index].setRarity]!.have.toString(),
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: isSelectedForInventory['have${sets[0].setCode}${sets[index].setRarity}'] == true ?
                                            Colors.black : Colors.white,
                                            fontSize: fontSize * 0.8,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Matrix',
                                            height: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap:(){
                                      setState(() {
                                        if(isSelectedForInventory['lent${sets[0].setCode}${sets[index].setRarity}'] == null) {
                                          isSelectedForInventory['have${sets[0].setCode}${sets[index].setRarity}'] = false;
                                          isSelectedForInventory['lent${sets[0].setCode}${sets[index].setRarity}'] = true;
                                          isSelectedForInventory['borrowed${sets[0].setCode}${sets[index].setRarity}'] = false;
                                        }
                                        else {
                                          if(isSelectedForInventory['lent${sets[0].setCode}${sets[index].setRarity}'] == false) {
                                            isSelectedForInventory['have${sets[0].setCode}${sets[index].setRarity}'] = false;
                                            isSelectedForInventory['lent${sets[0].setCode}${sets[index].setRarity}'] = true;
                                            isSelectedForInventory['borrowed${sets[0].setCode}${sets[index].setRarity}'] = false;
                                          }
                                          else {
                                            isSelectedForInventory['lent${sets[0].setCode}${sets[index].setRarity}'] = false;
                                          }}
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          'Lent',
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: isSelectedForInventory['lent${sets[0].setCode}${sets[index].setRarity}'] == true ?
                                              Colors.black : Colors.white,
                                            fontSize: fontSize * 0.8,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Matrix',
                                            height: 1,
                                          ),
                                        ),
                                        appState.cardInventory[sets[0].setCode] == null ? Container() :
                                        appState.cardInventory[sets[0].setCode]?[sets[index].setRarity] == null ? Container() :
                                        Text(
                                          appState.cardInventory[sets[0].setCode]![sets[index].setRarity]!.lent.toString(),
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: isSelectedForInventory['lent${sets[0].setCode}${sets[index].setRarity}'] == true ?
                                            Colors.black : Colors.white,
                                            fontSize: fontSize * 0.8,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Matrix',
                                            height: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap:(){
                                      setState(() {
                                        if(isSelectedForInventory['borrowed${sets[0].setCode}${sets[index].setRarity}'] == null) {
                                          isSelectedForInventory['have${sets[0].setCode}${sets[index].setRarity}'] = false;
                                          isSelectedForInventory['lent${sets[0].setCode}${sets[index].setRarity}'] = false;
                                          isSelectedForInventory['borrowed${sets[0].setCode}${sets[index].setRarity}'] = true;
                                        }
                                        else {
                                          if(isSelectedForInventory['borrowed${sets[0].setCode}${sets[index].setRarity}'] == false) {
                                            isSelectedForInventory['have${sets[0].setCode}${sets[index].setRarity}'] = false;
                                            isSelectedForInventory['lent${sets[0].setCode}${sets[index].setRarity}'] = false;
                                            isSelectedForInventory['borrowed${sets[0].setCode}${sets[index].setRarity}'] = true;
                                          }
                                          else {
                                            isSelectedForInventory['borrowed${sets[0].setCode}${sets[index].setRarity}'] = false;
                                          }}
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          'Borrowed',
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: isSelectedForInventory['borrowed${sets[0].setCode}${sets[index].setRarity}'] == true ?
                                              Colors.black : Colors.white,
                                            fontSize: fontSize * 0.8,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Matrix',
                                            height: 1,
                                          ),
                                        ),
                                        appState.cardInventory[sets[0].setCode] == null ? Container() :
                                        appState.cardInventory[sets[0].setCode]?[sets[index].setRarity] == null ? Container() :
                                        Text(
                                          appState.cardInventory[sets[0].setCode]![sets[index].setRarity]!.borrowed.toString(),
                                          textAlign: TextAlign.right,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: isSelectedForInventory['borrowed${sets[0].setCode}${sets[index].setRarity}'] == true ?
                                            Colors.black : Colors.white,
                                            fontSize: fontSize * 0.8,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Matrix',
                                            height: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: GestureDetector(
                                          onTap:(){
                                            setState(() {
                                              if (isSelectedForInventory['have${sets[0].setCode}${sets[index].setRarity}'] == true) {
                                                appState.saveCard(sets[0].setCode, id, sets[index].setRarity, sets[0], 0);
                                              }
                                              if (isSelectedForInventory['lent${sets[0].setCode}${sets[index].setRarity}'] == true) {
                                                appState.saveCard(sets[0].setCode, id, sets[index].setRarity, sets[0], 1);
                                              }
                                              if (isSelectedForInventory['borrowed${sets[0].setCode}${sets[index].setRarity}'] == true) {
                                                appState.saveCard(sets[0].setCode, id, sets[index].setRarity, sets[0], 2);
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: fontSize * 1.3,
                                            height: fontSize * 1.3,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(9),
                                            ),
                                            child: Icon(
                                              Icons.plus_one,
                                              color: Colors.white,
                                              size: fontSize * 0.7,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: GestureDetector(
                                          onTap:(){
                                            setState(() {
                                              if (isSelectedForInventory['have${sets[0].setCode}${sets[index].setRarity}'] == true) {
                                                appState.deleteCard(sets[0].setCode, id, sets[index].setRarity, sets[0], 0);
                                              }
                                              if (isSelectedForInventory['lent${sets[0].setCode}${sets[index].setRarity}'] == true) {
                                                appState.deleteCard(sets[0].setCode, id, sets[index].setRarity, sets[0], 1);
                                              }
                                              if (isSelectedForInventory['borrowed${sets[0].setCode}${sets[index].setRarity}'] == true) {
                                                appState.deleteCard(sets[0].setCode, id, sets[index].setRarity, sets[0], 2);
                                              }
                                            });
                                          },
                                          child: Container(
                                            width: fontSize * 1.3,
                                            height: fontSize * 1.3,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.circular(9),
                                            ),
                                            child: Icon(
                                              Icons.exposure_minus_1,
                                              color: Colors.white,
                                              size: fontSize * 0.7,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

class LinkArrowPainter extends CustomPainter {
  final bool isSolid;
  final double sizeOf;

  LinkArrowPainter({
    this.isSolid = false,
    required this.sizeOf,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(sizeOf * 0.95, sizeOf * 0.95);
    path.lineTo(sizeOf * 0.05, sizeOf * 0.95);
    path.lineTo(sizeOf * 0.05, sizeOf * 0.05);
    path.close();

    final strokePaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = sizeOf * 0.1;

    final fillPaint = Paint()
      ..color = isSolid ? Colors.redAccent : Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}