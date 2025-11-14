part of 'main.dart';

class YGOBinderState extends ChangeNotifier {
  int state = 0;
  int selectedIndexCardList = 0;
  int selectedImage = 0;

  static final String _lastUpdateKey = 'last_api_update_date';
  String actualDate = '';

  Map<String, dynamic> cardsAPI = {};
  Map<int, YGOCard> cards = {};

  Map<String, dynamic> cardInventoryFile = {};
  Map<String, CardInventory> cardInventory = {};

  Map<int,Uint8List?> images = {};
  Map<String, Image> attributeImages = {
    'DARK' :Image.asset(
      'assets/images/attributes/dark.webp',
      fit: BoxFit.cover,
    ),
    'EARTH' :Image.asset(
      'assets/images/attributes/earth.png',
      fit: BoxFit.cover,
    ),
    'FIRE' :Image.asset(
      'assets/images/attributes/fire.webp',
      fit: BoxFit.cover,
    ),
    'LIGHT' :Image.asset(
      'assets/images/attributes/light.png',
      fit: BoxFit.cover,
    ),
    'WATER' :Image.asset(
      'assets/images/attributes/water.png',
      fit: BoxFit.cover,
    ),
    'WIND' :Image.asset(
      'assets/images/attributes/wind.webp',
      fit: BoxFit.cover,
    ),
    'DIVINE' :Image.asset(
      'assets/images/attributes/divine.webp',
      fit: BoxFit.cover,
    ),
    'spell' :Image.asset(
      'assets/images/attributes/spell.webp',
      fit: BoxFit.cover,
    ),
    'trap' :Image.asset(
      'assets/images/attributes/trap.png',
      fit: BoxFit.cover,
    ),
    'level' :Image.asset(
      'assets/images/attributes/level.png',
      fit: BoxFit.cover,
    ),
    'rank' :Image.asset(
      'assets/images/attributes/rank.png',
      fit: BoxFit.cover,
    ),
    'Continuous' :Image.asset(
      'assets/images/attributes/continuous.png',
      fit: BoxFit.cover,
    ),
    'Equip' :Image.asset(
      'assets/images/attributes/equip.webp',
      fit: BoxFit.cover,
    ),
    'Field' :Image.asset(
      'assets/images/attributes/field.png',
      fit: BoxFit.cover,
    ),
    'Quick-Play' :Image.asset(
      'assets/images/attributes/quickplay.webp',
      fit: BoxFit.cover,
    ),
    'Ritual' :Image.asset(
      'assets/images/attributes/ritual.webp',
      fit: BoxFit.cover,
    ),
    'Counter' :Image.asset(
      'assets/images/attributes/counter.webp',
      fit: BoxFit.cover,
    ),
  };

  bool cacheValid = false;
  bool apiCalled = false;

  final FileHelper fileHelper = FileHelper();

  final ApiService _apiService = ApiService();

  void setState(int newState) {
    state = newState;
    notifyListeners();
  }

  void setSelectedIndexCardList(int newIndex) {
    selectedIndexCardList = newIndex;
    notifyListeners();
  }

  Future<void> loadInitialData() async {
    if (await isCacheValid() || !(await _checkInternetConnection())) {
      print('fetched from cache');
      await loadFromCache();
    } else {
      print('fetched from api');
      await fetchAndCache();
    }
    await loadCardInventory();

    notifyListeners();
  }

  Future<bool> isCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getString(_lastUpdateKey);

    if (lastUpdate == null || await fileHelper.readDataCache() == null) return false;

    final lastUpdateDateTime = DateTime.parse(lastUpdate);
    final now = DateTime.now();

    if (lastUpdateDateTime.year == now.year &&
        lastUpdateDateTime.month == now.month &&
        lastUpdateDateTime.day == now.day) {
      apiCalled = false;
      return true;
    }
    else {
      apiCalled = true;
      return false;
    }
  }

  Future<void> loadFromCache() async {
    final data = await fileHelper.readDataCache();
    if (data != null) {
      cardsAPI = jsonDecode(data);

      cards = await YGOCard.genCards(cardsAPI['data']);

      notifyListeners();
    }
  }

  Future<void> loadCardInventory() async {
    final data = await fileHelper.readDataInventory();
    if (data != null) {
      cardInventoryFile = jsonDecode(data);

      cardInventory = await CardInventory.genCardInventory(cardInventoryFile);

      notifyListeners();
    }
  }

  Future<void> loadImg(int card) async {
    if (images[card] == null) {
      images[card] = await fileHelper.readImage(card);
    }
  }

  Future<void> updateSelectedChunk(List<YGOCard> chunkedCard) async {
    images.clear();
    for (YGOCard card in chunkedCard) {
      for (var image in card.cardImages.values) {
        await loadImg(image.id);
      }
    }

    notifyListeners();
  }

  Future<void> fetchAndCache() async {
    try {
      cardsAPI = await _apiService.fetchData('');

      await fileHelper.writeDataCache(jsonEncode(cardsAPI));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
      actualDate = DateTime.now().toIso8601String();
    }
    catch (error) {
      print(error);
    }
    await loadFromCache();
    notifyListeners();
  }

  Future<void> saveInventory() async {
    cardInventoryFile = await CardInventory.genCardInventory(cardInventory);

    await fileHelper.writeDataInventory(jsonEncode(cardInventoryFile));

    notifyListeners();
  }

  Future<bool> _checkInternetConnection() async {
    final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }

    return true;
  }
}