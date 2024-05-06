import 'package:flutter/material.dart';
import 'package:flutter_ex/Pokemon_List/view_models/pokemon_view_model.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PokemonViewModel())
        ],
        child: MaterialApp(
          title: 'MVVM',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
            useMaterial3: true,
          ),
          home: HomeScreen(),
        )
    );

  }
}
