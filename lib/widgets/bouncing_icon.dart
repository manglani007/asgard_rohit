import 'package:flutter/material.dart';

class BouncingIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color color;
  final void Function()? onTap;
  final bool visible;

  const BouncingIcon({super.key, required this.icon, this.size = 30.0, required this.color, this.onTap, this.visible = true});

  @override
  State<BouncingIcon> createState() => _BouncingIconState();
}

class _BouncingIconState extends State<BouncingIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: InkWell(
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _animation,
          child: Icon(
            widget.icon,
            size: widget.size,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}
