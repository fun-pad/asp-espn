import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class StandingsState {}

class DisplayTeamData extends StandingsState {
  final List<Team> teams;
  final Filter filter;

  DisplayTeamData({
    this.teams,
    this.filter,
  });
}

class DisplayError implements StandingsState {
  final String message;

  DisplayError({this.message});
}

class DisplayLoading implements StandingsState {
  const DisplayLoading();
}

class Team {
  final int id;
  final String logo;
  final String name;
  final String label;
  final int wins;
  final int losses;
  final double pointsScored;

  Team({
    @required this.id,
    @required this.logo,
    @required this.label,
    @required this.name,
    @required this.wins,
    @required this.losses,
    @required this.pointsScored,
  });
}

class Filter {
  final RecordType recordType;

  Filter({this.recordType = RecordType.OVERALL});
}

enum RecordType { OVERALL, H2H, T6B6 }
