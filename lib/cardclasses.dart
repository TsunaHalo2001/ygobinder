part of 'main.dart';

class CardPrices {
  final double? cardmarketPrice;
  final double? tcgplayerPrice;
  final double? ebayPrice;
  final double? amazonPrice;
  final double? coolstuffincPrice;

  CardPrices({
    this.cardmarketPrice,
    this.tcgplayerPrice,
    this.ebayPrice,
    this.amazonPrice,
    this.coolstuffincPrice,
  });

  static Map<int, CardPrices> genCardPrices(List<dynamic> data) {
    var cardPrices = <int, CardPrices>{};
    int mapKey = 0;

    for (var item in data) {
      final CardPrices cardPrice = CardPrices(
        cardmarketPrice: double.tryParse(item['cardmarket_price']),
        tcgplayerPrice: double.tryParse(item['tcgplayer_price']),
        ebayPrice: double.tryParse(item['ebay_price']),
        amazonPrice: double.tryParse(item['amazon_price']),
        coolstuffincPrice: double.tryParse(item['coolstuffinc_price']),
      );

      cardPrices[mapKey] = cardPrice;
      mapKey++;
    }

    return cardPrices;
  }
}

class CardImage {
  final int id;
  final String imageUrl;
  final String imageUrlSmall;
  final String imageUrlCropped;

  CardImage ({
    required this.id,
    required this.imageUrl,
    required this.imageUrlSmall,
    required this.imageUrlCropped,
  });

  static Map<int, CardImage> genCardImages(List<dynamic> data) {
    var cardImages = <int, CardImage>{};

    for (var item in data) {
      final CardImage cardImage = CardImage(
        id: item['id'],
        imageUrl: item['image_url'],
        imageUrlSmall: item['image_url_small'],
        imageUrlCropped: item['image_url_cropped'],
      );

      cardImages[item['id']] = cardImage;
    }

    return cardImages;
  }
}

class CardSet {
  final String setName;
  final String setCode;
  final String setRarity;
  final String setRarityCode;
  final double? setPrice;

  CardSet({
    required this.setName,
    required this.setCode,
    required this.setRarity,
    required this.setRarityCode,
    this.setPrice,
  });

  static Map<String, CardSet>? genCardSets(List<dynamic>? data) {
    if (data == null) {
      return null;
    }

    var cardSets = <String, CardSet>{};

    for (var item in data) {
      final CardSet cardSet = CardSet(
        setName: item['set_name'],
        setCode: item['set_code'],
        setRarity: item['set_rarity'],
        setRarityCode: item['set_rarity_code'],
        setPrice: double.tryParse(item['set_price']),
      );

      cardSets[item['set_code']] = cardSet;
    }

    return cardSets;
  }
}

class BanlistInfo {
  final String? banTCG;
  final String? banOCG;
  final String? banGoat;

  BanlistInfo({
    this.banTCG,
    this.banOCG,
    this.banGoat,
  });
}

class TypeLine {
  static List<String>? genTypeLines(List<dynamic>? data) {
    if (data == null) {
      return null;
    }

    var typeLines = <String>[];

    for (var item in data) {
      typeLines.add(item);
    }

    return typeLines;
  }
}

class LinkMarker {
  static List<String>? genLinkMarkers(List<dynamic>? data) {
    if (data == null) {
      return null;
    }

    var linkMarkers = <String>[];

    for (var item in data) {
      linkMarkers.add(item);
    }

    return linkMarkers;
  }
}

class YGOCard {
  final int id;
  final String name;
  final List<String>? typeLine;
  final String type;
  final String? humanReadableCardType;
  final String? frameType;//
  final String desc;
  final String race;
  final String? pendDesc;
  final String? monsterDesc;
  final int? atk;
  final int? def;
  final int? level;
  final String? attribute;
  final String? archetype;
  final int? scale;
  final int? linkVal;
  final List<String>? linkMarkers;
  final String ygoProDeckUrl;

  final Map<String, CardSet>? cardSets;
  final BanlistInfo? banlistInfo;
  final Map<int, CardImage> cardImages;
  final Map<int, CardPrices> cardPrices;

  YGOCard({
    required this.id,
    required this.name,
    this.typeLine,
    required this.type,
    required this.humanReadableCardType,
    required this.frameType,
    required this.desc,
    required this.race,
    this.pendDesc,
    this.monsterDesc,
    this.atk,
    this.def,
    this.level,
    this.attribute,
    this.archetype,
    this.scale,
    this.linkVal,
    this.linkMarkers,
    required this.ygoProDeckUrl,
    this.cardSets,
    this.banlistInfo,
    required this.cardImages,
    required this.cardPrices,
  });

