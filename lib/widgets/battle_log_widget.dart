import 'package:flutter/material.dart';
import '../models/battle_log.dart';

class BattleLogWidget extends StatelessWidget {
  final List<BattleLogEntry> logs;

  const BattleLogWidget({
    super.key,
    required this.logs,
  });

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const SizedBox.shrink();
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 200,
        minHeight: 150,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.history, size: 18, color: Colors.amber),
                const SizedBox(width: 8),
                const Text(
                  'LOG DE COMBATE',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                const Spacer(),
                Text(
                  '${logs.length} entrada${logs.length != 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          // Log entries
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              reverse: true,
              itemCount: logs.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final log = logs[logs.length - 1 - index];
                return _buildLogEntry(log, index == 0);
              },
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildLogEntry(BattleLogEntry log, bool isLatest) {
    Color textColor;
    IconData icon;

    switch (log.type) {
      case BattleLogType.playerAttack:
        textColor = Colors.green[300]!;
        icon = Icons.arrow_forward;
        break;
      case BattleLogType.enemyAttack:
        textColor = Colors.red[300]!;
        icon = Icons.arrow_back;
        break;
      case BattleLogType.victory:
        textColor = Colors.amber;
        icon = Icons.emoji_events;
        break;
      case BattleLogType.defeat:
        textColor = Colors.red;
        icon = Icons.close;
        break;
      case BattleLogType.gameStart:
        textColor = Colors.blue[300]!;
        icon = Icons.play_arrow;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isLatest ? Colors.amber.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: isLatest
            ? Border.all(color: Colors.amber.withValues(alpha: 0.3), width: 1)
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              log.displayMessage,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
                fontWeight: isLatest ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

