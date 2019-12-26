import 'package:equatable/equatable.dart';

abstract class StandingsDetailsEvent extends Equatable {
  final int teamId;

  StandingsDetailsEvent(this.teamId);

  @override
  List<Object> get props => [];
}

class ReadyToShowDetails extends StandingsDetailsEvent {
  ReadyToShowDetails(int teamId) : super(teamId);
}
