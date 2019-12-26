class Settings {
  final String name;

  Settings({this.name});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(name: json['name']);
  }
}

class Team {
  final String abbrev;
  final int id;
  final int currentProjectedRank;
  final int playoffSeed;
  final double points;
  final String logo;
  final String location;
  final String nickname;
  final List<String> owners;
  final Record record;

  Team(
      {this.record,
      this.currentProjectedRank,
      this.playoffSeed,
      this.points,
      this.logo,
      this.abbrev,
      this.id,
      this.location,
      this.nickname,
      this.owners});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
        abbrev: json['abbrev'],
        id: json['id'],
        location: json['location'],
        owners: (json['owners'] as List).map<String>((json) => json).toList(),
        currentProjectedRank: json['currentProjectedRank'],
        logo: json['logo'],
        nickname: json['nickname'],
        playoffSeed: json['playoffSeed'],
        points: json['points'],
        record: Record.fromJson(json['record']));
  }
}

class Record {
  final RecordData overall;

  Record({this.overall});

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(overall: RecordData.fromJson(json['overall']));
  }
}

class RecordData {
  final int wins;
  final int losses;
  final int ties;
  final int streakLength;
  final StreakType streakType;
  final double pointsAgainst;
  final double pointsFor;

  RecordData(
      {this.wins,
      this.losses,
      this.ties,
      this.streakLength,
      this.streakType,
      this.pointsAgainst,
      this.pointsFor});

  factory RecordData.fromJson(Map<String, dynamic> json) {
    return RecordData(
      wins: json['wins'],
      losses: json['losses'],
      ties: json['ties'],
      streakLength: json['streakLength'],
      pointsFor: json['pointsFor'],
      pointsAgainst: json['pointsAgainst'],
      streakType: StreakType.values.firstWhere(
          (e) => e.toString().toUpperCase().contains(json['streakType'])),
    );
  }
}

enum StreakType { LOSS, WIN }

class Member {
  final String displayName;
  final String id;
  final bool isLeagueManager;

  Member({this.displayName, this.id, this.isLeagueManager});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
        displayName: json['displayName'],
        id: json['id'],
        isLeagueManager: json['isLeagueManager']);
  }
}

class Schedule {
  final ScheduleData home;
  final ScheduleData away;
  final int id;
  final int matchupPeriodId;
  final String playoffTierType;
  final Winner winner;

  Schedule(
      {this.home,
      this.away,
      this.id,
      this.matchupPeriodId,
      this.playoffTierType,
      this.winner});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    bool hasHome = json['home'] != null;
    bool hasAway = json['away'] != null;

    return Schedule(
      home: hasHome ? ScheduleData.fromJson(json['home']) : null,
      away: hasAway ? ScheduleData.fromJson(json['away']) : null,
      id: json['id'],
      matchupPeriodId: json['matchupPeriodId'],
      playoffTierType: json['playoffTierType'],
      winner: Winner.values.firstWhere(
          (e) => e.toString().toUpperCase().contains(json['winner']),
          orElse: () => Winner.NONE),
    );
  }
}

enum Winner { HOME, AWAY, NONE }

class ScheduleData {
  final int teamId;
  final double totalPoints;

  ScheduleData({this.teamId, this.totalPoints});

  factory ScheduleData.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    return ScheduleData(
      teamId: json['teamId'],
      totalPoints: json['totalPoints'],
    );
  }
}

class Status {
  final int currentMatchupPeriod;

  Status({this.currentMatchupPeriod});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(currentMatchupPeriod: json['currentMatchupPeriod']);
  }
}
