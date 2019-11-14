import 'package:flutter/material.dart';
import 'package:mayandro_resume/model/project.dart';
import 'package:mayandro_resume/screens/profile/bloc/bloc_provider.dart';
import 'package:mayandro_resume/common_widgets/page_indicator.dart';
import 'package:mayandro_resume/screens/project_detail/project_detail_page.dart';

class ProjectPager extends StatelessWidget {
  final double scrollPosition;
  final List<ProjectItem> projectList;
  final PageController _pageController;

  ProjectPager({
    @required this.scrollPosition,
    @required this.projectList,
  }) : _pageController = PageController(viewportFraction: 0.5, initialPage: 0, keepPage: false);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.4,
      left: 0,
      right: 0,
      bottom: MediaQuery.of(context).size.height * 0.15,
      child: Opacity(
        opacity: scrollPosition == 0 ? 1 : scrollPosition < 0.3 ? (0.3 - scrollPosition) / 0.7 : 0,
        child: Column(
          children: <Widget>[
            Spacer(),
            _pager(context),
            _pageIndicator(context),
          ],
        ),
      ),
    );
  }

  Widget _pager(BuildContext context) {
    final _bloc = ProfileBlocProvider.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: NotificationListener(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollUpdateNotification) {
            _bloc.detailPagerSink.add(_pageController.page);
          }
          return true;
        },
        child: StreamBuilder<double>(
            stream: _bloc.detailPagerStream,
            builder: (context, snapshot) {
              double pageOffset = snapshot.hasData ? snapshot.data : 0.0;
              return PageView.builder(
                physics: ClampingScrollPhysics(),
                controller: _pageController,
                onPageChanged: (page) {
                  _bloc.detailPagerSelectedPageSink.add(page);
                },
                itemCount: projectList.length,
                itemBuilder: (context, position) {
                  var value = pageOffset - position;
                  value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
                  return ProjectRow(
                    project: projectList[position],
                    scale: value,
                  );
                },
              );
            }),
      ),
    );
  }

  Widget _pageIndicator(BuildContext context) {
    final _bloc = ProfileBlocProvider.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      margin: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: StreamBuilder<int>(
          stream: _bloc.detailPagerSelectedPageStream,
          builder: (context, snapshot) {
            return DotsIndicator(
              dotsCount: projectList.length,
              position: snapshot.hasData ? snapshot.data : 0,
            );
          }),
    );
  }
}

class ProjectRow extends StatelessWidget {
  final ProjectItem project;
  final double scale;

  const ProjectRow({
    Key key,
    this.project,
    this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        if (scale < 1) return;
        Navigator.push(
          context,
          PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, _, __) => ProjectDetailPage(project: project)),
        );
      },
      child: Opacity(
        opacity: scale,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildImage(screenHeight),
            SizedBox(
              width: 12,
            ),
            _buildProjectName(context),
            SizedBox(
              width: 4,
            ),
            _buildStoreLabel(context),
            _buildLabel(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(double screenHeight) {
    return Hero(
      tag: "image-${project.name}",
      child: Card(
        color: Colors.white,
        elevation: 8 * scale,
        shape: CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(24 * scale),
          child: FadeInImage.assetNetwork(
            image: project.avatar,
            height: screenHeight * 0.1 * scale,
            width: screenHeight * 0.1 * scale,
            placeholder: 'assets/loading.gif',
          ),
        ),
      ),
    );
  }

  Widget _buildProjectName(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Hero(
        tag: "name-${project.name}",
        child: Text(
          project.name,
          style: Theme.of(context).textTheme.headline.copyWith(color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildStoreLabel(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Text(
        "(Available on ${project.playStoreLink.isNotEmpty ? 'PlayStore' : project.githubLink.isNotEmpty ? 'GitHub' : ''})",
        style: Theme.of(context).textTheme.caption.copyWith(color: Colors.black87, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildLabel(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Text(
        "Tap to read more ...",
        style: Theme.of(context).textTheme.caption.copyWith(color: Colors.black87),
      ),
    );
  }
}
