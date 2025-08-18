
import 'package:cars/pages/newhome_page.dart';
import 'package:cars/pages/post_page.dart';
import 'package:cars/pages/settings_page.dart';
import 'package:cars/vlb/notifiers.dart';
import 'package:flutter/material.dart';

class NavigationWidget extends StatelessWidget {
  const NavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, isSelected, child) {
          return NavigationBar(
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.home,
                  color: isSelected == 0 ? Color(0xFF333333): Colors.grey,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.favorite,
                  color: isSelected == 1 ? Color(0xFF333333) : Colors.grey,
                ),
                label: 'Favorites',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.post_add,
                  color: isSelected == 2 ? Color(0xFF333333) : Colors.grey,
                ),
                label: 'Posts',
              ),
            ],
            selectedIndex: isSelected,
            onDestinationSelected: (value) {
              selectedPageNotifier.value = value;
              isSelected == 0
                  ? NewhomePage()
                  : isSelected == 1
                  ? PostPage()
                  : SettingsPage();
            },
          );
        },
      ),
    );
  }
}
