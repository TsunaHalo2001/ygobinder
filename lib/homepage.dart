part of 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  late List<Widget> _pages;
  late bool isInventoryEmpty;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    var appState = context.read<YGOBinderState>();
    _pages = appState.cardInventory.isEmpty ?
    [
      CardListApp(),
      //Placeholder(),//BarajaApp(),
      AjustesApp(),
    ] :
    [
      CardListApp(),
      //Placeholder(),//BarajaApp(),
      Estadisticasapp(),
      AjustesApp(),
    ];

    isInventoryEmpty = appState.cardInventory.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<YGOBinderState>();
    final Size screenSize = MediaQuery.of(context).size;
    if (appState.cardInventory.isEmpty != isInventoryEmpty) {
      setState(() {
        isInventoryEmpty = appState.cardInventory.isEmpty;
        _pages = isInventoryEmpty ?
        [
          CardListApp(),
          //Placeholder(),//BarajaApp(),
          AjustesApp(),
        ] :
        [
          CardListApp(),
          //Placeholder(),//BarajaApp(),
          Estadisticasapp(),
          AjustesApp(),
        ];
        if (_currentIndex >= _pages.length) {
          _currentIndex = 0;
        }
      });
    }

    return Scaffold(
      backgroundColor: Color(0xFF4D2C6F),
      body: SafeArea(child:
        Row(
          children: [
            Expanded(child: _pages[_currentIndex]),
            ?screenSize.width < screenSize.height ? null :
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: _onItemTapped,
              labelType: NavigationRailLabelType.all,
              backgroundColor: Color(0xFF341340),
              selectedIconTheme: IconThemeData(color: Colors.white),
              unselectedIconTheme: IconThemeData(color: Colors.grey),
              selectedLabelTextStyle: TextStyle(color: Colors.white),
              unselectedLabelTextStyle: TextStyle(color: Colors.grey),

              destinations: isInventoryEmpty ?
              [
                NavigationRailDestination(
                  icon: Icon(Icons.filter_none),
                  label: Text('Cartas'),
                ),
                /*NavigationRailDestination(
                  icon: Icon(Icons.layers),
                  label: Text('Barajas'),
                ),*/
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text('Ajustes'),
                ),
              ] :
              [
                NavigationRailDestination(
                  icon: Icon(Icons.filter_none),
                  label: Text('Cartas'),
                ),
                /*NavigationRailDestination(
                  icon: Icon(Icons.layers),
                  label: Text('Barajas'),
                ),*/
                NavigationRailDestination(
                  icon: Icon(Icons.stacked_bar_chart),
                  label: Text('Estadisticas'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text('Ajustes'),
                ),
              ],
            ),
          ],
        )
      ),
      bottomNavigationBar: screenSize.height < screenSize.width ? null :
      BottomNavigationBar(
        backgroundColor: Color(0xFF341340),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: isInventoryEmpty ?
        [
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF341340),
            icon: Icon(Icons.filter_none),
            label: 'Cartas',
          ),
          /*BottomNavigationBarItem(
            backgroundColor: Color(0xFF341340),
            icon: Icon(Icons.layers),
            label: 'Barajas',
          ),*/
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF341340),
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ] :
        [
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF341340),
            icon: Icon(Icons.filter_none),
            label: 'Cartas',
          ),
          /*BottomNavigationBarItem(
            backgroundColor: Color(0xFF341340),
            icon: Icon(Icons.layers),
            label: 'Barajas',
          ),*/
          ?appState.cardInventory == {} ? null :
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF341340),
            icon: Icon(Icons.stacked_bar_chart),
            label: 'Estadisticas',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xFF341340),
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],

        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}