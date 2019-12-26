import 'package:bloc/bloc.dart';
import 'package:espn/ui/home/HomeEvent.dart';
import 'package:espn/ui/home/HomeState.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  @override
  HomeState get initialState => HomeState();

  @override
  Stream<HomeState> mapEventToState(event) {
    // TODO
  }
}
