import 'package:cars/app/core/models/car_model.dart';
import 'package:flutter/material.dart';

import '../core/models/post_model.dart';
import '../presentation/pages/error/error_view.dart';
import '../presentation/pages/home/home_view.dart';
import '../presentation/pages/login/login_view.dart';
import '../presentation/pages/new_post/new_post_view.dart';
import '../presentation/pages/register/register_view.dart';
import '../presentation/pages/splash/splash_view.dart';


class AppRouter {
  static const String initialRoute = '/splash';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String addNewPostRoute = '/add_new_post';
  static const String errorRoute = '/error';

  static Route<dynamic> onGenerateRouted(RouteSettings routeSettings) {
    // debugPrint(routeSettings.arguments.toString());
    switch (routeSettings.name) {
      case initialRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const SplashScreen();
          },
        );

      case loginRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const LoginScreen();
          },
        );

      case registerRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const RegisterScreen();
          },
        );

      case homeRoute:
        return MaterialPageRoute(
          builder: (context) {
            return const HomeScreen();
          },
        );

      case addNewPostRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        debugPrint(args[0].toString());
        return MaterialPageRoute(
          builder: (context) {
            return NewPostScreen(
              action: args[0].toString(),
              carModel: CarModel(),
            );
          },
        );

      case errorRoute:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;
        debugPrint(args[0].toString());
        debugPrint(args[1].toString());
        return MaterialPageRoute(
          builder: (context) {
            return ErrorScreen(
              errorType: args[0].toString(),
              errorMessage: args[1].toString(),
            );
          },
        );

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child:
                          Text('No route defined for ${routeSettings.name}')),
                ));
    }
  }
}
