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
      case 1:
        page = HomePage();
        break;
      default:
        throw UnimplementedError('No widget for $appState.state');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            transitionBuilder: (
                Widget child,
                Animation<double> animation,
                ){
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },

            child: page
          ),
        );
      }
    );
  }
}