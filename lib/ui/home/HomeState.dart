class HomeState {
  final SelectedTab selectedTab;

  HomeState({this.selectedTab = SelectedTab.STANDINGS});
}

enum SelectedTab { STANDINGS }
