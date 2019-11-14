import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mayandro_resume/model/education.dart';
import 'package:mayandro_resume/screens/profile/bloc/bloc_provider.dart';
import 'package:mayandro_resume/screens/profile/tabs/about_tab/widget/card_background_widget.dart';
import 'package:mayandro_resume/screens/profile/tabs/about_tab/widget/card_content_widget.dart';

class EducationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: <Widget>[
            CardBackground(
              iconData: Icons.school,
            ),
            CardContent(
              iconData: Icons.school,
              label: 'Education',
              childWidget: _getEducationListFromCloud(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getEducationListFromCloud(BuildContext context) {
    final _bloc = ProfileBlocProvider.of(context);
    return StreamBuilder<List<EducationItem>>(
        stream: _bloc.getEducationStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'No Internet',
                softWrap: true,
                style: Theme.of(context).textTheme.caption.copyWith(color: Colors.black87),
              ),
            );
          }

          if (snapshot.data == null) {
            return Center(
              child: Text(
                'Something went wrong',
                softWrap: true,
                style: Theme.of(context).textTheme.caption.copyWith(color: Colors.black87),
              ),
            );
          }

          return EducationList(
            educationList: snapshot.data,
          );
        });
  }
}

class EducationList extends StatelessWidget {
  final List<EducationItem> educationList;

  const EducationList({@required this.educationList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      itemCount: educationList.length,
      itemBuilder: (context, i) {
        return EducationRowItem(
          educationItem: educationList[i],
        );
      },
      separatorBuilder: (context, i) {
        return SizedBox(
          height: 8,
        );
      },
    );
  }
}

class EducationRowItem extends StatelessWidget {
  final EducationItem educationItem;

  const EducationRowItem({@required this.educationItem});

  @override
  Widget build(BuildContext context) {
    final _bloc = ProfileBlocProvider.of(context);
    return InkWell(
      onTap: () => _bloc.launchURL(educationItem.link),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildEducationCourseField(context),
          SizedBox(
            height: 2,
          ),
          _buildEducationCourseSubject(context),
          SizedBox(
            height: 4,
          ),
          _buildUniversity(context),
          SizedBox(
            height: 2,
          ),
          _buildIconText(context, educationItem.duration, Icons.access_time),
        ],
      ),
    );
  }

  Widget _buildEducationCourseSubject(BuildContext context) {
    return Text(
      educationItem.course,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.subtitle.copyWith(color: Colors.black),
    );
  }

  Widget _buildEducationCourseField(BuildContext context) {
    return Text(
      educationItem.degree,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.title.copyWith(color: Colors.black),
    );
  }

  Widget _buildUniversity(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _buildIconText(context, educationItem.university, Icons.school),
        Spacer(),
        _buildIconText(context, educationItem.location, Icons.location_on),
      ],
    );
  }

  Widget _buildIconText(BuildContext context, String label, IconData iconData) {
    return Row(
      children: <Widget>[
        Icon(
          iconData,
          size: 16,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black),
        ),
      ],
    );
  }
}