  static Future<Map<int, YGOCard>> genCards(List<dynamic> data) async {
    return Isolate.run(() {
      var cards = <int, YGOCard>{};

      for (var item in data) {
        final tempTypeLine = TypeLine.genTypeLines(item['typeline']);
        final tempLinkMarker = LinkMarker.genLinkMarkers(item['linkmarkers']);
        final tempCardSets = CardSet.genCardSets(item['card_sets']);
        final tempBanlistInfo = item['banlist_info'] == null ?
        null :
        BanlistInfo(
          banTCG: item['banlist_info']['ban_tcg'],
          banOCG: item['banlist_info']['ban_ocg'],
          banGoat: item['banlist_info']['ban_goat'],
        );
        final tempCardImages = CardImage.genCardImages(item['card_images']);
        final tempCardPrices = CardPrices.genCardPrices(item['card_prices']);

        final YGOCard card = YGOCard(
          id: item['id'],
          name: item['name'],
          typeLine: tempTypeLine,
          type: item['type'],
          humanReadableCardType: item['humanReadableCardType'],
          frameType: item['frameType'],
          desc: item['desc'],
          race: item['race'],
          pendDesc: item['pend_desc'],
          monsterDesc: item['monster_desc'],
          atk: item['atk'],
          def: item['def'],
          level: item['level'],
          attribute: item['attribute'],
          archetype: item['archetype'],
          scale: item['scale'],
          linkVal: item['linkval'],
          linkMarkers: tempLinkMarker,
          ygoProDeckUrl: item['ygoprodeck_url'],
          cardSets: tempCardSets,
          banlistInfo: tempBanlistInfo,
          cardImages: tempCardImages,
          cardPrices: tempCardPrices,
        );

        cards[item['id']] = card;
      }
      return cards;
    });
  }

  static List<List<YGOCard>> chunkList (Map<int, YGOCard> cardMap, int chunkSize) {
    final allCards = cardMap.values.toList();
    final chunks = <List<YGOCard>>[];

    int i = 0;

    while (i < allCards.length) {
      // 5. Calcular el índice final del chunk (asegurándose de no exceder el tamaño total de la lista)
      final end = (i + chunkSize < allCards.length) ? i + chunkSize : allCards.length;

      // 6. Extraer la sublista usando .sublist(inicio, fin)
      final chunk = allCards.sublist(i, end);

      // 7. Añadir el chunk a la lista principal
      chunks.add(chunk);

      // 8. Mover el índice al inicio del siguiente chunk
      i += chunkSize;
    }

    return chunks;
  }
}

class CardSetInventory {
  final CardSet cardSet;
  int possesed;
  int notMine;
  int iBorrowed;

  CardSetInventory({
    required this.cardSet,
    required this.possesed,
    required this.notMine,
    required this.iBorrowed,
  });

  void setPossesed(int possesed) {
    this.possesed = possesed;
  }

  void setNotMine(int notMine) {
    this.notMine = notMine;
  }

  void setIBorrowed(int iBorrowed) {
    this.iBorrowed = iBorrowed;
  }

  static Map<String, CardSetInventory> genCardSetInventory(Map<String, dynamic> data) {
    var cardSetInventories = <String, CardSetInventory>{};

    for (var item in data.values) {
      final CardSetInventory cardSetInventory = CardSetInventory(
        cardSet: CardSet(
          setName: item['set_name'],
          setCode: item['set_code'],
          setRarity: item['set_rarity'],
          setRarityCode: item['set_rarity_code'],
          setPrice: double.tryParse(item['set_price']),
        ),
        possesed: item['possesed'],
        notMine: item['not_mine'],
        iBorrowed: item['i_borrowed'],
      );

      cardSetInventories[item['set_code']] = cardSetInventory;
    }

    return cardSetInventories;
  }
}

class CardInventory {
  final int id;
  Map<String, CardSetInventory>? cardSets;

  CardInventory({
    required this.id,
    this.cardSets,
  });

  void setCardSets(Map<String, CardSetInventory> cardSets) {
    this.cardSets = cardSets;
  }

  void addCardSet(String key, CardSetInventory cardSet) {
    cardSets ??= <String, CardSetInventory>{};

    cardSets![key] = cardSet;
  }

  static Map<String,Map<String, dynamic>>? cardSetToJSONSet(Map<String, CardSetInventory>? infoMap) {
    if (infoMap == null) {
      return null;
    }

    var json = <String, Map<String, dynamic>>{};

    for (var info in infoMap.values) {
      json['set_name']?['set_name'] = info.cardSet.setName;
      json['set_name']?['set_code'] = info.cardSet.setCode;
      json['set_name']?['set_rarity'] = info.cardSet.setRarity;
      json['set_name']?['set_rarity_code'] = info.cardSet.setRarityCode;
      json['set_name']?['set_price'] = info.cardSet.setPrice.toString();
      json['set_name']?['possesed'] = info.possesed;
      json['set_name']?['not_mine'] = info.notMine;
      json['set_name']?['i_borrowed'] = info.iBorrowed;
    }

    return json;
  }

  static Future<Map<String, CardInventory>> genCardInventory(Map<String, dynamic> data) async {
    return Isolate.run(() {
      var cardInventories = <String, CardInventory>{};

      for (var item in data.values) {
        final tempCardSets = CardSetInventory.genCardSetInventory(item['card_sets']);

        final CardInventory cardInventory = CardInventory(
          id: item['id'],
          cardSets: tempCardSets,
        );
        cardInventories[item['id']] = cardInventory;
      }
      return cardInventories;
    });
  }

  static Map<String, dynamic> saveCardInventory(Map<String, CardInventory> cardInventory) {
    var cardInventoryData = <String, dynamic>{};

    for (var item in cardInventory.values) {
      cardInventoryData[item.id.toString()] = {
        'id': cardInventory[item.id.toString()]?.id,
        'card_sets': cardSetToJSONSet(cardInventory[item.id.toString()]?.cardSets),
      };
    }

    return cardInventoryData;
  }
}

class CardColor {
  static const Map<String, Color> _typeColorMap = {
    // Monstruos Estándar (Normal, Effect)
    'normal': Color(0xFFEBC76D), // Amarillo/Dorado claro (Normal)
    'effect': Color(0xFFFF9900), // Naranja (Efecto)

    // Monstruos de Invocación Extra (Extra Deck)
    'fusion': Color(0xFF9900FF), // Púrpura (Fusión)
    'synchro': Color(0xFFCCCCCC), // Blanco/Gris claro (Sincronía)
    'xyz': Color(0xFF333333), // Negro oscuro (Xyz)
    'link': Color(0xFF000080), // Azul Oscuro (Link)

    // Monstruos de Péndulo (se combinan con otros tipos, ej: 'pendulum_effect')
    'pendulum': Color(0xFF00AA8D), // Verde azulado/Turquesa (Base Péndulo)

    // Magia y Trampas
    'spell': Color(0xFF109B80), // Verde brillante (Mágica/Spell)
    'trap': Color(0xFFB01762), // Rojo Ladrillo (Trampa/Trap)

    // Fichas (Token) y otros
    'token': Color(0xFF999999), // Gris (Token)
    'skill': Color(0xFF007A8A), // Cian (Skill)

    // Valor por defecto si no se encuentra el tipo
    'default': Colors.blueGrey,
  };

  static const List<String> _combinedTypes = [
    'pendulum', 'effect', 'fusion', 'synchro', 'xyz', 'link'
  ];
/*
  static Color getColor(String? frameTypeNullable) {
    if (frameTypeNullable == null) {
      return _colorMap['default']!;
    }
    final frameType = frameTypeNullable;

    // 1. Convertir el tipo a minúsculas y reemplazar espacios o guiones
    final cleanFrameType = frameType.toLowerCase().replaceAll(RegExp(r'[ _-]'), '');

    // 2. Manejo de tipos compuestos (ej: 'xyz_pendulum_effect')
    // Buscamos el tipo principal si es compuesto.
    final key = _colorMap.keys.firstWhere(
          (k) => cleanFrameType.contains(k),
      orElse: () => 'default',
    );

    // 3. Devolver el color mapeado
    return _colorMap[key]!;
  }*/

  static LinearGradient getCardGradient(String? frameTypeNullable) {
    if (frameTypeNullable == null) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [_typeColorMap['default']!, _typeColorMap['default']!],
      );
    }

    final frameType = frameTypeNullable;

    final cleanFrameType = frameType.toLowerCase().replaceAll(RegExp(r'[ _-]'), '');
    List<Color> gradientColors = [];

    // 1. Detección y Construcción del Degradado

    // Buscar los tipos que coinciden en la lista de tipos combinables
    for (var type in _combinedTypes) {
      if (cleanFrameType.contains(type)) {
        // Añadir el color al degradado si el tipo está presente
        final color = _typeColorMap[type] ?? _typeColorMap['default']!;
        gradientColors.add(color);
      }
    }

    // 2. Manejo de Casos:

    // Caso A: No se encontró ningún tipo combinable o es un tipo simple ('normal', 'trap', etc.)
    if (gradientColors.isEmpty || gradientColors.length == 1) {
      // Si está vacío, usa el color por defecto o el color simple
      final baseColor = _typeColorMap[cleanFrameType] ?? _typeColorMap['default']!;
      gradientColors = [baseColor, baseColor]; // Crea un "degradado" de un solo color

    } else if (cleanFrameType.contains('pendulum') && !cleanFrameType.contains('link')) {
      // Caso B: Manejo especial para Péndulo.
      // Las cartas Péndulo se dividen a la mitad (ej: Péndulo/Efecto, Synchro/Péndulo).
      // Usamos solo los dos primeros colores encontrados (el principal y el Péndulo).

      // Ordenamos para asegurar que el Péndulo quede en el último lugar (parte inferior)
      if (gradientColors.length > 1 && gradientColors.contains(_typeColorMap['pendulum']!)) {

        final pendulumColor = _typeColorMap['pendulum']!;
        final otherColor = gradientColors.firstWhere((c) => c != pendulumColor);

        return LinearGradient(
          // Diagonal de 45 grados para simular la división del marco
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [otherColor, pendulumColor],
            stops: const [0.5, 0.5] // Transición nítida en el medio
        );
      }
    }

    // Caso C: Tipos no-Péndulo combinados (Link/Efecto, etc.) o casos restantes
    // Crea un degradado simple (de izquierda a derecha o de arriba abajo)
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      // Usamos los dos primeros colores que encontramos (o los dos que pusimos si era un color plano)
      colors: gradientColors.take(2).toList(),
    );
  }
}