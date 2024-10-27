
import 'package:cars/theme/theme.dart';
import 'package:cars/theme/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/core/observer.dart';
import 'app/env.dart';
import 'app/presentation/styles/theme_bloc/theme_bloc.dart';
import 'app/router/app_route_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeBloc()..add(ThemeInitialEvent())),
      ],

      child: Builder(builder: (context) {
        final isDarkTheme = context.watch<ThemeBloc>().state.isDarkTheme;
        return MaterialApp(
          title: Environments.appName,
          initialRoute: AppRouter.initialRoute,
          onGenerateRoute: AppRouter.onGenerateRouted,
          debugShowCheckedModeBanner: false,
          darkTheme: theme.dark(),
          theme:  theme.light(),
        );
      },)
    );
  }
}


