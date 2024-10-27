import 'package:car/presentation/bloc/auth/auth_bloc.dart';
import 'package:car/presentation/bloc/auth/auth_state.dart';
import 'package:car/presentation/bloc/car/car_bloc.dart';
import 'package:car/presentation/ui/cars_page.dart';
import 'package:car/presentation/ui/login_page.dart';
import 'package:car/theme/theme.dart';
import 'package:car/theme/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection/dependency_injection.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Retrieves the default theme for the platform
    //TextTheme textTheme = Theme.of(context).textTheme;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DependencyInjection.locator<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => DependencyInjection.locator<CarBloc>(),
        ),
      ],

      child: MaterialApp(
        title: 'Car Management',
        darkTheme: theme.dark(),
        theme:  theme.light(),
        home: BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthAuthenticated) {
          return CarsPage();
        }

        return LoginPage();
      },
        ),
      ),
    );
  }
}


