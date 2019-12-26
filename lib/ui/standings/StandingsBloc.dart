import 'package:bloc/bloc.dart';
import 'package:espn/data/EspnRepository.dart';
import 'package:espn/data/EspnResult.dart';
import 'package:espn/helpers/Calculator.dart';
import 'package:espn/helpers/H2HCalculator.dart';
import 'package:espn/helpers/T6B6Calculator.dart';
import 'package:espn/ui/standings/StandingsEvent.dart';
import 'package:espn/ui/standings/StandingsState.dart';

class StandingsBloc extends Bloc<StandingsEvent, StandingsState> {
  EspnRepository _espnRepository = EspnRepository.get();

  @override
  StandingsState get initialState => DisplayLoading();

  @override
  Stream<StandingsState> mapEventToState(StandingsEvent event) async* {
    if (event is RefreshData) {
      _espnRepository.clearCachedMatchupResults();

      yield DisplayLoading();
    }
    RecordType recordType = RecordType.OVERALL;
    if (event is UpdateRecordType) {
      recordType = event.recordType;
    } else if (event is RefreshData) {
      recordType = event.recordType;
    }

    try {
      final EspnStandingsResult espnResult =
          await _espnRepository.matchupResults();

      yield DisplayTeamData(
        teams: _convertToTeams(espnResult, recordType),
        filter: Filter(recordType: recordType),
      );
    } catch (e, stacktrace) {
      print(stacktrace);
      yield DisplayError(message: e.toString());
    }
  }

  displayTeamData(RecordType recordType) async {}

  List<Team> _convertToTeams(
    EspnStandingsResult espnResult,
    RecordType recordType,
  ) {
    List<Team> teams = List<Team>();
    List<WinLoss> t6b6WinLosses =
        T6B6Calculator.get().calculateWinLoss(espnResult);
    List<WinLoss> h2hWinLosses =
        H2HCalculator.get().calculateWinLoss(espnResult);

    espnResult.teams.forEach((espnTeam) {
      WinLoss h2hWinLoss =
          h2hWinLosses.firstWhere((e) => e.teamId == espnTeam.id);
      WinLoss t6b6WinLoss =
          t6b6WinLosses.firstWhere((e) => e.teamId == espnTeam.id);

      int wins;
      int losses;
      if (recordType == RecordType.OVERALL) {
        wins = h2hWinLoss.wins + t6b6WinLoss.wins;
        losses = h2hWinLoss.losses + t6b6WinLoss.losses;
      } else if (recordType == RecordType.H2H) {
        wins = h2hWinLoss.wins;
        losses = h2hWinLoss.losses;
      } else {
        wins = t6b6WinLoss.wins;
        losses = t6b6WinLoss.losses;
      }

      teams.add(
        Team(
          id: espnTeam.id,
          wins: wins,
          losses: losses,
          logo: espnTeam.logo,
          name: "${espnTeam.location} ${espnTeam.nickname}",
          label: espnTeam.abbrev,
          pointsScored: espnTeam.points,
        ),
      );
    });

    // Sort by rank.
    teams.sort((a, b) {
      int winComparison = b.wins.compareTo(a.wins);

      if (winComparison == 0) {
        return b.pointsScored.compareTo(a.pointsScored);
      }

      return winComparison;
    });
    return teams;
  }
}
