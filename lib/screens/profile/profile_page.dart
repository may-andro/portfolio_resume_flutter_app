import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mayandro_resume/common_widgets/no_data_widget.dart';
import 'package:mayandro_resume/common_widgets/no_internet_access_widget.dart';
import 'package:mayandro_resume/model/contact.dart';
import 'package:mayandro_resume/screens/profile/bloc/profile_bloc.dart';
import 'package:mayandro_resume/screens/profile/tabs/about_tab/about_tab.dart';
import 'package:mayandro_resume/screens/profile/tabs/experience_tab/experience_tab.dart';
import 'package:mayandro_resume/screens/profile/tabs/profile_tab/profile_tab.dart';
import 'package:mayandro_resume/screens/profile/widget/detail_bottom_sheet_widget.dart';
import 'package:mayandro_resume/screens/profile/widget/user_name_widget.dart';
import 'package:mayandro_resume/screens/profile/widget/user_picture_widget.dart';
import 'package:mayandro_resume/utils/connectivity.dart';
import 'bloc/bloc_provider.dart';

const double heightFactor = 0.25;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  PageController _pageController;
  ConnectivityManager _connectivity;
  final ProfileBloc _bloc = ProfileBloc();
  AnimationController _bottomSheetController;

  double get maxHeight => MediaQuery.of(context).size.height;

  @override
  void initState() {
    super.initState();
    _connectivity = ConnectivityManager.instance;
    _connectivity.initialise();
    _pageController = PageController(
      initialPage: 1,
      viewportFraction: 1.0,
    );
    _bloc.pageNavigationStream.listen(_navigateToPage);
    _bottomSheetController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        } else if (state == AnimationStatus.dismissed) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        }
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bottomSheetController.dispose();
    _connectivity.disposeStream();
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProfileBlocProvider(
      bloc: _bloc,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: StreamBuilder<Map>(
              stream: _connectivity.connectivityStream,
              builder: (context, snapshot) {
                Map _source = snapshot.hasData ? snapshot.data : {null: false};
                switch (_source.keys.toList()[0]) {
                  case ConnectivityResult.none:
                    return NoInternetWidget();
                  case ConnectivityResult.mobile:
                    return _buildContent();
                  case ConnectivityResult.wifi:
                    return _buildContent();
                  default:
                    return NoDataWidget();
                }
              }),
        ),
      ),
    );
  }

  _buildContent() {
    return AnimatedBuilder(
      animation: _bottomSheetController,
      builder: (context, child) {
        return Stack(
          children: <Widget>[
            _buildPager(),
            _buildBottomSheet(),
            ProfileImageSizeHandler(_bottomSheetController.value),
            UserNameWidget(_bottomSheetController.value),
          ],
        );
      },
    );
  }

  Widget _buildPager() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollUpdateNotification) {
          _bloc.mainPagerSink.add(_pageController.page);
        }
        return true;
      },
      child: PageView(
        onPageChanged: (pos) {
          _bloc.pageNavigationSink.add(pos);
          _bloc.mainPagerCurrentPage = pos;
        },
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: <Widget>[
          AboutTab(),
          ProfileTab(_bottomSheetController.value),
          ExperienceTab(),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return StreamBuilder<List<ContactItem>>(
        stream: _bloc.getContactStream,
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
                child: Offstage(),
              ),
            );
          }

          return DetailsBottomSheetWidget(
            scrollPosition: _bottomSheetController.value,
            toggle: _toggle,
            handleDragUpdate: _handleDragUpdate,
            handleDragEnd: _handleDragEnd,
            contactItemList: snapshot.data,
          );
        });
  }

  void _toggle() {
    final bool isOpen = _bottomSheetController.status == AnimationStatus.completed;
    _bottomSheetController.fling(velocity: isOpen ? -2 : 2);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _bottomSheetController.value -= details.primaryDelta / maxHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_bottomSheetController.isAnimating || _bottomSheetController.status == AnimationStatus.completed) return;

    final double flingVelocity = details.velocity.pixelsPerSecond.dy / maxHeight;
    if (flingVelocity < 0.0)
      _bottomSheetController.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _bottomSheetController.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _bottomSheetController.fling(velocity: _bottomSheetController.value < 0.5 ? -2.0 : 2.0);
  }

  Future _navigateToPage(int page) async {
    _pageController.animateToPage(page, duration: Duration(milliseconds: 500), curve: Curves.linear);
    _bloc.mainPagerCurrentPage = page;
  }

  Future<bool> _onWillPop() async {
    return false;
  }
}
