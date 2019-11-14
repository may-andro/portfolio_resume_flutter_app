import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mayandro_resume/model/contact.dart';
import 'package:mayandro_resume/model/profile.dart';
import 'package:mayandro_resume/screens/profile/bloc/bloc_provider.dart';

const widthFactor = 0.7;
const heightFactor = 0.075;
const scaleFactor = 0.5;

class ProfileImageSizeHandler extends StatelessWidget {
  final double scrollPosition;

  ProfileImageSizeHandler(this.scrollPosition);

  @override
  Widget build(BuildContext context) {
    var _bloc = ProfileBlocProvider.of(context);
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.0,
      left: 0,
      right: 0,
      child: StreamBuilder<double>(
          stream: _bloc.mainPagerStream,
          builder: (context, snapshot) {
            double pageViewScroll = snapshot.hasData ? snapshot.data : 1;
            return Transform.scale(
              scale: _getPagerDragScaleOffset(pageViewScroll),
              child: Transform.translate(
                offset: Offset(
                  -_getPagerDragXOffset(pageViewScroll, MediaQuery.of(context).size.width),
                  -_getPagerDragYOffset(pageViewScroll, MediaQuery.of(context).size.height),
                ),
                child: getImageContainer(context),
              ),
            );
          }),
    );
  }

  getImageContainer(BuildContext context) {
    return Transform.scale(
      scale: _getScaleOffset(scrollPosition),
      child: Transform.translate(
        offset: Offset(
          -_getXOffset(scrollPosition, MediaQuery.of(context).size.width),
          -_getYOffset(scrollPosition, MediaQuery.of(context).size.height),
        ),
        child: UserPictureWidget(scrollPosition),
      ),
    );
  }

  double _getPagerDragXOffset(double pageOffset, double width) {
    double xOffset = 0;
    if (pageOffset < 1) {
      xOffset = width * widthFactor * (1 - pageOffset);
    } else if (pageOffset == 1) {
      xOffset = 0;
    } else if (pageOffset > 1) {
      xOffset = -width * widthFactor * (pageOffset - 1);
    }
    return xOffset;
  }

  double _getPagerDragYOffset(double pageOffset, double height) {
    double yOffset = 0;
    if (pageOffset < 1) {
      yOffset = height * heightFactor * (1 - pageOffset);
    } else if (pageOffset == 1) {
      yOffset = 0;
    } else if (pageOffset > 1) {
      yOffset = height * heightFactor * (pageOffset - 1);
    }
    return yOffset;
  }

  double _getPagerDragScaleOffset(double pageOffset) {
    double scale = 1;
    if (pageOffset < 1) {
      scale = 1 - (1 - pageOffset) / 2;
    } else if (pageOffset == 1) {
      scale = 1;
    } else if (pageOffset > 1) {
      scale = 1 - (pageOffset - 1) / 2;
    }
    return scale;
  }

  double _getXOffset(double pageOffset, double width) {
    double xOffset = 0;
    if (pageOffset > 0) {
      xOffset = width * widthFactor * (pageOffset);
    }
    return xOffset;
  }

  double _getYOffset(double pageOffset, double height) {
    double yOffset = 0;
    if (pageOffset <= 1) {
      yOffset = height * heightFactor * pageOffset;
    }
    return yOffset;
  }

  double _getScaleOffset(double pageOffset) {
    double scale = 1;
    if (pageOffset >= 0 && pageOffset <= 1) {
      scale = 1 - pageOffset / 2;
    }
    return scale;
  }
}

class UserPictureWidget extends StatefulWidget {
  final double scrollPosition;

  UserPictureWidget(this.scrollPosition);

  @override
  _UserPictureWidgetState createState() => _UserPictureWidgetState();
}

class _UserPictureWidgetState extends State<UserPictureWidget> with SingleTickerProviderStateMixin {
  AnimationController _profileImageController;
  Animatable<Color> textColor;

  @override
  void initState() {
    super.initState();

    textColor = TweenSequence<Color>([
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.white,
          end: Colors.black,
        ),
      ),
    ]);

    _profileImageController = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _profileImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _profileImageController, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.25,
          child: _getImageContainer(context),
        );
      },
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (textColor
            .evaluate(AlwaysStoppedAnimation(widget.scrollPosition))
            .withOpacity(1 - _profileImageController.value)),
      ),
    );
  }

  _getImageContainer(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        _buildContainer(MediaQuery.of(context).size.shortestSide * 0.35 * _profileImageController.value),
        _buildContainer(MediaQuery.of(context).size.shortestSide * 0.45 * _profileImageController.value),
        _buildContainer(MediaQuery.of(context).size.shortestSide * 0.55 * _profileImageController.value),
        _getNetworkImage(),
      ],
    );
  }

  _getNetworkImage() {
    var _bloc = ProfileBlocProvider.of(context);
    return Container(
      height: MediaQuery.of(context).size.shortestSide * 0.25,
      width: MediaQuery.of(context).size.shortestSide * 0.25,
      child: Material(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        shape: CircleBorder(side: BorderSide(color: Colors.grey.shade200, width: 2)),
        child: StreamBuilder<ProfileItem>(
            stream: _bloc.getProfileStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: Offstage(),
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
              return Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(snapshot.data.avatar),
                )),
              );
            }),
      ),
    );
  }
}
