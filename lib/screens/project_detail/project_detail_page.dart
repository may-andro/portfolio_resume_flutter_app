import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mayandro_resume/model/project.dart';
import 'package:mayandro_resume/common_widgets/fluid_top_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectDetailPage extends StatelessWidget {
  final ProjectItem project;

  const ProjectDetailPage({Key key, this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _buildTimeline(),
          _buildTopBackground(context),
          _buildBackIcon(context),
          _buildImage(context),
          _buildTasksList(context),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Positioned(
      top: 0.0,
      bottom: 0.0,
      left: 40.0,
      child: Container(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );
  }

  Widget _buildTopBackground(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      height: MediaQuery.of(context).size.height * 0.3,
      child: FluidTopBar(
        child: Container(),
      ),
    );
  }

  Widget _buildBackIcon(BuildContext context) {
    return Positioned(
      left: 16,
      top: 32,
      child: IconButton(
        icon: Icon(
          Icons.close,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Positioned(
      right: 16,
      top: 32,
      child: Hero(
        tag: "image-${project.name}",
        child: Material(
            color: Colors.transparent,
            child: Card(
              color: Colors.white,
              elevation: 16,
              shape: CircleBorder(),
              child: Padding(
                  padding: EdgeInsets.all(12),
                  child: FadeInImage.assetNetwork(
                    image: project.avatar,
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.height * 0.07,
                    placeholder: 'assets/loading.gif',
                  )),
            )),
      ),
    );
  }

  Widget _buildTasksList(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.3,
      bottom: 0.0,
      left: 0.0,
      right: 16,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildAvailableAt(context),
            DataRow(
              iconData: Icons.business,
              label: 'Company',
              value: project.company,
            ),
            DataRow(
              iconData: Icons.work,
              label: 'Role',
              value: project.role,
            ),
            DataRow(
              iconData: Icons.access_time,
              label: 'Duration',
              value: project.duration,
            ),
            DataRow(
              iconData: Icons.location_on,
              label: 'Location',
              value: project.location,
            ),
            DataRow(
                iconData: Icons.description,
                label: 'Work Description',
                value: project.summary,
                isVerticalCentered: false),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableAt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: "name-${project.name}",
            child: Material(
              color: Colors.transparent,
              child: Text(
                project.name,
                style: new TextStyle(fontSize: 26.0, color: Colors.black87, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: <Widget>[
              Text(
                'Available On: ',
                style: Theme.of(context).textTheme.caption.copyWith(color: Colors.grey),
                softWrap: true,
                textAlign: TextAlign.justify,
              ),
              project.playStoreLink != null && project.playStoreLink.isNotEmpty
                  ? _buildStoreIcon(
                      'https://firebasestorage.googleapis.com/v0/b/myresume-32d30.appspot.com/o/playstore.jpeg?alt=media&token=c104a31f-d347-4d23-ad4e-5f18f7176150',
                      project.playStoreLink)
                  : Offstage(),
              project.playStoreLink != null && project.playStoreLink.isNotEmpty
                  ? SizedBox(
                      width: 4,
                    )
                  : Offstage(),
              project.githubLink != null && project.githubLink.isNotEmpty
                  ? _buildStoreIcon(
                      'https://firebasestorage.googleapis.com/v0/b/myresume-32d30.appspot.com/o/github.png?alt=media&token=7cb1c68a-791a-4c54-9f0f-ca64c4ea6d03',
                      project.githubLink)
                  : Offstage(),
            ],
          )
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _buildStoreIcon(String asset, String link) {
    return InkWell(
      onTap: () => _launchURL(link),
      child: Card(
        shape: CircleBorder(),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(4),
          child: FadeInImage.assetNetwork(
            image: asset,
            height: 16,
            width: 16,
            placeholder: 'assets/loading.gif',
          ),
        ),
      ),
    );
  }
}

class DataRow extends StatelessWidget {
  final IconData iconData;
  final String label;
  final String value;
  final bool isVerticalCentered;

  DataRow({
    @required this.iconData,
    @required this.label,
    @required this.value,
    this.isVerticalCentered = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: isVerticalCentered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 24,
            width: 24,
            child: Icon(
              iconData,
              size: 12,
            ),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(100),
                color: Colors.white),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style: Theme.of(context).textTheme.caption.copyWith(color: Colors.grey),
                    softWrap: true,
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black87),
                    softWrap: true,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
