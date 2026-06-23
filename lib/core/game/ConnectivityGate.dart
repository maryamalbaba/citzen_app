import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// ==========================================
// 1. بوابة فحص الاتصال المحسنة (UI المطور)
// ==========================================
class ConnectivityGate extends StatefulWidget {
  final Widget child;
  const ConnectivityGate({super.key, required this.child});

  @override
  State<ConnectivityGate> createState() => _ConnectivityGateState();
}

class _ConnectivityGateState extends State<ConnectivityGate> {
  bool? _hasInternet;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _timer =
        Timer.periodic(const Duration(seconds: 4), (_) => _checkConnection());
  }

  Future<void> _checkConnection() async {
    bool result;
    try {
      final lookup = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 3));
      result = lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
    } catch (_) {
      result = false;
    }
    if (mounted && result != _hasInternet) {
      setState(() => _hasInternet = result);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasInternet == false) {
      return Scaffold(
        backgroundColor: const Color(0xffF8F9FA), // خلفية ناعمة مريحة للعين
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // أيقونة انقطاع الإنترنت بتصميم مودرن
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xff082922).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.wifi_off_rounded,
                        size: 64,
                        color: Color(0xff082922),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'يبدو أنك خارج التغطية!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff082922),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'لا تقلق، يمكنك التسلية بهذه اللعبة حتى يعود الاتصال تلقائياً.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // كابينة اللعبة (Game Cabinet Wrapper)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff082922).withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                        border: Border.all(
                          color: const Color(0xff082922).withOpacity(0.15),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: const DinoGame(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return widget.child;
  }
}

// ==========================================
// 2. كلاس العقبات (المصمم كـ Cactus)
// ==========================================
class _Obstacle {
  double x;
  final double height;
  _Obstacle(this.x, this.height);
}

// ==========================================
// 3. لعبة الديناصور المحسنة (UI المطور)
// ==========================================
class DinoGame extends StatefulWidget {
  const DinoGame({super.key});

  @override
  State<DinoGame> createState() => _DinoGameState();
}

