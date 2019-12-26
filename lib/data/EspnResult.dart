import 'EspnCommon.dart';

class EspnStandingsResult {
  final int id;
  final int scoringPeriod;
  final int seasonId;
  final Status status;
  final List<Member> members;
  final List<Team> teams;
  final List<Schedule> schedule;

  EspnStandingsResult({
    this.id,
    this.scoringPeriod,
    this.seasonId,
    this.status,
    this.members,
    this.teams,
    this.schedule,
  });

  factory EspnStandingsResult.fromJson(Map<String, dynamic> json) {
    var listOfTeams = json['teams'] as List;
    var listOfMembers = json['members'] as List;
    var listOfSchedules = json['schedule'] as List;

    return EspnStandingsResult(
      id: json['id'],
      members:
          listOfMembers.map<Member>((item) => Member.fromJson(item)).toList(),
      teams: listOfTeams.map<Team>((item) => Team.fromJson(item)).toList(),
      schedule: listOfSchedules
          .map<Schedule>((item) => Schedule.fromJson(item))
          .toList(),
      scoringPeriod: json['scoringPeriod'],
      seasonId: json['seasonId'],
      status: Status.fromJson(json['status']),
    );
  }
}
