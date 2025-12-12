part of 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    CardListApp(),
    //Placeholder(),//BarajaApp(),
    Estadisticasapp(),//EstadisticasApp(),
    AjustesApp(),
    ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

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

              destinations: [
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
        items: [
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