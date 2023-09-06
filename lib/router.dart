import 'package:amazon_clone/app/features/admin/screens/add_product_screen.dart';
import 'package:flutter/material.dart';
import 'app/common/widgets/bottom_bar.dart';
import 'app/features/auth/screens/auth_screen.dart';
import 'app/features/home/screens/home_screen.dart';

Route<dynamic>? generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(builder: (_) => AuthScreen());
    case BottomBar.routeName:
      return MaterialPageRoute(builder: (_) => BottomBar());
    case AddProductScreen.routeName:
      return MaterialPageRoute(builder: (_) => AddProductScreen());
    default:
      MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                  child: Text("Screen not exist's"),
                ),
              ));
  }

  return null;
}
