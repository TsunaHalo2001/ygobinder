part of 'main.dart';

class YGOBinderState extends ChangeNotifier {
  int state = 0;

  static String _lastUpdateKey = 'last_api_update_date';
  String actualDate = '';

  Map<String, dynamic> cards = {};

  bool cacheValid = false;
  bool apiCalled = false;

  final CacheFileHelper cacheFileHelper = CacheFileHelper();

  final ApiService _apiService = ApiService();

  Future<void> loadInitialData() async {
    if (await isCacheValid()) await loadFromCache();
    else await fetchAndCache();

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
    if (data != null) cards = jsonDecode(data);
  }

  Future<void> fetchAndCache() async {
    try {
      cards = await _apiService.fetchData('');

      await cacheFileHelper.writeData(jsonEncode(cards));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
      actualDate = DateTime.now().toIso8601String();

      await loadFromCache();

      notifyListeners();
    }
    catch (error) {
      print(error);
    }
  }
  // Future<void> loadData() async
}