part of 'main.dart';

class LoadingApp extends StatefulWidget {
  const LoadingApp({super.key});

  @override
  LoadingAppState createState() => LoadingAppState();
}

class LoadingAppState extends State<LoadingApp> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _startAppProcess();
  }

  Future<void> _startAppProcess() async {
    final appState = context.read<YGOBinderState>();
    await appState.loadInitialData();
    //await appState.initializeGoogleSignIn();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    var appState = context.watch<YGOBinderState>();

    return FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                appState.setState(1);
              }
            });
          }

          return Scaffold(
            backgroundColor: Color(0xFF4D2C6F),
            body: SafeArea(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: screenSize.height * 0.2),
                      child: Image.asset(
                        'assets/images/png/logo.png',
                        width: screenSize.width > screenSize.height ?
                          screenSize.height * 0.4 :
                          screenSize.width * 0.6,
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      height: screenSize.height * 0.1,
                    ),
                  ),
                  Center(child:
                    // snapshot.connectionState == ConnectionState.done ?
                      CircularProgressIndicator()
                  ),
                  Center(
                    child: Text(
                      "Iniciando",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Matrix',
                        fontSize: screenSize.width > screenSize.height ?
                          screenSize.height * 0.025 :
                          screenSize.width * 0.05,
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
                  )
                ],
              ),
            ),
          );
        });
  }
}