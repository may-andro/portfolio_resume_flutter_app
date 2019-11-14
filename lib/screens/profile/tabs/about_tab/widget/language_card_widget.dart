import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mayandro_resume/model/language.dart';
import 'package:mayandro_resume/screens/profile/bloc/bloc_provider.dart';
import 'package:mayandro_resume/screens/profile/tabs/about_tab/widget/card_background_widget.dart';
import 'package:mayandro_resume/screens/profile/tabs/about_tab/widget/card_content_widget.dart';

class LanguageCard extends StatelessWidget {
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
              iconData: Icons.language,
            ),
            CardContent(
              iconData: Icons.language,
              label: 'Language',
              childWidget: _getListFromServer(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getListFromServer(BuildContext context) {
    final _bloc = ProfileBlocProvider.of(context);
    return StreamBuilder<List<LanguageItem>>(
        stream: _bloc.getLanguageItemStream,
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
          return LanguageListView(
            languageList: snapshot.data,
          );
        });
  }
}

class LanguageListView extends StatelessWidget {
  final List<LanguageItem> languageList;

  const LanguageListView({@required this.languageList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      itemCount: languageList.length,
      itemBuilder: (context, i) {
        return LanguageRowItem(
          languageItem: languageList[i],
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

class LanguageRowItem extends StatelessWidget {
  final LanguageItem languageItem;

  const LanguageRowItem({@required this.languageItem});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          languageItem.language,
          style: Theme.of(context).textTheme.body2.copyWith(color: Colors.black87),
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          languageItem.level,
          style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black87),
        ),
      ],
    );
  }
}
