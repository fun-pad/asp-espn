import 'package:espn/resources/Themes.dart';
import 'package:espn/ui/home/HomeBloc.dart';
import 'package:espn/ui/home/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASP FF',
      theme: ThemeConfig.obtain(),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeConfig.obtain(),
      home: BlocProvider<HomeBloc>(
        create: (context) {
          return HomeBloc();
        },
        child: HomePage(),
      ),
    );
  }
}
