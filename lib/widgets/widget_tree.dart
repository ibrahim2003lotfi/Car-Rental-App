import 'package:cars/models/car_model.dart';
import 'package:cars/pages/favorites_page.dart';
import 'package:cars/pages/newhome_page.dart';
import 'package:cars/pages/post_page.dart';
import 'package:cars/vlb/notifiers.dart';
import 'package:cars/widgets/navigation_widget.dart';
import 'package:flutter/material.dart';

final List<CarModel> favoriteCars = [];

List<Widget> pages = [
  NewhomePage(),
  FavoritesPage(favoriteCars: favoriteCars),
  PostPage(),
];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, isSelected, child) {
          return pages.elementAt(isSelected);
        },
      ),
      bottomNavigationBar: NavigationWidget(),
    );
  }
}
