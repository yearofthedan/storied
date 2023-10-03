import 'package:bibi/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return ListView(
        children: appState.favorites
            .map((fav) => ListTile(title: Text(fav.asLowerCase)))
            .toList());
  }
}