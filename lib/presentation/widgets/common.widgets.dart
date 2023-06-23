import 'package:flutter/material.dart';


class MyVerticalPadding extends StatelessWidget {
  const MyVerticalPadding({Key? key, required this.x}) : super(key: key);
  final double x;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: x),
    );
  }
}

class EmptyPadding extends StatelessWidget {
  const EmptyPadding({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(0),
    );
  }
}


class MyNameLogo extends StatelessWidget {
  const MyNameLogo({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/namelogo.png');
  }
}



class MySliverSpace extends StatelessWidget {
  const MySliverSpace({Key? key, required this.x}) : super(key: key);
  final double x;
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (
          context,
          index,
        ) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: x),
          );
        },
        childCount: 1,
      ),
    );
  }
}
