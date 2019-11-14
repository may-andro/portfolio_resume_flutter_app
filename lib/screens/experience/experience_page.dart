import 'package:flutter/material.dart';
import 'package:mayandro_resume/common_widgets/fluid_top_bar.dart';
import 'package:mayandro_resume/model/experience.dart';
import 'package:url_launcher/url_launcher.dart';

class ExperiencePage extends StatelessWidget {
  final ExperienceItem experience;

  ExperiencePage({@required this.experience});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildTimeline(),
          _buildTopBackground(context),
          _buildBackIcon(context),
          _buildImage(context),
          _buildDataList(context),
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
        tag: "image-${experience.company}",
        child: Material(
            color: Colors.transparent,
            child: Card(
              color: Colors.white,
              elevation: 16,
              shape: CircleBorder(),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: FadeInImage.assetNetwork(
                  image: experience.avatar,
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.height * 0.07,
                  placeholder: 'assets/loading.gif',
                ),
              ),
            )),
      ),
    );
  }

  Widget _buildDataList(BuildContext context) {
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
            _buildName(context),
            InkWell(
              onTap: () => _launchURL(experience.link),
              child: _DataRow(
                iconData: Icons.web_asset,
                label: 'Company website',
                value: experience.link,
              ),
            ),
            _DataRow(
              iconData: Icons.work,
              label: 'Designation',
              value: experience.designation,
            ),
            _DataRow(
              iconData: Icons.access_time,
              label: 'Duration',
              value: experience.duration,
            ),
            _DataRow(
              iconData: Icons.location_on,
              label: 'Location',
              value: experience.location,
            ),
            _DataRow(
              iconData: Icons.description,
              label: 'Job summary',
              value: experience.summary,
              isVerticalCentered: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: "name-${experience.company}",
            child: Material(
              color: Colors.transparent,
              child: Text(
                experience.company,
                style: Theme.of(context).textTheme.headline,
              ),
            ),
          ),
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
}

class _DataRow extends StatelessWidget {
  final IconData iconData;
  final String label;
  final String value;
  final bool isVerticalCentered;

  _DataRow({
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
