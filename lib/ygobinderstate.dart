part of 'main.dart';

class YGOBinderState extends ChangeNotifier {
  int state = 0;

  static final String _lastUpdateKey = 'last_api_update_date';
  String actualDate = '';

  Map<String, dynamic> cardsAPI = {};
  Map<int, Card> cards = {};

  bool cacheValid = false;
  bool apiCalled = false;

  final CacheFileHelper cacheFileHelper = CacheFileHelper();

  final ApiService _apiService = ApiService();

  void setState(int newState) {
    state = newState;
    notifyListeners();
  }

  Future<void> loadInitialData() async {
    if (await isCacheValid()) {
      print('fetched from cache');
      await loadFromCache();
    } else {
      print('fetched from api');
      await fetchAndCache();
    }

    notifyListeners();
  }

  Future<bool> isCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getString(_lastUpdateKey);

    if (lastUpdate == null || await cacheFileHelper.readData() == null) return false;

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
    final data = await cacheFileHelper.readData();
    if (data != null) {
      cardsAPI = jsonDecode(data);

      cards = await Card.genCards(cardsAPI['data']);

      notifyListeners();
    }
  }

  Future<void> fetchAndCache() async {
    try {
      cardsAPI = await _apiService.fetchData('');

      await cacheFileHelper.writeData(jsonEncode(cardsAPI));

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
}