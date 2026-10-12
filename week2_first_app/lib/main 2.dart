import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SnakeGame(),
    );
  }
}

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  static const int gridSize = 16;
  static const int stepMs = 220;

  final List<Offset> _snake = [const Offset(5, 8), const Offset(4, 8), const Offset(3, 8)];
  Offset _direction = const Offset(1, 0);
  Offset _nextDirection = const Offset(1, 0);
  Offset _food = const Offset(10, 6);
  bool _isPlaying = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startGame() {
    _timer = Timer.periodic(const Duration(milliseconds: stepMs), (_) {
      if (!_isPlaying) return;
      setState(() {
        _direction = _nextDirection;
        final head = _snake.first;
        final newHead = head + _direction;

        if (newHead.dx < 0 ||
            newHead.dx >= gridSize ||
            newHead.dy < 0 ||
            newHead.dy >= gridSize ||
            _snake.contains(newHead)) {
          _isPlaying = false;
          return;
        }

        _snake.insert(0, newHead);

        if (newHead == _food) {
          _food = _randomFood();
        } else {
          _snake.removeLast();
        }
      });
    });
  }

  Offset _randomFood() {
    final random = Random();
    Offset food;
    do {
      food = Offset(random.nextInt(gridSize).toDouble(), random.nextInt(gridSize).toDouble());
    } while (_snake.contains(food));
    return food;
  }

  void _onDirectionChanged(Offset direction) {
    if (_direction == -direction) return;
    _nextDirection = direction;
    if (!_isPlaying) {
      _isPlaying = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Snake',
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Score: ${_snake.length - 3}',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy > 0) {
                      _onDirectionChanged(const Offset(0, 1));
                    } else if (details.delta.dy < 0) {
                      _onDirectionChanged(const Offset(0, -1));
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx > 0) {
                      _onDirectionChanged(const Offset(1, 0));
                    } else if (details.delta.dx < 0) {
                      _onDirectionChanged(const Offset(-1, 0));
                    }
                  },
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        for (int y = 0; y < gridSize; y++)
                          for (int x = 0; x < gridSize; x++)
                            Positioned(
                              left: x * (320 / gridSize),
                              top: y * (320 / gridSize),
                              width: 320 / gridSize,
                              height: 320 / gridSize,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white10),
                                ),
                              ),
                            ),
                        for (final cell in _snake)
                          Positioned(
                            left: cell.dx * (320 / gridSize),
                            top: cell.dy * (320 / gridSize),
                            width: 320 / gridSize,
                            height: 320 / gridSize,
                            child: Container(
                              margin: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        Positioned(
                          left: _food.dx * (320 / gridSize),
                          top: _food.dy * (320 / gridSize),
                          width: 320 / gridSize,
                          height: 320 / gridSize,
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _directionButton('↑', const Offset(0, -1)),
                  const SizedBox(width: 12),
                  _directionButton('↓', const Offset(0, 1)),
                  const SizedBox(width: 12),
                  _directionButton('←', const Offset(-1, 0)),
                  const SizedBox(width: 12),
                  _directionButton('→', const Offset(1, 0)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _directionButton(String label, Offset direction) {
    return ElevatedButton(
      onPressed: () => _onDirectionChanged(direction),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        minimumSize: const Size(56, 48),
      ),
      child: Text(label, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}

