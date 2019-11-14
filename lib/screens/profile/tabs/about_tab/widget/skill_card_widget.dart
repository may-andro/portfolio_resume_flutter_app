import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mayandro_resume/screens/profile/tabs/about_tab/widget/card_background_widget.dart';

import 'card_content_widget.dart';

class SkillCard extends StatelessWidget {
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
              iconData: Icons.star,
            ),
            CardContent(
              iconData: Icons.star,
              label: 'Skill',
              childWidget: _getSkillListFromCloud(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSkillListFromCloud() {
    return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("skillTable").getDocuments(),
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
          List<String> skillItemList = [];
          snapshot.data.documents.forEach((snapshot) {
            skillItemList.add(snapshot['skill'] as String);
          });

          return SkillList(
            skillList: skillItemList,
          );
        });
  }
}

class SkillList extends StatelessWidget {
  final List<String> skillList;

  const SkillList({@required this.skillList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      itemCount: skillList.length,
      itemBuilder: (context, i) {
        return SkillRowItem(
          skill: skillList[i],
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

class SkillRowItem extends StatelessWidget {
  final String skill;

  const SkillRowItem({@required this.skill});

  @override
  Widget build(BuildContext context) {
    return Text(
      skill,
      style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black87),
    );
  }
}
