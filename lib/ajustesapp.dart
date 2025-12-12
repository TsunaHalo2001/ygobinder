part of 'main.dart';

class AjustesApp extends StatelessWidget {
  const AjustesApp({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<YGOBinderState>();
    final Size screenSize = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  IconButton(
                    onPressed: (){
                      appState.exportarInventario();
                    },
                    icon: Icon(
                      Icons.download,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  Text(
                    'Exportar inventario',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: (){
                      appState.importarInventario();
                    },
                    icon: Icon(
                      Icons.upload,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  Text(
                    'Importar inventario',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/png/google.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                appState.abrirURLGitHub();
                },
              child: Text(
                'Creado por Tsuna2001',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
                'Versión 0.1.7+9',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}