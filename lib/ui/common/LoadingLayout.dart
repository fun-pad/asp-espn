import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';

class LoadingLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingBouncingGrid.square(
        inverted: true,
        borderColor: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }
}
