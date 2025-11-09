part of 'main.dart';

class YGOBinderState extends ChangeNotifier {
  int state = 0;

  static final String _lastUpdateKey = 'last_api_update_date';
  String actualDate = '';

  Map<String, dynamic> cardsAPI = {};
  Map<int, YGOCard> cards = {};

  Map<String, dynamic> cardInventoryFile = {};
  Map<String, CardInventory> cardInventory = {};

  bool cacheValid = false;
  bool apiCalled = false;

  final FileHelper fileHelper = FileHelper();

  final ApiService _apiService = ApiService();

  void setState(int newState) {
    state = newState;
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

  Future<void> fetchAndCache() async {
    try {
      cardsAPI = await _apiService.fetchData('');

      await fileHelper.writeDataCache(jsonEncode(cardsAPI));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
      actualDate = DateTime.now().toIso8601String();

      await loadFromCache();

      notifyListeners();
    }
    catch (error) {
      print(error);

      await loadFromCache();

      notifyListeners();
    }
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