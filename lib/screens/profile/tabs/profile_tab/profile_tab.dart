import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mayandro_resume/model/project.dart';
import 'package:mayandro_resume/screens/profile/bloc/bloc_provider.dart';
import 'package:mayandro_resume/screens/profile/tabs/profile_tab/widget/top_bar.dart';
import 'package:mayandro_resume/screens/profile/tabs/profile_tab/widget/about_button_widget.dart';
import 'package:mayandro_resume/screens/profile/tabs/profile_tab/widget/experience_button_widget.dart';
import 'package:mayandro_resume/screens/profile/tabs/profile_tab/widget/project_pager_widget.dart';

class ProfileTab extends StatefulWidget {
  final double scrollPosition;

  ProfileTab(this.scrollPosition);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        TopBar(),
        _getListFromServer(context),
        ExperienceButton(widget.scrollPosition),
        AboutButton(widget.scrollPosition),
      ],
    );
  }

  _getListFromServer(BuildContext context) {
    var _bloc = ProfileBlocProvider.of(context);
    return StreamBuilder<List<ProjectItem>>(
        stream: _bloc.getProjectStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: SizedBox(
                height: 40,
                width: 40,
                child: Text(
                  'No Internet',
                  softWrap: true,
                  style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white),
                ),
              ),
            );
          }

          if (snapshot.data == null) {
            return Center(
              child: SizedBox(
                height: 40,
                width: 40,
                child: Text(
                  'Something went wrong',
                  softWrap: true,
                  style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white),
                ),
              ),
            );
          }
          return ProjectPager(
            scrollPosition: widget.scrollPosition,
            projectList: snapshot.data,
          );
        });
  }
}
