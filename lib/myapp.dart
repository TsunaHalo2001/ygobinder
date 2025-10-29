part of 'main.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget page;
    var appState = context.watch<YGOBinderState>();

    switch(appState.state) {
      case 0:
        page = LoadingApp();
        break;
      default:
        throw UnimplementedError('No widget for $appState.state');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: page,
        );
      }
    );
  }
}