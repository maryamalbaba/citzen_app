// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';

// class DinoGame extends StatefulWidget {
//   const DinoGame({super.key});

//   @override
//   State<DinoGame> createState() => _DinoGameState();
// }

// class _Obstacle {
//   double x;
//   final double height;
//   _Obstacle(this.x, this.height);
// }

// class _DinoGameState extends State<DinoGame>
//     with SingleTickerProviderStateMixin {
//   late final Ticker _ticker;
//   Duration _lastElapsed = Duration.zero;
//   final Random _rand = Random();

//   static const double dinoSize = 34;
//   static const double dinoLeft = 30;
//   static const double jumpDurationMs = 550;
//   static const double maxJumpHeight = 90;
//   static const double obstacleWidth = 20;

//   bool _started = false;
//   bool _gameOver = false;

//   double _dinoOffsetY = 0; // 0 = grounded, negative = in the air
//   bool _isJumping = false;
//   double _jumpElapsedMs = 0;

//   final List<_Obstacle> _obstacles = [];
//   double _spawnElapsedMs = 0;
//   double _nextSpawnGapMs = 1200;
//   double _speed = 0.28; // px per ms

//   double _scoreAcc = 0;
//   int _score = 0;
//   int _best = 0;

//   Size _area = Size.zero;

//   @override
//   void initState() {
//     super.initState();
//     _ticker = createTicker(_onTick);
//   }

//   @override
//   void dispose() {
//     _ticker.dispose();
//     super.dispose();
//   }

//   void _onTick(Duration elapsed) {
//     if (_area == Size.zero || !_started || _gameOver) return;
//     final dt = (elapsed - _lastElapsed).inMicroseconds / 1000.0;
//     _lastElapsed = elapsed;

//     setState(() {
//       if (_isJumping) {
//         _jumpElapsedMs += dt;
//         if (_jumpElapsedMs >= jumpDurationMs) {
//           _isJumping = false;
//           _jumpElapsedMs = 0;
//           _dinoOffsetY = 0;
//         } else {
//           final t = _jumpElapsedMs / jumpDurationMs;
//           _dinoOffsetY = -maxJumpHeight * sin(pi * t);
//         }
//       }

//       for (final o in _obstacles) {
//         o.x -= _speed * dt;
//       }
//       _obstacles.removeWhere((o) => o.x < -obstacleWidth);

//       _spawnElapsedMs += dt;
//       if (_spawnElapsedMs >= _nextSpawnGapMs) {
//         _spawnElapsedMs = 0;
//         _nextSpawnGapMs = 900 + _rand.nextInt(900).toDouble();
//         final h = 26.0 + _rand.nextInt(20).toDouble();
//         _obstacles.add(_Obstacle(_area.width, h));
//       }

//       _scoreAcc += dt * _speed * 0.05;
//       _score = _scoreAcc.floor();
//       _speed = 0.28 + (_score / 800).clamp(0, 0.25);

//       final dinoTop = (_area.height - dinoSize) + _dinoOffsetY;
//       final dinoRect = Rect.fromLTWH(dinoLeft, dinoTop, dinoSize, dinoSize);
//       for (final o in _obstacles) {
//         final oRect = Rect.fromLTWH(
//           o.x,
//           _area.height - o.height,
//           obstacleWidth,
//           o.height,
//         );
//         if (dinoRect.overlaps(oRect)) {
//           _gameOver = true;
//           _ticker.stop();
//           if (_score > _best) _best = _score;
//           break;
//         }
//       }
//     });
//   }

//   void _handleTap() {
//     if (!_started || _gameOver) {
//       setState(() {
//         _obstacles.clear();
//         _dinoOffsetY = 0;
//         _isJumping = false;
//         _jumpElapsedMs = 0;
//         _spawnElapsedMs = 0;
//         _nextSpawnGapMs = 1200;
//         _speed = 0.28;
//         _scoreAcc = 0;
//         _score = 0;
//         _started = true;
//         _gameOver = false;
//       });
//       _lastElapsed = Duration.zero;
//       _ticker.start();
//       return;
//     }
//     if (!_isJumping) {
//       setState(() {
//         _isJumping = true;
//         _jumpElapsedMs = 0;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         _area = Size(constraints.maxWidth, 220);
//         return GestureDetector(
//           behavior: HitTestBehavior.opaque,
//           onTap: _handleTap,
//           child: Container(
//             width: double.infinity,
//             height: _area.height,
//             color: const Color(0xffF4F4F4),
//             child: Stack(
//               children: [
//                 const Positioned(
//                   left: 0,
//                   right: 0,
//                   bottom: 0,
//                   child: SizedBox(height: 2, child: ColoredBox(color: Colors.grey)),
//                 ),
//                 Positioned(
//                   left: dinoLeft,
//                   top: (_area.height - dinoSize) + _dinoOffsetY,
//                   child: Container(
//                     width: dinoSize,
//                     height: dinoSize,
//                     decoration: BoxDecoration(
//                       color: const Color(0xff082922),
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                   ),
//                 ),
//                 ..._obstacles.map(
//                   (o) => Positioned(
//                     left: o.x,
//                     bottom: 2,
//                     child: Container(
//                       width: obstacleWidth,
//                       height: o.height,
//                       color: const Color(0xffB3261E),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 10,
//                   right: 14,
//                   child: Text(
//                     'النقاط: $_score   الأفضل: $_best',
//                     style: const TextStyle(
//                       color: Colors.black54,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 if (!_started)
//                   const Center(
//                     child: Text(
//                       'اضغط للبدء',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 if (_gameOver)
//                   Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           'انتهت اللعبة! النقاط: $_score',
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         const Text('اضغط لإعادة المحاولة'),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }