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

  static Map<String, CardSet> genCardSets(List<dynamic> data) {
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

class Card {
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

  final Map<String, CardSet> cardSets;
  final BanlistInfo? banlistInfo;
  final Map<int, CardImage> cardImages;
  final Map<int, CardPrices> cardPrices;

  Card({
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
    required this.archetype,
    this.scale,
    this.linkVal,
    this.linkMarkers,
    required this.ygoProDeckUrl,
    required this.cardSets,
    this.banlistInfo,
    required this.cardImages,
    required this.cardPrices,
  });

  static Future<Map<int, Card>> genCards(List<dynamic> data) async {
    return Isolate.run(() {
      var cards = <int, Card>{};

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

        final Card card = Card(
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
      print('Todas las cartas');
      return cards;
    });
  }
}