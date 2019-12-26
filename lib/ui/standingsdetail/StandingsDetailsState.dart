import 'package:espn/helpers/Calculator.dart';
import 'package:flutter/cupertino.dart';

abstract class StandingsDetailsState {}

class LoadingDetails extends StandingsDetailsState {}

class DisplayingDetails extends StandingsDetailsState {
  final WinLoss overallWinLoss;
  final WinLoss t6b6WinLoss;
  final WinLoss h2hWinLoss;
  final List<Matchup> matchups;

  DisplayingDetails({
    @required this.overallWinLoss,
    @required this.t6b6WinLoss,
    @required this.h2hWinLoss,
    @required this.matchups,
  });
}

class ErrorLoadingDetails extends StandingsDetailsState {}

class Matchup {
  final int weekId;
  final MatchupTeam opponent;
  final MatchupTeam team;
  final WinLoss t6b6record;

  Matchup({this.weekId, this.opponent, this.team, this.t6b6record});

  WinLoss overallWeeklyRecord() {
    int wins = 0;
    int losses = 0;

    if (t6b6record.wins > t6b6record.losses) {
      wins++;
    } else {
      losses++;
    }

    if (team.points > opponent.points) {
      wins++;
    } else {
      losses++;
    }

    return WinLoss(t6b6record.teamId, wins: wins, losses: losses);
  }
}

class MatchupTeam {
  final int teamId;
  final String name;
  final String logo;
  final double points;
  final String shortName;

  MatchupTeam({
    this.shortName,
    this.name,
    this.teamId,
    this.logo,
    this.points,
  });
}
