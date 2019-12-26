import 'package:espn/data/EspnCommon.dart';
import 'package:espn/data/EspnResult.dart';
import 'package:espn/helpers/Calculator.dart';

class T6B6Calculator implements Calculator {
  static T6B6Calculator get() {
    return T6B6Calculator();
  }

  @override
  WinLoss calculateWinLossForTeam(EspnStandingsResult result, int teamId) {
    List<_WeeklyResults> weeklyResults = _getWeeklyResults(result);

    WinLoss winLossForTeam = WinLoss(teamId);

    weeklyResults.forEach(
      (result) {
        List<_TeamPoints> sortedPoints = result.teamPoints;
        sortedPoints.sort((a, b) => a.points.compareTo(b.points));

        int divider = (sortedPoints.length / 2).round();
        if (containsById(sortedPoints.sublist(0, divider), teamId)) {
          winLossForTeam.addLoss();
        } else if (containsById(
          sortedPoints.sublist(divider, sortedPoints.length),
          teamId,
        )) {
          winLossForTeam.addWin();
        }
      },
    );

    return winLossForTeam;
  }

  @override
  List<WinLoss> calculateWinLoss(EspnStandingsResult result) {
    List<_WeeklyResults> weeklyResults = _getWeeklyResults(result);

    List<WinLoss> winLosses = List();

    weeklyResults.forEach(
      (result) {
        List<_TeamPoints> sortedPoints = result.teamPoints;
        sortedPoints.sort((a, b) => a.points.compareTo(b.points));

        int divider = (sortedPoints.length / 2).round();
        // Winners of the week.
        sortedPoints.sublist(0, divider).forEach((points) {
          _getWinLoss(winLosses, points.teamId).addLoss();
        });
        // Losses of the week.
        sortedPoints.sublist(divider, sortedPoints.length).forEach((points) {
          _getWinLoss(winLosses, points.teamId).addWin();
        });
      },
    );

    return winLosses;
  }

  List<T6B6Weekly> calculateWeeklyWinLossForTeam(
      EspnStandingsResult result, int teamId) {
    List<_WeeklyResults> weeklyResults = _getWeeklyResults(result);
    List<T6B6Weekly> winLossByWeek = List();

    weeklyResults.forEach(
      (result) {
        List<_TeamPoints> sortedPoints = result.teamPoints;
        sortedPoints.sort((a, b) => a.points.compareTo(b.points));

        WinLoss winLoss = WinLoss(teamId);
        bool hasMet = false;
        sortedPoints.forEach(
          (element) {
            if (element.teamId == teamId) {
              hasMet = true;
            } else if (hasMet) {
              winLoss.addLoss();
            } else {
              winLoss.addWin();
            }
          },
        );

        winLossByWeek.add(T6B6Weekly(result.weeklyId, winLoss));
      },
    );

    return winLossByWeek;
  }

  static List<_WeeklyResults> _getWeeklyResults(EspnStandingsResult result) {
    List<_WeeklyResults> weeklyResults = List();

    result.schedule.forEach((schedule) {
      if (schedule.playoffTierType == "NONE") {
        ScheduleData home = schedule.home;
        ScheduleData away = schedule.away;
        int weekId = schedule.matchupPeriodId;

        if (!weeklyResults.contains(weeklyResults)) {
          weeklyResults.add(_WeeklyResults(weekId));
        }

        _WeeklyResults results =
            weeklyResults.firstWhere((e) => e.weeklyId == weekId);

        if (home != null) {
          results.addTeam(
              _TeamPoints(teamId: home.teamId, points: home.totalPoints));
        }
        if (away != null) {
          results.addTeam(
              _TeamPoints(teamId: away.teamId, points: away.totalPoints));
        }
      }
    });

    return weeklyResults;
  }

  static bool containsById(List<_TeamPoints> teamPoints, int teamId) {
    _TeamPoints _teamPoints =
        teamPoints.firstWhere((e) => e.teamId == teamId, orElse: () => null);

    return _teamPoints != null;
  }

  static WinLoss _getWinLoss(List<WinLoss> teamPoints, int teamId) {
    WinLoss winLoss =
        teamPoints.firstWhere((e) => e.teamId == teamId, orElse: () => null);

    if (winLoss == null) {
      WinLoss newWinLoss = WinLoss(teamId);
      teamPoints.add(newWinLoss);

      return newWinLoss;
    } else {
      return winLoss;
    }
  }
}

class _WeeklyResults {
  final int weeklyId;
  final List<_TeamPoints> teamPoints = List();

  _WeeklyResults(this.weeklyId);

  void addTeam(_TeamPoints team) {
    teamPoints.add(team);
  }

  bool operator ==(o) => o is _WeeklyResults && weeklyId == o.weeklyId;

  int get hashCode => weeklyId.hashCode;
}

class _TeamPoints {
  final int teamId;
  final double points;

  _TeamPoints({this.teamId, this.points});
}