class _DinoGameState extends State<DinoGame>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _lastElapsed = Duration.zero;
  final Random _rand = Random();

  static const double dinoSize = 40; // زيادة الحجم قليلاً لتناسب الإيموجي
  static const double dinoLeft = 30;
  static const double jumpDurationMs = 500;
  static const double maxJumpHeight = 100;
  static const double obstacleWidth = 24;

  bool _started = false;
  bool _gameOver = false;

  double _dinoOffsetY = 0;
  bool _isJumping = false;
  double _jumpElapsedMs = 0;

  final List<_Obstacle> _obstacles = [];
  double _spawnElapsedMs = 0;
  double _nextSpawnGapMs = 1200;
  double _speed = 0.28;

  double _scoreAcc = 0;
  int _score = 0;
  int _best = 0;

  Size _area = Size.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (_area == Size.zero || !_started || _gameOver) return;
    final dt = (elapsed - _lastElapsed).inMicroseconds / 1000.0;
    _lastElapsed = elapsed;

    setState(() {
      if (_isJumping) {
        _jumpElapsedMs += dt;
        if (_jumpElapsedMs >= jumpDurationMs) {
          _isJumping = false;
          _jumpElapsedMs = 0;
          _dinoOffsetY = 0;
        } else {
          final t = _jumpElapsedMs / jumpDurationMs;
          _dinoOffsetY = -maxJumpHeight * sin(pi * t);
        }
      }

      for (final o in _obstacles) {
        o.x -= _speed * dt;
      }
      _obstacles.removeWhere((o) => o.x < -obstacleWidth);

      _spawnElapsedMs += dt;
      if (_spawnElapsedMs >= _nextSpawnGapMs) {
        _spawnElapsedMs = 0;
        _nextSpawnGapMs = 900 + _rand.nextInt(900).toDouble();
        final h = 30.0 + _rand.nextInt(15).toDouble();
        _obstacles.add(_Obstacle(_area.width, h));
      }

      _scoreAcc += dt * _speed * 0.05;
      _score = _scoreAcc.floor();
      _speed = 0.28 + (_score / 800).clamp(0, 0.25);

      final dinoTop = (_area.height - dinoSize) + _dinoOffsetY;
      final dinoRect = Rect.fromLTWH(dinoLeft + 5, dinoTop + 5, dinoSize - 10,
          dinoSize - 5); // تصغير صندوق التصادم لتجربة لعب عادلة

      for (final o in _obstacles) {
        final oRect = Rect.fromLTWH(
          o.x,
          _area.height - o.height,
          obstacleWidth,
          o.height,
        );
        if (dinoRect.overlaps(oRect)) {
          _gameOver = true;
          _ticker.stop();
          if (_score > _best) _best = _score;
          break;
        }
      }
    });
  }

  void _handleTap() {
    if (!_started || _gameOver) {
      setState(() {
        _obstacles.clear();
        _dinoOffsetY = 0;
        _isJumping = false;
        _jumpElapsedMs = 0;
        _spawnElapsedMs = 0;
        _nextSpawnGapMs = 1200;
        _speed = 0.28;
        _scoreAcc = 0;
        _score = 0;
        _started = true;
        _gameOver = false;
      });
      _lastElapsed = Duration.zero;
      _ticker.start();
      return;
    }
    if (!_isJumping) {
      setState(() {
        _isJumping = true;
        _jumpElapsedMs = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _area = Size(constraints.maxWidth, 240); // زيادة الارتفاع قليلاً
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _handleTap,
          child: Container(
            width: double.infinity,
            height: _area.height,
            color: const Color(0xffEDF4F2), // خلفية بيئية للعبة تليق بالديناصور
            child: Stack(
              children: [
                // خط الأرضية بتصميم أكثر نعومة
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 4,
                    color: const Color(0xff082922).withOpacity(0.4),
                  ),
                ),

                // شخصية الديناصور (🦖)
                Positioned(
                  left: dinoLeft,
                  top: (_area.height - dinoSize) + _dinoOffsetY,
                  child: SizedBox(
                    width: dinoSize,
                    height: dinoSize,
                    child: Center(
                      // 🌟 هنا قمنا بعكس الاتجاه أفقياً ليواجه العقبات القادمة من اليمين
                      child: Transform.flip(
                        flipX: true, // تفعيل العكس الأفقي
                        child: const Text(
                          '🦖',
                          style: TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                  ),
                ),

                // العقبات المصممة كـ صبار (🌵)
                ..._obstacles.map(
                  (o) => Positioned(
                    left: o.x,
                    bottom: 4,
                    child: SizedBox(
                      width: obstacleWidth,
                      height: o.height,
                      child: const Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          '🌵',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ),

                // لوحة النقاط العلوية بتصميم شفاف (Glassmorphic)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xff082922).withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '🏆 الأفضل: $_best',
                          style: const TextStyle(
                            color: Color(0xff082922),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '⭐ النقاط: $_score',
                          style: const TextStyle(
                            color: Color(0xff082922),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // واجهة "اضغط للبدء"
                if (!_started)
                  Container(
                    color: Colors.black.withOpacity(0.03),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 10)
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_arrow_rounded,
                                color: Color(0xff082922)),
                            SizedBox(width: 8),
                            Text(
                              'إضغط هنا للبدء والقفز',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff082922),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // واجهة "انتهت اللعبة" المحدثة
                if (_gameOver)
                  Container(
                    color: Colors.black
                        .withOpacity(0.4), // تعتيم الخلفية لتركيز الانتباه
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '💥 اصطدمت بالصبار!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xffB3261E),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'مجموع نقاطك: $_score',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _handleTap,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff082922),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                              icon: const Icon(Icons.refresh_rounded, size: 20),
                              label: const Text('حاول مجدداً'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
