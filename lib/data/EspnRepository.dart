import 'dart:convert';

import 'package:espn/data/EspnResult.dart';
import 'package:flutter/services.dart';

import 'Client.dart';

const bool isMock = false;

class EspnRepository {
  static final EspnRepository _singleton = EspnRepository._internal();

  EspnRepository._internal();

  static EspnRepository get() {
    return _singleton;
  }

  EspnStandingsResult _cachedMatchupResults;

  Future<EspnStandingsResult> matchupResults() async {
    if (_cachedMatchupResults != null) {
      return _cachedMatchupResults;
    }

    if (isMock) {
      final response = await mockResponse();
      _cachedMatchupResults =
          EspnStandingsResult.fromJson(json.decode(response));
      return _cachedMatchupResults;
    } else {
      final response = await EspnClient.obtain().get(
          'https://fantasy.espn.com/apis/v3/games/ffl/seasons/2019/segments/0/leagues/65809?view=mTeam&view=mMatchupScore');

      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON.
        _cachedMatchupResults = EspnStandingsResult.fromJson(response.data);
        return _cachedMatchupResults;
      } else {
        // If that response was not OK, throw an error.
        throw Exception('Failed to load post');
      }
    }
  }

  void clearCachedMatchupResults() {
    _cachedMatchupResults = null;
  }

  Future<String> mockResponse() async {
    return rootBundle.loadString('assets/responses/espn.txt');
  }
}
