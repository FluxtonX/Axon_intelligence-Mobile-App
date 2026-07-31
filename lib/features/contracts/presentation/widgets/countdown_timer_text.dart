import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimerText extends StatefulWidget {
  final DateTime deadline;
  final TextStyle? style;

  const CountdownTimerText({
    super.key,
    required this.deadline,
    this.style,
  });

  @override
  State<CountdownTimerText> createState() => _CountdownTimerTextState();
}

class _CountdownTimerTextState extends State<CountdownTimerText> {
  Timer? _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateTimeLeft();
    });
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    if (!mounted) return;
    setState(() {
      if (widget.deadline.isAfter(now)) {
        _timeLeft = widget.deadline.difference(now);
      } else {
        _timeLeft = Duration.zero;
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    if (d.inSeconds <= 0) return 'Deadline Reached';
    
    final days = d.inDays;
    final hours = d.inHours.remainder(24);
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    
    if (days > 0) {
      return '${days}d ${hours}h ${minutes}m left';
    } else {
      return '${hours.toString().padLeft(2, '0')}h : ${minutes.toString().padLeft(2, '0')}m : ${seconds.toString().padLeft(2, '0')}s left';
    }
  }

  Color _getColor() {
    if (_timeLeft.inSeconds <= 0) return Colors.red;
    if (_timeLeft.inDays < 1) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getColor().withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 16, color: _getColor()),
          const SizedBox(width: 4),
          Text(
            _formatDuration(_timeLeft),
            style: widget.style?.copyWith(color: _getColor()) ?? 
                   TextStyle(color: _getColor(), fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
