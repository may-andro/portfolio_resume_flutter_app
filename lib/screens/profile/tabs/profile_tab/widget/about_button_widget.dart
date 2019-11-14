import 'package:flutter/material.dart';
import 'package:mayandro_resume/screens/profile/bloc/bloc_provider.dart';

class AboutButton extends StatelessWidget {
  final double scrollPosition;

  AboutButton(this.scrollPosition);

  @override
  Widget build(BuildContext context) {
    final _bloc = ProfileBlocProvider.of(context);
    return Positioned(
      left: 16,
      top: 32,
      child: StreamBuilder<double>(
          stream: _bloc.mainPagerStream,
          builder: (context, snapshot) {
            double scroll = snapshot.hasData ? snapshot.data : 1;
            double opacity = scroll > 1 ? 2 - scroll : scroll < 1 ? scroll : 1;
            return Opacity(
              opacity: opacity,
              child: Opacity(
                opacity: scrollPosition < 0.5 ? (0.5 - scrollPosition) / 0.5 : 0,
                child: IconButton(
                  icon: Icon(Icons.info),
                  color: Colors.white,
                  onPressed: () => scrollPosition == 0 ? goToNextTab(context) : null,
                ),
              ),
            );
          }),
    );
  }

  void goToNextTab(BuildContext context) {
    final _bloc = ProfileBlocProvider.of(context);
    _bloc.getAboutTabData();
    _bloc.pageNavigationSink.add(0);
  }
}
