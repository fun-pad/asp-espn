import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart' as LoadingIndicator;

class LoadingLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingIndicator.Loading(
        indicator: BallSpinFadeLoaderIndicator(),
        color: Theme.of(context).accentColor,
      ),
    );
  }
}
