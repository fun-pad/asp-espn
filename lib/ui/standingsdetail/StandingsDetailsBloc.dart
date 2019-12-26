import 'package:bloc/bloc.dart';
import 'package:espn/data/EspnCommon.dart';
import 'package:espn/data/EspnRepository.dart';
import 'package:espn/data/EspnResult.dart';
import 'package:espn/helpers/Calculator.dart';
import 'package:espn/helpers/H2HCalculator.dart';
import 'package:espn/helpers/T6B6Calculator.dart';
import 'package:espn/ui/standingsdetail/StandingsDetailsEvent.dart';
import 'package:espn/ui/standingsdetail/StandingsDetailsState.dart';

class StandingsDetailsBloc
    extends Bloc<StandingsDetailsEvent, StandingsDetailsState> {
  EspnRepository _espnRepository = EspnRepository.get();

  @override
  StandingsDetailsState get initialState => LoadingDetails();

  @override
  Stream<StandingsDetailsState> mapEventToState(
      StandingsDetailsEvent event) async* {
    try {
      int teamId = event.teamId;

      final EspnStandingsResult results =
          await _espnRepository.matchupResults();

      // Now we want to get all the results.
      WinLoss h2hWinLoss =
          H2HCalculator.get().calculateWinLossForTeam(results, teamId);
      WinLoss t6b6WinLoss =
          T6B6Calculator.get().calculateWinLossForTeam(results, teamId);
      WinLoss overallWinLoss = WinLoss(
        teamId,
        wins: h2hWinLoss.wins + t6b6WinLoss.wins,
        losses: h2hWinLoss.losses + t6b6WinLoss.losses,
      );

      yield DisplayingDetails(
          overallWinLoss: overallWinLoss,
          h2hWinLoss: h2hWinLoss,
          t6b6WinLoss: t6b6WinLoss,
          matchups: _figureOutMatchups(results, teamId));
    } catch (e, stacktrace) {
      print(stacktrace);

      yield ErrorLoadingDetails();
    }
  }

  List<Matchup> _figureOutMatchups(EspnStandingsResult results, int teamId) {
    List<Matchup> matchups = List();
    List<T6B6Weekly> t6b6Weekly =
        T6B6Calculator.get().calculateWeeklyWinLossForTeam(results, teamId);

    results.schedule.forEach(
      (schedule) {
        if (schedule.playoffTierType == "NONE") {
          ScheduleData home = schedule.home;
          ScheduleData away = schedule.away;

          if ((home != null && away != null) &&
              (home.teamId == teamId || away.teamId == teamId)) {
            Team homeTeam =
                results.teams.firstWhere((team) => team.id == home.teamId);
            Team awayTeam =
                results.teams.firstWhere((team) => team.id == away.teamId);

            MatchupTeam homeMatchup = MatchupTeam(
              shortName: homeTeam.abbrev,
              teamId: home.teamId,
              points: home.totalPoints,
              logo: homeTeam.logo,
              name: "${homeTeam.location} ${homeTeam.nickname}",
            );

            MatchupTeam awayMatchup = MatchupTeam(
              shortName: awayTeam.abbrev,
              teamId: away.teamId,
              points: away.totalPoints,
              logo: awayTeam.logo,
              name: "${awayTeam.location} ${awayTeam.nickname}",
            );

            WinLoss t6b6record = t6b6Weekly
                .firstWhere((e) => e.weekId == schedule.matchupPeriodId)
                .winLoss;

            Matchup matchup;
            if (home.teamId == teamId) {
              matchup = Matchup(
                  weekId: schedule.matchupPeriodId,
                  team: homeMatchup,
                  opponent: awayMatchup,
                  t6b6record: t6b6record);
            } else {
              matchup = Matchup(
                weekId: schedule.matchupPeriodId,
                team: awayMatchup,
                opponent: homeMatchup,
                t6b6record: t6b6record,
              );
            }

            matchups.add(matchup);
          }
        }
      },
    );

    return matchups;
  }
}
