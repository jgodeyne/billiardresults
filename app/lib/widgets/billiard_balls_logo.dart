import 'package:flutter/material.dart';

/// Custom widget displaying three billiard balls as app logo
class BilliardBallsLogo extends StatelessWidget {
  final double size;
  
  const BilliardBallsLogo({
    super.key,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    final ballSize = size * 0.35;
    
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Left ball (red)
          Positioned(
            left: 0,
            top: size * 0.3,
            child: _BilliardBall(
              size: ballSize,
              color: const Color(0xFFE57373),
              number: '1',
            ),
          ),
          // Right ball (orange)
          Positioned(
            right: 0,
            top: size * 0.3,
            child: _BilliardBall(
              size: ballSize,
              color: const Color(0xFFFFB74D),
              number: '2',
            ),
          ),
          // Top center ball (light blue)
          Positioned(
            left: size * 0.325,
            top: 0,
            child: _BilliardBall(
              size: ballSize,
              color: const Color(0xFF6B9BD1),
              number: '3',
            ),
          ),
        ],
      ),
    );
  }
}

class _BilliardBall extends StatelessWidget {
  final double size;
  final Color color;
  final String number;

  const _BilliardBall({
    required this.size,
    required this.color,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.6,
          height: size * 0.6,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: size * 0.4,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
