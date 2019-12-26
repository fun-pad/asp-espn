import 'package:espn/resources/Sizes.dart';
import 'package:espn/resources/StandingsStrings.dart';
import 'package:espn/ui/common/LoadingLayout.dart';
import 'package:espn/ui/common/TeamLogo.dart';
import 'package:espn/ui/standings/StandingsBloc.dart';
import 'package:espn/ui/standings/StandingsEvent.dart';
import 'package:espn/ui/standings/StandingsState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StandingsPage extends StatelessWidget {
  final Function(Team) onTeamTapped;

  const StandingsPage({Key key, this.onTeamTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StandingsBloc, StandingsState>(
      builder: (context, state) {
        if (state is DisplayTeamData) {
          return _SuccessStandings(result: state, onTeamTapped: onTeamTapped);
        } else if (state is DisplayError) {
          return _ErrorStandings(
            error: state,
          );
        } else {
          return LoadingLayout();
        }
      },
    );
  }
}

class _ErrorStandings extends StatelessWidget {
  final DisplayError error;

  const _ErrorStandings({Key key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final standingsBloc = BlocProvider.of<StandingsBloc>(context);

    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              size: 64,
            ),
            Padding(
              padding: EdgeInsets.all(Spacing.medium),
            ),
            Text(error.message),
            FlatButton(
              onPressed: () {
                standingsBloc.add(RefreshData());
              },
              child: Text("Retry"),
            )
          ],
        ),
      ),
    );
  }
}

class _SuccessStandings extends StatelessWidget {
  final DisplayTeamData result;
  final Function(Team) onTeamTapped;

  const _SuccessStandings({
    Key key,
    this.result,
    this.onTeamTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final standingsBloc = BlocProvider.of<StandingsBloc>(context);

    List<Team> teams = result.teams;
    return RefreshIndicator(
      onRefresh: () {
        standingsBloc.add(RefreshData(recordType: result.filter.recordType));
        return Future.value(0);
      },
      child: ListView.separated(
        itemBuilder: (context, index) {
          if (index == 0) {
            return _FilterItem(
              standingsBloc: standingsBloc,
              currentState: result,
            );
          } else {
            return _ListItem(
              team: teams[index - 1],
              index: index - 1,
              onTeamTapped: onTeamTapped,
            );
          }
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: teams.length + 1,
      ),
    );
  }
}

class _FilterItem extends StatelessWidget {
  final StandingsBloc standingsBloc;
  final DisplayTeamData currentState;

  const _FilterItem({
    Key key,
    this.standingsBloc,
    this.currentState,
  }) : super(key: key);

  _newFilterSelected(RecordType type) {
    standingsBloc.add(UpdateRecordType(type, currentState));
  }

  @override
  Widget build(BuildContext context) {
    RecordType currentType = currentState.filter.recordType;

    return Padding(
      padding: EdgeInsets.only(
        top: Paddings.vertical,
        bottom: Paddings.vertical,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _FilterButton(
            text: StandingsStrings.FilterOverall,
            isSelected: currentType == RecordType.OVERALL,
            onPressed: () {
              _newFilterSelected(RecordType.OVERALL);
            },
          ),
          _FilterButton(
            text: StandingsStrings.FilterH2H,
            isSelected: currentType == RecordType.H2H,
            onPressed: () {
              _newFilterSelected(RecordType.H2H);
            },
          ),
          _FilterButton(
            text: StandingsStrings.FilterT6B6,
            isSelected: currentType == RecordType.T6B6,
            onPressed: () {
              _newFilterSelected(RecordType.T6B6);
            },
          )
        ],
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final Team team;
  final int index;
  final Function(Team) onTeamTapped;

  const _ListItem({
    Key key,
    this.team,
    this.index,
    this.onTeamTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTeamTapped(team);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: Paddings.vertical,
          horizontal: Paddings.horizontal,
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: Spacing.medium),
              child: Text(
                (index + 1).toString(),
                style: Theme.of(context).textTheme.body1,
              ),
            ),
            TeamLogo(url: team.logo),
            Padding(
              padding: const EdgeInsets.only(left: Spacing.medium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    team.name,
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Spacing.medium),
                  ),
                  Text(
                    team.label,
                    style: Theme.of(context).textTheme.body2,
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        team.wins.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .body2
                            .copyWith(color: Colors.green),
                      ),
                      Text(
                        "-",
                        style: Theme.of(context).textTheme.body2,
                      ),
                      Text(
                        team.losses.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .body2
                            .copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Spacing.medium),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "${team.pointsScored?.round()?.toString() ?? "N/A"} pts",
                        style: Theme.of(context).textTheme.body2,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const _FilterButton({
    Key key,
    this.text,
    this.isSelected,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color buttonColor;
    if (isSelected) {
      buttonColor = theme.accentColor;
    } else {
      buttonColor = theme.backgroundColor;
    }
    return Padding(
      padding: EdgeInsets.only(
        left: 4.0,
        right: 4.0,
      ),
      child: FlatButton(
        color: buttonColor,
        onPressed: onPressed,
        child: Text(
          text,
          style: Theme.of(context).textTheme.body1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}
