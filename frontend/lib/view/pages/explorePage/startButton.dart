import 'package:flutter/material.dart';

class StartButton extends StatefulWidget {
  final VoidCallback onPressed;
  const StartButton({required this.onPressed, super.key});

  @override
  _StartButtonState createState() => _StartButtonState();
}

class _StartButtonState extends State<StartButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _animation,
        child: SizedBox(
          width: 150,
          height: 50,
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.black,
              elevation: 10,
            ).copyWith(
              backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return Color(0xFF5B5194);
                }
                return Color(0xFF6C62A8);
              }),
            ),
            child: Text(
              '시작하기',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }
}