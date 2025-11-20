import 'package:flutter/material.dart';

class HpBarWidget extends StatelessWidget {
  final int currentHp;
  final int maxHp;
  final Color color;

  const HpBarWidget({
    super.key,
    required this.currentHp,
    required this.maxHp,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = currentHp / maxHp;
    final isCritical = percentage < 0.3;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$currentHp / $maxHp HP',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            Text(
              '${(percentage * 100).toInt()}%',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(
              isCritical ? Colors.red : color,
            ),
            minHeight: 12,
          ),
        ),
      ],
    );
  }
}

