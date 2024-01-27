import 'package:flutter/material.dart';

class SpeechBlobArrow extends StatefulWidget {
  @override
  _SpeechBlobArrowState createState() => _SpeechBlobArrowState();
}

class _SpeechBlobArrowState extends State<SpeechBlobArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.35, end: 0.3)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: Image.asset('arrow.png'),
        );
      },
    );
  }
}
