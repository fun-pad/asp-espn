import 'package:espn/helpers/Calculator.dart';
import 'package:espn/resources/Sizes.dart';
import 'package:espn/resources/StandingsDetailsStrings.dart';
import 'package:espn/ui/common/LoadingLayout.dart';
import 'package:espn/ui/common/TeamLogo.dart';
import 'package:espn/ui/standings/StandingsState.dart';
import 'package:espn/ui/standingsdetail/StandingsDetailsEvent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'StandingsDetailsBloc.dart';
import 'StandingsDetailsState.dart';

class StandingsDetailsPage extends StatelessWidget {
  final Team team;

  const StandingsDetailsPage({
    Key key,
    @required this.team,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(team.name),
        actions: <Widget>[
          Padding(
            child: TeamLogo(
              url: team.logo,
            ),
            padding: EdgeInsets.only(
              right: Spacing.medium,
            ),
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocProvider<StandingsDetailsBloc>(
        create: (context) {
          return StandingsDetailsBloc()..add(ReadyToShowDetails(team.id));
        },
        child: BlocBuilder<StandingsDetailsBloc, StandingsDetailsState>(
          builder: (context, state) {
            if (state is DisplayingDetails) {
              return _SuccessDetails(
                details: state,
              );
            } else if (state is LoadingDetails) {
              return LoadingLayout();
            } else {
              throw UnimplementedError();
            }
          },
        ),
      ),
    );
  }
}

class _SuccessDetails extends StatelessWidget {
  final DisplayingDetails details;

  const _SuccessDetails({Key key, this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        if (index == 0) {
          return _RecordsDisplay(details: details);
        } else if (index == 1) {
          return _MatchupTitle();
        } else {
          Matchup matchup = details.matchups[index - 2];

          return _MatchupsDisplay(matchup: matchup);
        }
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: (details.matchups?.length ?? 0) + 2,
    );
  }
}

class _WinLossDisplay extends StatelessWidget {
  final WinLoss winLoss;
  final String label;

  const _WinLossDisplay({Key key, this.winLoss, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              winLoss.wins.toString(),
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(color: Colors.green),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.small),
              child: Text(
                "-",
                style: Theme.of(context).textTheme.body2,
              ),
            ),
            Text(
              winLoss.losses.toString(),
              style:
                  Theme.of(context).textTheme.title.copyWith(color: Colors.red),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: Spacing.small),
          child: Text(
            label,
            style: Theme.of(context).textTheme.subtitle,
          ),
        )
      ],
    );
  }
}

class _MatchupTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Paddings.horizontal,
        vertical: Paddings.vertical,
      ),
      child: Text(
        StandingsDetailsStrings.TitleMatchups,
        style: Theme.of(context).textTheme.subtitle,
      ),
    );
  }
}

class _MatchupsDisplay extends StatelessWidget {
  final Matchup matchup;

  const _MatchupsDisplay({Key key, this.matchup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MatchupTeam homeTeam = matchup.team;
    MatchupTeam awayTeam = matchup.opponent;
    WinLoss overallRecord = matchup.overallWeeklyRecord();

    Color homeTextColor;
    Color awayTextColor;
    Color t6b6TextColor;
    Color overallRecordTextColor;

    if (homeTeam.points > awayTeam.points) {
      homeTextColor = Colors.green;
      awayTextColor = Colors.red;
    } else {
      homeTextColor = Colors.red;
      awayTextColor = Colors.green;
    }

    int t6b6Wins = matchup.t6b6record.wins;
    int t6b6Losses = matchup.t6b6record.losses;
    if (t6b6Wins > t6b6Losses) {
      t6b6TextColor = Colors.green;
    } else {
      t6b6TextColor = Colors.red;
    }

    if (overallRecord.wins > overallRecord.losses) {
      overallRecordTextColor = Colors.green;
    } else if (overallRecord.wins == overallRecord.losses) {
      overallRecordTextColor = Colors.orange;
    } else {
      overallRecordTextColor = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Paddings.horizontal,
        vertical: Paddings.vertical,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  bottom: Spacing.medium,
                ),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Week ${matchup.weekId} Record ",
                      style: Theme.of(context).textTheme.body1,
                    ),
                    Text(
                      "${matchup.overallWeeklyRecord().wins} - ${matchup.overallWeeklyRecord().losses}",
                      style: Theme.of(context).textTheme.body2.copyWith(
                            color: overallRecordTextColor,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TeamLogo(
                      url: homeTeam.logo,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Spacing.medium),
                      child: Text(
                        homeTeam.shortName,
                        style: Theme.of(context).textTheme.body2,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: Spacing.small),
                      child: Text(
                        homeTeam.points.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.body2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: homeTextColor,
                            ),
                      ),
                    ),
                    Text("vs"),
                    Padding(
                      padding: EdgeInsets.only(left: Spacing.small),
                      child: Text(
                        awayTeam.points.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.body2.copyWith(
                              fontWeight: FontWeight.bold,
                              color: awayTextColor,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: Spacing.medium),
                      child: Text(
                        awayTeam.shortName,
                        style: Theme.of(context).textTheme.body2,
                      ),
                    ),
                    TeamLogo(
                      url: awayTeam.logo,
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
            child: Text(
              "${StandingsDetailsStrings.LabelWeeklyT6B6}: ${matchup.t6b6record.wins} - ${matchup.t6b6record.losses}",
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: t6b6TextColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordsDisplay extends StatelessWidget {
  final DisplayingDetails details;

  const _RecordsDisplay({Key key, this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Paddings.horizontal,
        vertical: Paddings.vertical,
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: Paddings.vertical,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _WinLossDisplay(
                label: StandingsDetailsStrings.LabelH2H,
                winLoss: details.h2hWinLoss,
              ),
              Text(
                "+",
                style: Theme.of(context).textTheme.body2,
              ),
              _WinLossDisplay(
                label: StandingsDetailsStrings.LabelT6B6,
                winLoss: details.t6b6WinLoss,
              ),
              Text(
                "=",
                style: Theme.of(context).textTheme.body2,
              ),
              _WinLossDisplay(
                label: StandingsDetailsStrings.LabelOverall,
                winLoss: details.overallWinLoss,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
