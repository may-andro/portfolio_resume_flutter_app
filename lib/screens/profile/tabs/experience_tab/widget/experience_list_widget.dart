import 'package:flutter/material.dart';
import 'package:mayandro_resume/model/experience.dart';
import 'package:mayandro_resume/screens/experience/experience_page.dart';
import 'package:mayandro_resume/screens/profile/bloc/bloc_provider.dart';

class ExperienceList extends StatelessWidget {
  final List<ExperienceItem> experienceList;

  const ExperienceList({@required this.experienceList});

  @override
  Widget build(BuildContext context) {
    final _bloc = ProfileBlocProvider.of(context);
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.45,
      left: 0,
      right: 0,
      bottom: 0,
      child: StreamBuilder<double>(
          stream: _bloc.mainPagerStream,
          builder: (context, snapshot) {
            double scroll = snapshot.hasData ? snapshot.data : 1;
            return Transform(
              transform: new Matrix4.translationValues(
                (2 - scroll) * MediaQuery.of(context).size.width,
                0.0,
                0.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildHeader(context),
                  _buildList(context),
                ],
              ),
            );
          }),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.only(left: 60.0),
      child: new Text(
        'Experience ',
        style: Theme.of(context).textTheme.display1.copyWith(color: Colors.black),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Expanded(
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return;
        },
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: experienceList.length,
          itemBuilder: (context, i) {
            return ExperienceRowItem(
              experienceList[i],
            );
          },
          separatorBuilder: (context, i) {
            return SizedBox(
              height: 12,
            );
          },
        ),
      ),
    );
  }
}

class ExperienceRowItem extends StatelessWidget {
  final ExperienceItem experience;
  final double dotSize = 12.0;

  const ExperienceRowItem(this.experience);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 500),
              pageBuilder: (context, _, __) => ExperiencePage(experience: experience)),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildDot(),
          Expanded(
            child: _buildCard(context),
          ),
        ],
      ),
    );
  }

  _buildDot() {
    return Padding(
      padding: new EdgeInsets.symmetric(horizontal: 32.0 - dotSize / 2, vertical: 8),
      child: Container(
        height: dotSize,
        width: dotSize,
        decoration: new BoxDecoration(shape: BoxShape.circle, color: Colors.black),
      ),
    );
  }

  _buildCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(right: 16),
      color: Colors.white,
      elevation: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildName(context),
          _buildDesignation(context),
          SizedBox(
            height: 4,
          ),
          Text(
            experience.summary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: Theme.of(context).textTheme.caption.copyWith(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  _buildName(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Hero(
          tag: "name-${experience.company}",
          child: Text(
            experience.company,
            style: Theme.of(context).textTheme.title.copyWith(color: Colors.black87),
          ),
        ),
        Icon(
          Icons.navigate_next,
          color: Colors.black87,
        )
      ],
    );
  }

  _buildDesignation(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          experience.designation,
          style: Theme.of(context).textTheme.subtitle.copyWith(color: Colors.black87),
        ),
        Text(
          experience.duration,
          style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black87),
        ),
      ],
    );
  }
}
