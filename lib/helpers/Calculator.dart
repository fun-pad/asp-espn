import 'package:espn/data/EspnResult.dart';

abstract class Calculator {
  List<WinLoss> calculateWinLoss(EspnStandingsResult result) {}

  WinLoss calculateWinLossForTeam(EspnStandingsResult result, int teamId) {}
}

class WinLoss {
  final int teamId;
  int wins;
  int losses;

  WinLoss(
    this.teamId, {
    this.wins = 0,
    this.losses = 0,
  });

  void addWin() {
    wins = wins + 1;
  }

  void addLoss() {
    losses = losses + 1;
  }
}

class T6B6Weekly {
  final int weekId;
  final WinLoss winLoss;

  T6B6Weekly(this.weekId, this.winLoss);
}
