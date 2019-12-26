import 'package:espn/resources/HomeStrings.dart';
import 'package:espn/ui/home/HomeBloc.dart';
import 'package:espn/ui/standings/StandingsBloc.dart';
import 'package:espn/ui/standings/StandingsEvent.dart';
import 'package:espn/ui/standings/StandingsPage.dart';
import 'package:espn/ui/standings/StandingsState.dart';
import 'package:espn/ui/standingsdetail/StandingsDetailsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'HomeState.dart';

class HomePage extends StatelessWidget {
  void _openStandingDetailsPage(Team team, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => StandingsDetailsPage(team: team),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        int currentIndex;
        String appBarTitle;
        Widget body;
        switch (state.selectedTab) {
          case SelectedTab.STANDINGS:
            currentIndex = 0;
            appBarTitle = HomeStrings.AppBarStandings;
            body = BlocProvider<StandingsBloc>(
              create: (context) {
                return StandingsBloc()..add(ReadyToFetch());
              },
              child: StandingsPage(
                onTeamTapped: (team) {
                  _openStandingDetailsPage(team, context);
                },
              ),
            );
            break;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
          ),
          body: body,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.list),
                title: new Text(HomeStrings.BottomNavStandings),
              ),
              BottomNavigationBarItem(
                  icon: new Icon(Icons.help), title: new Text("TODO"))
            ],
          ),
        );
      },
    );
  }
}
