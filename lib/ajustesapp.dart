part of 'main.dart';

class AjustesApp extends StatelessWidget {
  const AjustesApp({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<YGOBinderState>();

    return TextButton(
      onPressed: (){
        appState.exportarInventario();
      },
      child: Text(
        'Exportar inventario',
    ));
  }
}