import 'package:flutter/material.dart';
import 'package:mayandro_resume/screens/profile/bloc/bloc_provider.dart';

class LeftBackButton extends StatelessWidget {
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
            return Opacity(
              opacity: scroll > 1.5 ? ((scroll - 1 ) - 0.3) / 0.7 : 0,
              child: IconButton(
                icon: Icon(Icons.close),
                color: Colors.white,
                onPressed: () => _bloc.pageNavigationSink.add(1),
              ),
            );
          }),
    );
  }
}
