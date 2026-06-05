import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/widgets/lang_pill.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return _SplashBody(controller: controller);
  }
}

class _SplashBody extends StatefulWidget {
  final SplashController controller;
  const _SplashBody({required this.controller});

  @override
  State<_SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<_SplashBody> with TickerProviderStateMixin {
  late AnimationController _entranceCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _dotsCtrl;

  late Animation<double> _logoScale;
  late Animation<double> _fadeUp;
  late Animation<double> _glowScale;
  late Animation<double> _glowOpacity;

  @override
  void initState() {
    super.initState();

    // Logo entrance — 700 ms, once
    _entranceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
          parent: _entranceCtrl, curve: const Cubic(0.22, 1.0, 0.3, 1.0)),
    );
    _fadeUp = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _entranceCtrl,
          curve: const Interval(0.30, 1.0, curve: Curves.easeOut)),
    );

    // Glow pulse — 2400 ms repeat
    _glowCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2400))
      ..repeat(reverse: true);
    _glowScale = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
    _glowOpacity = Tween<double>(begin: 0.5, end: 0.85).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

    // Bouncing dots — 1100 ms repeat
    _dotsCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1100))
      ..repeat();

    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _glowCtrl.dispose();
    _dotsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3D6BFF), Color(0xFF6C4DF6)],
          ),
        ),
        child: Stack(
          children: [
            // ── Decorative bloom — top right ──────────────────────────────
            Positioned(
              top: -120,
              right: -110,
              child: Container(
                width: 320,
                height: 320,
                decoration: const BoxDecoration(
                  color: Color(0x1AFFFFFF),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // ── Decorative bloom — bottom left ────────────────────────────
            Positioned(
              bottom: 40,
              left: -90,
              child: Container(
                width: 240,
                height: 240,
                decoration: const BoxDecoration(
                  color: Color(0x1AFFFFFF),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // ── Language toggle — top right ───────────────────────────────
            Positioned(
              top: safeTop + 16,
              right: 16,
              child: Obx(() => LangPill(
                    langCode: widget.controller.currentLanguage.value,
                    onToggle: widget.controller.toggleLanguage,
                    onDark: true,
                  )),
            ),

            // ── Center: logo + wordmark + tagline ─────────────────────────
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with pulsing glow
                  AnimatedBuilder(
                    animation: _entranceCtrl,
                    builder: (context, child) => ScaleTransition(
                      scale: _logoScale,
                      child: AnimatedBuilder(
                        animation: _glowCtrl,
                        builder: (context, child) => Stack(
                          alignment: Alignment.center,
                          children: [
                            // Glow layer
                            Transform.scale(
                              scale: _glowScale.value,
                              child: Opacity(
                                opacity: _glowOpacity.value,
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.white.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(38),
                                  ),
                                ),
                              ),
                            ),
                            // Logo box
                            Container(
                              width: 92,
                              height: 92,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.22),
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.black.withValues(alpha: 0.28),
                                    blurRadius: 40,
                                    offset: const Offset(0, 16),
                                  ),
                                  BoxShadow(
                                    color:
                                        Colors.white.withValues(alpha: 0.40),
                                    blurRadius: 0,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.local_fire_department,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // "Cylinder" white + "Hub" #CFE0FF
                  AnimatedBuilder(
                    animation: _fadeUp,
                    builder: (context, child) => Opacity(
                      opacity: _fadeUp.value,
                      child: const Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.85,
                          ),
                          children: [
                            TextSpan(
                              text: 'Cylinder',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: 'Hub',
                              style: TextStyle(color: Color(0xFFCFE0FF)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Tagline
                  AnimatedBuilder(
                    animation: _fadeUp,
                    builder: (context, child) => Opacity(
                      opacity: _fadeUp.value,
                      child: Obx(() => Text(
                            widget.controller.currentLanguage.value == 'bn'
                                ? 'সেলসম্যান · ফিল্ড অ্যাপ'
                                : 'Salesman · Field App',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),

            // ── Bottom: bounce dots + loading text ────────────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: safeBottom + 54,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _dotsCtrl,
                    builder: (context, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Dot(ctrl: _dotsCtrl, delayFraction: 0.0),
                        const SizedBox(width: 7),
                        _Dot(ctrl: _dotsCtrl, delayFraction: 0.145),
                        const SizedBox(width: 7),
                        _Dot(ctrl: _dotsCtrl, delayFraction: 0.29),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Obx(() => Text(
                        widget.controller.currentLanguage.value == 'bn'
                            ? 'আপনার রুট লোড হচ্ছে…'
                            : 'Loading your route…',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.70),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bouncing dot ──────────────────────────────────────────────────────────────
class _Dot extends StatelessWidget {
  final AnimationController ctrl;
  final double delayFraction;

  const _Dot({required this.ctrl, required this.delayFraction});

  @override
  Widget build(BuildContext context) {
    final end = (delayFraction + 0.55).clamp(0.0, 1.0);
    final anim = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: -6.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 40),
      TweenSequenceItem(
          tween: Tween(begin: -6.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 40),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 20),
    ]).animate(CurvedAnimation(
      parent: ctrl,
      curve: Interval(delayFraction, end),
    ));

    return AnimatedBuilder(
      animation: anim,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, anim.value),
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white
                .withValues(alpha: anim.value < -2 ? 1.0 : 0.55),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
