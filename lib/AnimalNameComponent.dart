import 'package:flutter/material.dart';

class AnimalNameComponent extends StatefulWidget {
  final String text;
  final Color? nameColor;
  final Color? nameContainerColor;

  const AnimalNameComponent({
    required this.text,
    required this.nameColor,
    required this.nameContainerColor,
  });

  @override
  _AnimalNameComponentState createState() => _AnimalNameComponentState();
}

class _AnimalNameComponentState extends State<AnimalNameComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Makes the animation repeat in reverse

    _animation = Tween<double>(begin: 0.0, end: 3.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // To start the animation
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
      animation: _animation,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(0.0175)
            ..rotateZ(-0.15708)
            ..translate(20.0, _animation.value)
            ..scale(1.0, 1.0),
          alignment: FractionalOffset.center,
          child: Container(
            margin: EdgeInsets.only(right: 16.0),
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: widget.nameContainerColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(36.0),
                bottomRight: Radius.circular(36.0),
              ),
            ),
            child: Text(
              widget.text,
              style: TextStyle(
                fontFamily: 'Round',
                fontSize: 20.0,
                color: widget.nameColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
