import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mayandro_resume/model/contact.dart';
import 'package:mayandro_resume/screens/profile/bloc/bloc_provider.dart';
import 'package:mayandro_resume/utils/color_utility.dart';
import 'package:url_launcher/url_launcher.dart';

const double iconStartSize = 36;
const double iconEndSize = 48;
const double iconStartMarginTop = 16;
const double iconEndMarginTop = 80;
const double iconsVerticalSpacing = 24;
const double iconsHorizontalSpacing = 16;

class DetailsBottomSheetWidget extends StatefulWidget {
  final double scrollPosition;
  final Function toggle;
  final Function handleDragUpdate;
  final Function handleDragEnd;
  final List<ContactItem> contactItemList;

  DetailsBottomSheetWidget({
    @required this.scrollPosition,
    @required this.toggle,
    @required this.handleDragUpdate,
    @required this.handleDragEnd,
    @required this.contactItemList,
  });

  @override
  _DetailsBottomSheetWidgetState createState() => _DetailsBottomSheetWidgetState();
}

class _DetailsBottomSheetWidgetState extends State<DetailsBottomSheetWidget> with SingleTickerProviderStateMixin {
  double lerp(double min, double max) => lerpDouble(min, max, widget.scrollPosition);

  double get headerTopMargin => lerp(32, MediaQuery.of(context).size.height * 0.1);

  double get containerRadius => lerp(32, 0);

  double get profileSummaryTopMargin => lerp(50, MediaQuery.of(context).size.height * 0.175);

  double get openerTopMargin => lerp(16, MediaQuery.of(context).size.height * 0.2);

  double get closerBottomMargin =>
      lerp(MediaQuery.of(context).size.shortestSide * 0.04, MediaQuery.of(context).size.shortestSide * 0.06);

  double get iconSize => lerp(36, iconEndSize);

  double get iconPadding => lerp(8, 12);

  double contactItemTopMargin(int index) =>
      lerp(iconStartMarginTop, iconEndMarginTop + index * (iconsVerticalSpacing + iconEndSize)) + headerTopMargin;

  double contactItemLeftMargin(int index) => lerp(
      (index + 1) * (MediaQuery.of(context).size.width / (widget.contactItemList.length + 2)),
      MediaQuery.of(context).size.width * 0.075);

  double get itemBorderRadius => lerp(64, 128);

  Animatable<Color> background;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  void _initialize() {
    background = TweenSequence<Color>([
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Color(getColorHexFromStr('#000000')),
          end: Colors.white,
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var _bloc = ProfileBlocProvider.of(context);
    return Positioned(
      height: lerp(MediaQuery.of(context).size.height * 0.15, MediaQuery.of(context).size.height),
      left: 0,
      right: 0,
      bottom: 0,
      child: StreamBuilder<double>(
          stream: _bloc.mainPagerStream,
          builder: (context, snapshot) {
            double pageViewScroll = snapshot.hasData ? snapshot.data : 1;
            return Transform.translate(
              offset: getOffsetBasedOnPagerScroll(pageViewScroll),
              child: GestureDetector(
                onTap: widget.toggle,
                onVerticalDragUpdate: widget.handleDragUpdate,
                onVerticalDragEnd: widget.handleDragEnd,
                child: Material(
                  elevation: 32,
                  color: background.evaluate(AlwaysStoppedAnimation(widget.scrollPosition)),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(containerRadius)),
                  child: Stack(
                    children: <Widget>[
                      _openerLine(openerTopMargin),
                      for (ContactItem contactItem in widget.contactItemList) _contactItem(contactItem),
                      for (ContactItem contactItem in widget.contactItemList) _buildDetailItem(contactItem),
                      _closeLine(closerBottomMargin),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _openerLine(double topMargin) {
    return Positioned(
      top: topMargin,
      left: MediaQuery.of(context).size.width * 0.4 + MediaQuery.of(context).size.width * 0.4 * widget.scrollPosition,
      right: MediaQuery.of(context).size.width * 0.4 + MediaQuery.of(context).size.width * 0.4 * widget.scrollPosition,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        height: 2,
      ),
    );
  }

  Widget _closeLine(double margin) {
    return Positioned(
      bottom: margin,
      left: 24,
      right: 24,
      child: Container(
        child: Text('Tap to close', textAlign: TextAlign.center,style: Theme.of(context).textTheme.body2,),
      ),
    );
  }

  Widget _contactItem(ContactItem contactItem) {
    int index = widget.contactItemList.indexOf(contactItem);
    return Positioned(
      top: contactItemTopMargin(index),
      left: contactItemLeftMargin(index),
      height: iconSize,
      width: iconSize,
      child: Material(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        shape: CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(iconPadding),
          child: FadeInImage.assetNetwork(
            image: contactItem.avatar,
            fit: BoxFit.contain,
            placeholder: 'assets/loading.gif',
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(ContactItem contactItem) {
    var _bloc = ProfileBlocProvider.of(context);
    int index = widget.contactItemList.indexOf(contactItem);
    return Positioned(
      top: contactItemTopMargin(index),
      left: contactItemLeftMargin(index) + iconSize,
      right: 0,
      height: iconSize + 8,
      child: AnimatedOpacity(
        opacity: widget.scrollPosition > 0.9 ? doubleTillDecimalPoint((widget.scrollPosition - 0.9) / 0.1, 2) : 0,
        duration: Duration(milliseconds: 0),
        child: InkWell(
          onTap: widget.scrollPosition == 1 ? () => _bloc.launchURL(contactItem.value) : null,
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  contactItem.label,
                  style: Theme.of(context).textTheme.caption,
                ),
                Text(
                  contactItem.value,
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double doubleTillDecimalPoint(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  double getYOffset(double pageOffset, double height) {
    double yOffset = 0;
    if (pageOffset > 0) {
      yOffset = height * pageOffset * 0.25;
    }
    return yOffset;
  }

  Offset getOffsetBasedOnPagerScroll(double pageViewScroll) {
    double yOffset = 0;
    double height = MediaQuery.of(context).size.height;
    if (pageViewScroll < 1) {
      yOffset = height * (1 - pageViewScroll) * 0.3;
    } else if (pageViewScroll == 1) {
      yOffset = 0;
    } else if (pageViewScroll > 1) {
      yOffset = height * (pageViewScroll - 1) * 0.3;
    }
    return Offset(0, yOffset);
  }
}
