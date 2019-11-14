import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mayandro_resume/common_widgets/rounded_button.dart';
import 'package:mayandro_resume/screens/profile/bloc/bloc_provider.dart';
import 'package:mayandro_resume/screens/profile/tabs/experience_tab/widget/experience_list_widget.dart';
import 'package:mayandro_resume/screens/profile/tabs/experience_tab/widget/left_back_button_widget.dart';
import 'package:mayandro_resume/model/experience.dart';
import 'package:mayandro_resume/screens/profile/tabs/experience_tab/widget/top_bar.dart';

class ExperienceTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _bloc = ProfileBlocProvider.of(context);
    return Stack(
      children: <Widget>[
        _buildTimeline(context),
        ExperienceTabPageTopBar(),
        LeftBackButton(),
        _buildList(context),
        _buildButton(context),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    var _bloc = ProfileBlocProvider.of(context);
    return StreamBuilder<List<ExperienceItem>>(
        stream: _bloc.getExperienceStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: Offstage(),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'No Internet',
                softWrap: true,
                style: Theme.of(context).textTheme.subtitle.copyWith(color: Colors.black87),
              ),
            );
          }

          if (snapshot.data == null) {
            return Center(
              child: Text(
                'Something went wrong',
                softWrap: true,
                style: Theme.of(context).textTheme.subtitle.copyWith(color: Colors.black87),
              ),
            );
          }
          return ExperienceList(experienceList: snapshot.data.reversed.toList());
        });
  }

  Widget _buildTimeline(BuildContext context) {
    final _bloc = ProfileBlocProvider.of(context);
    return Positioned(
      top: 0.0,
      bottom: 0.0,
      left: 32.0,
      child: StreamBuilder<double>(
          stream: _bloc.mainPagerStream,
          builder: (context, snapshot) {
            double scroll = snapshot.hasData ? snapshot.data : 1;
            return Transform.translate(
              offset: Offset(
                0,
                (2 - scroll) * MediaQuery.of(context).size.height * 0.75,
              ),
              child: Container(
                width: 1.0,
                color: Colors.black87,
              ),
            );
          }),
    );
  }

  _buildButton(BuildContext context) {
    var _bloc = ProfileBlocProvider.of(context);
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.15,
      left: 0,
      right: 0,
      child: StreamBuilder<double>(
          stream: _bloc.mainPagerStream,
          builder: (context, snapshot) {
            double scroll = snapshot.hasData ? snapshot.data : 1;
            return Opacity(
                opacity: scroll > 1.5 ? ((scroll - 1) - 0.3) / 0.7 : 0,
                child: RoundedButton(onPressed: _bloc.createEmail, text: 'Hire Me!'));
          }),
    );
  }
}
