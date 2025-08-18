import 'package:cars/pages/app_loading_page.dart';

import 'package:cars/pages/landing_page.dart';

import 'package:cars/widgets/widget_tree.dart';
import 'package:flutter/material.dart';
import 'package:cars/auth/auth_sevice.dart';

class AuthState extends StatelessWidget {
  const AuthState({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, AuthSevices, child) {
        return StreamBuilder(
          stream: AuthSevices.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            if (snapshot.connectionState == ConnectionState.waiting) {
              widget = AppLoadingPage();
            } else if (snapshot.hasData) {
              widget = WidgetTree();
            } else {
              widget = LandingPage();
            }
            return widget;
          },
        );
      },
    );
  }
}
