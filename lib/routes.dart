import 'package:flutter/material.dart';
import 'package:products_scanner/home.dart';
import 'package:products_scanner/product.dart';

class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;
  SlideRightRoute({this.widget})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return new SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}

class Routes {
  static builder() {
    return (RouteSettings settings) {
      var arguments = settings.arguments;
      switch (settings.name) {
        case '/':
          return MaterialPageRoute(builder: (_) => HomePage());
          break;
        case '/product':
          print(arguments);
          return SlideRightRoute(widget: ProductPage(product: arguments));
          break;
      }
    };
  }
}
