import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/pacman_indicator.dart';
import 'package:loading/loading.dart' as LoadingIndicator;

class LoadingLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingIndicator.Loading(
        indicator: PacmanIndicator(),
        color: Theme.of(context).accentColor,
      ),
    );
  }
}
