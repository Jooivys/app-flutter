import 'package:flutter/material.dart';
import 'dart:async';

class AnimatedDiceWidget extends StatefulWidget {
  final int? value;
  final bool isRolling;

  const AnimatedDiceWidget({
    super.key,
    this.value,
    this.isRolling = false,
  });

  @override
  State<AnimatedDiceWidget> createState() => _AnimatedDiceWidgetState();
}

class _AnimatedDiceWidgetState extends State<AnimatedDiceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _bounceAnimation;
  Timer? _randomTimer;
  int _currentValue = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _bounceAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _startRolling();
  }

  void _startRolling() {
    if (widget.isRolling) {
      _randomTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
        if (mounted) {
          setState(() {
            _currentValue = (1 + (timer.tick % 6));
          });
        }
      });
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AnimatedDiceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRolling && !oldWidget.isRolling) {
      _startRolling();
    } else if (!widget.isRolling && oldWidget.isRolling) {
      _controller.stop();
      _controller.reset();
      _randomTimer?.cancel();
      if (widget.value != null) {
        setState(() {
          _currentValue = widget.value!;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _randomTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value,
            child: Transform.translate(
              offset: Offset(0, _bounceAnimation.value),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _currentValue.toString(),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

