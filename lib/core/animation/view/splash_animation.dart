import 'package:flutter/material.dart';

class SplashAnimation extends StatefulWidget {
  const SplashAnimation({super.key});

  @override
  State<SplashAnimation> createState() => _SplashAnimationState();
}

class _SplashAnimationState extends State<SplashAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  Animation<Offset>? _animation;

  int currentIndex = 0;
  final List<String> images = [
    'images/splash_icon1.png',
    'images/splash_icon2.png',
    'images/splash_icon3.png',
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    for (int i = 0; i < images.length; i++) {
      setState(() {
        currentIndex = i;
        _animation = Tween<Offset>(
          begin: Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
      });

      _controller.reset();
      _controller.forward();

      await Future.delayed(Duration(seconds: 3));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_animation == null) {
      return SizedBox.shrink();
    }

    return SlideTransition(
      position: _animation!,
      child: Image.asset(images[currentIndex], width: 300, height: 300),
    );
  }
}
