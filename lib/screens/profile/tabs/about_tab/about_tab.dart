import 'package:flutter/material.dart';
import 'package:mayandro_resume/common_widgets/rounded_button.dart';
import 'package:mayandro_resume/screens/profile/bloc/bloc_provider.dart';
import 'package:mayandro_resume/screens/profile/tabs/about_tab/widget/education_card_widget.dart';
import 'package:mayandro_resume/screens/profile/tabs/about_tab/widget/language_card_widget.dart';
import 'package:mayandro_resume/screens/profile/tabs/about_tab/widget/skill_card_widget.dart';
import 'package:mayandro_resume/screens/profile/tabs/about_tab/widget/right_back_button_widget.dart';
import 'package:mayandro_resume/screens/profile/tabs/about_tab/widget/top_bar.dart';

class AboutTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AboutPageTopBar(),
        RightBackButton(),
        _buildContent(context),
        _buildButton(context),
      ],
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
              opacity: scroll < 0.5 ? ((1 - scroll) - 0.3) / 0.7 : 0,
              child: StreamBuilder<double>(
                  stream: _bloc.downloadCVStream,
                  builder: (context, snapshot) {
                    var text =
                        snapshot.hasData ? 'Downloading: ' + snapshot.data.toStringAsFixed(0) + "%" : 'Download Resume';
                    var isClickable = snapshot.hasData ? false : true;
                    return RoundedButton(
                      onPressed: _bloc.downloadFile,
                      text: text,
                      isClickable: isClickable,
                    );
                  }),
            );
          }),
    );
  }

  Widget _buildContent(BuildContext context) {
    final _bloc = ProfileBlocProvider.of(context);
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.3,
      left: 0,
      right: 0,
      bottom: 0,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return;
        },
        child: SingleChildScrollView(
          child: StreamBuilder<double>(
              stream: _bloc.mainPagerStream,
              builder: (context, snapshot) {
                double scroll = snapshot.hasData ? snapshot.data : 1;
                return Opacity(
                  opacity: (1 - scroll),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      EducationCard(),
                      SkillCard(),
                      LanguageCard(),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
