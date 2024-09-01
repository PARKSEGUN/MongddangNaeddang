import 'package:flutter/material.dart';

class EndButton extends StatefulWidget {
  final VoidCallback onPressed;

  const EndButton({required this.onPressed, super.key});

  @override
  _EndButtonState createState() => _EndButtonState();
}

class _EndButtonState extends State<EndButton> with SingleTickerProviderStateMixin {
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
              backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return Color(0xFF9355D0);
                }
                return Color(0xFF6D3AA3);
              }),
            ),
            child: Text(
              '종료하기',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
      ),
    );
  }
}