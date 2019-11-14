import 'package:flutter/material.dart';

import 'profile_bloc.dart';

class ProfileBlocProvider extends InheritedWidget {
  final ProfileBloc bloc;

  const ProfileBlocProvider({
    Key key,
    @required this.bloc,
    Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static ProfileBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ProfileBlocProvider) as ProfileBlocProvider).bloc;
  }
}
