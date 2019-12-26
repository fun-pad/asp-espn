import 'package:equatable/equatable.dart';
import 'package:espn/data/EspnResult.dart';
import 'package:espn/ui/standings/StandingsState.dart';
import 'package:flutter/cupertino.dart';

abstract class StandingsEvent extends Equatable {
  const StandingsEvent();

  @override
  List<Object> get props => [];
}

class UpdateRecordType extends StandingsEvent {
  final RecordType recordType;
  final DisplayTeamData currentState;

  UpdateRecordType(this.recordType, this.currentState);
}

class ReadyToFetch extends StandingsEvent {}

class RefreshData extends StandingsEvent {
  final RecordType recordType;

  RefreshData({this.recordType = RecordType.OVERALL});
}

class ResultReady extends StandingsEvent {
  final EspnStandingsResult result;

  const ResultReady({@required this.result});

  @override
  List<Object> get props => [result];

  @override
  String toString() => 'ResultReady { result: $result }';
}
