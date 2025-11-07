part of 'main.dart';

class LoadingApp extends StatelessWidget {
  const LoadingApp({super.key});

  Future<void> loadData(BuildContext context) async {
    //await context.read<YGOBinderState>();loadData();;

    // Simulate a loading delay
    await Future.delayed(const Duration(seconds: 2));

    return;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return FutureBuilder(
        future: loadData(context),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Color(0xFF4D2C6F),
            body: Column(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: screenSize.height * 0.2),
                    child: Image.asset(
                      'assets/images/png/logo.png',
                      width: screenSize.height * 0.4,
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
                    'Obteniendo datos de la API...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenSize.width > screenSize.height ?
                        screenSize.height * 0.025 :
                        screenSize.width * 0.05,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}