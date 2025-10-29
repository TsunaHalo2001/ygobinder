part of 'main.dart';

class YGOBinder extends StatelessWidget {
  const YGOBinder({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => YGOBinderState(),
      child: MaterialApp(
        title: 'materialAppYGOBinder',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: MyApp(),
      ),
    );
  }
}