import 'package:espn/data/EspnCommon.dart';
import 'package:espn/data/EspnResult.dart';
import 'package:espn/helpers/Calculator.dart';

class H2HCalculator implements Calculator {
  static H2HCalculator get() {
    return H2HCalculator();
  }

  @override
  WinLoss calculateWinLossForTeam(EspnStandingsResult result, int teamId) {
    WinLoss teamWinLoss = WinLoss(teamId);

    result.schedule.forEach(
      (schedule) {
        if (schedule.playoffTierType == "NONE") {
          ScheduleData home = schedule.home;
          ScheduleData away = schedule.away;

          if (home.teamId == teamId) {
            if (home.totalPoints > away.totalPoints) {
              teamWinLoss.addWin();
            } else {
              teamWinLoss.addLoss();
            }
          } else if (away.teamId == teamId) {
            if (away.totalPoints > home.totalPoints) {
              teamWinLoss.addWin();
            } else {
              teamWinLoss.addLoss();
            }
          }
        }
      },
    );

    return teamWinLoss;
  }

  @override
  List<WinLoss> calculateWinLoss(EspnStandingsResult result) {
    List<WinLoss> winLosses = List();

    result.schedule.forEach((schedule) {
      if (schedule.playoffTierType == "NONE") {
        ScheduleData home = schedule.home;
        ScheduleData away = schedule.away;

        if (home.totalPoints > away.totalPoints) {
          _getWinLoss(winLosses, home.teamId).addWin();
          _getWinLoss(winLosses, away.teamId).addLoss();
        } else {
          _getWinLoss(winLosses, home.teamId).addLoss();
          _getWinLoss(winLosses, away.teamId).addWin();
        }
      }
    });

    return winLosses;
  }

  static WinLoss _getWinLoss(List<WinLoss> winLosses, int teamId) {
    WinLoss winLoss =
        winLosses.firstWhere((e) => e.teamId == teamId, orElse: () => null);

    if (winLoss == null) {
      WinLoss newWinLoss = WinLoss(teamId);
      winLosses.add(newWinLoss);

      return newWinLoss;
    } else {
      return winLoss;
    }
  }
}
