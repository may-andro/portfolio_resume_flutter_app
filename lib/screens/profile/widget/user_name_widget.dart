import 'package:flutter/material.dart';
import 'package:mayandro_resume/model/profile.dart';
import 'package:mayandro_resume/screens/profile/bloc/bloc_provider.dart';

const widthFactor = 0.7;
const heightFactor = 0.15;
const scaleFactor = 0.5;

class UserNameWidget extends StatelessWidget {
  final double scrollPosition;
  final Animatable<Color> textColor;

  UserNameWidget(this.scrollPosition)
      : textColor = TweenSequence<Color>([
          TweenSequenceItem(
            weight: 1.0,
            tween: ColorTween(
              begin: Colors.white,
              end: Colors.black,
            ),
          ),
        ]);

  @override
  Widget build(BuildContext context) {
    var _bloc = ProfileBlocProvider.of(context);
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.225,
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
                child: getNameContainer(context),
              ),
            );
          }),
    );
  }

  double _getPagerDragXOffset(double pageOffset, double width) {
    double xOffset = 0;
    if (pageOffset < 1) {
      xOffset = -width * 0.05 * (1 - pageOffset);
    } else if (pageOffset == 1) {
      xOffset = 0;
    } else if (pageOffset > 1) {
      xOffset = width * 0.05 * (pageOffset - 1);
    }
    return xOffset;
  }

  double _getPagerDragYOffset(double pageOffset, double height) {
    double yOffset = 0;
    if (pageOffset < 1) {
      yOffset = height * (1 - pageOffset) * 0.3;
    } else if (pageOffset == 1) {
      yOffset = 0;
    } else if (pageOffset > 1) {
      yOffset = height * (pageOffset - 1) * 0.3;
    }
    return yOffset;
  }

  double _getPagerDragScaleOffset(double pageOffset) {
    double scale = 1;
    if (pageOffset < 1) {
      scale = 1 - (1 - pageOffset) * 0.4;
    } else if (pageOffset == 1) {
      scale = 1;
    } else if (pageOffset > 1) {
      scale = 1 - (pageOffset - 1) * 0.4;
    }
    return scale;
  }

  getNameContainer(BuildContext context) {
    var _bloc = ProfileBlocProvider.of(context);
    return Transform.scale(
      scale: _getScaleOffset(scrollPosition),
      child: Transform.translate(
        offset: Offset(
          -_getXOffset(scrollPosition, MediaQuery.of(context).size.width),
          -_getYOffset(scrollPosition, MediaQuery.of(context).size.height),
        ),
        child: StreamBuilder<ProfileItem>(
            stream: _bloc.getProfileStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Icon(
                    Icons.person,
                    color: Colors.black87,
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

              return snapshot.hasData
                  ? Column(
                      children: <Widget>[
                        Text(
                          snapshot.data.name,
                          style: Theme.of(context).textTheme.display1.copyWith(
                                color: textColor.evaluate(AlwaysStoppedAnimation(scrollPosition)),
                              ),
                        ),
                        Text(
                          snapshot.data.designation,
                          style: Theme.of(context).textTheme.body1.copyWith(
                                color: textColor.evaluate(AlwaysStoppedAnimation(scrollPosition)),
                              ),
                        )
                      ],
                    )
                  : Center(
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(),
                      ),
                    );
            }),
      ),
    );
  }

  double _getXOffset(double pageOffset, double width) {
    double xOffset = 0;
    if (pageOffset > 0) {
      xOffset = -width * 0.05 * (pageOffset);
    }
    return xOffset;
  }

  double _getYOffset(double pageOffset, double height) {
    double yOffset = 0;
    if (pageOffset <= 1) {
      yOffset = height * pageOffset * 0.3;
    }
    return yOffset;
  }

  double _getScaleOffset(double pageOffset) {
    double scale = 1;
    if (pageOffset >= 0 && pageOffset <= 1) {
      scale = 1 - pageOffset * 0.4;
    }
    return scale;
  }
}
