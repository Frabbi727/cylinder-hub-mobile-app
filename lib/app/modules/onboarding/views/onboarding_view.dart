import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_theme_ext.dart';
import '../../../core/widgets/lang_pill.dart';
import '../controllers/onboarding_controller.dart';

// ─── strings (en / bn) ──────────────────────────────────────────────────────
class _S {
  static const skip = ['Skip', 'এড়িয়ে যান'];
  static const next = ['Next', 'পরবর্তী'];
  static const start = ['Get Started', 'শুরু করুন'];
  static const s1t = ['Sell in seconds', 'সেকেন্ডে বিক্রি'];
  static const s1d = [
    'Log a cylinder sale on the doorstep — pick the cylinder, set the quantity, take cash, due or partial.',
    'দরজায় দাঁড়িয়েই সিলিন্ডার বিক্রি লিখুন — সিলিন্ডার বাছুন, পরিমাণ দিন, ক্যাশ, বাকি বা আংশিক নিন।',
  ];
  static const s2t = ['Track every cylinder', 'প্রতিটি সিলিন্ডার ট্র্যাক'];
  static const s2d = [
    'See your daily allocation, how much stock is left and the empties you bring back — always in sync.',
    'আজকের বরাদ্দ, কত স্টক বাকি আর ফেরত আনা খালি সিলিন্ডার — সবসময় সিঙ্কে।',
  ];
  static const s3t = ['Collect dues, close the day', 'বাকি আদায়, দিন শেষ'];
  static const s3d = [
    'Chase outstanding payments and hand over your cash with a clean end-of-day reconciliation.',
    'বকেয়া আদায় করুন আর দিন শেষে পরিষ্কার হিসাব মিলিয়ে ক্যাশ জমা দিন।',
  ];
}

// ─── Main view ───────────────────────────────────────────────────────────────
class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return _OnboardingBody(ctrl: controller);
  }
}

class _OnboardingBody extends StatefulWidget {
  final OnboardingController ctrl;
  const _OnboardingBody({required this.ctrl});

  @override
  State<_OnboardingBody> createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends State<_OnboardingBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideCtrl;
  late Animation<Offset> _slideAnim;
  int _prevPage = 0;

  @override
  void initState() {
    super.initState();
    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 420));
    _slideAnim = Tween<Offset>(begin: const Offset(0.06, 0), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _slideCtrl,
            curve: const Cubic(0.22, 0.9, 0.3, 1.0)));
    _slideCtrl.value = 1.0;

    ever(widget.ctrl.currentPage, (int page) {
      if (page != _prevPage) {
        _prevPage = page;
        _slideCtrl.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _slideCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: Column(
        children: [
          // ── Top bar ──
          Padding(
            padding: EdgeInsets.only(
                top: safeTop + 12, left: 20, right: 20, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => LangPill(
                      langCode: widget.ctrl.currentLanguage.value,
                      onToggle: widget.ctrl.toggleLanguage,
                      onDark: false,
                    )),
                Obx(() {
                  final isLast = widget.ctrl.currentPage.value ==
                      OnboardingController.totalPages - 1;
                  return AnimatedOpacity(
                    opacity: isLast ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: GestureDetector(
                      onTap: isLast ? null : widget.ctrl.skip,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 6),
                        child: Obx(() => Text(
                              _S.skip[widget.ctrl.currentLanguage.value == 'bn'
                                  ? 1
                                  : 0],
                              style: TextStyle(
                                color: context.text3Color,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            )),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          // ── Artwork carousel ──
          Expanded(
            child: PageView(
              controller: widget.ctrl.pageController,
              onPageChanged: widget.ctrl.onPageChanged,
              children: const [
                _ArtSell(),
                _ArtTrack(),
                _ArtCollect(),
              ],
            ),
          ),

          // ── Bottom copy + controls ──
          Obx(() {
            final i = widget.ctrl.currentPage.value;
            final lang = widget.ctrl.currentLanguage.value == 'bn' ? 1 : 0;
            final isLast = i == OnboardingController.totalPages - 1;
            final titles = [_S.s1t, _S.s2t, _S.s3t];
            final descs = [_S.s1d, _S.s2d, _S.s3d];

            return Padding(
              padding: EdgeInsets.only(
                left: 26,
                right: 26,
                bottom: MediaQuery.of(context).padding.bottom + 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Slide-in title + desc
                  SlideTransition(
                    position: _slideAnim,
                    child: FadeTransition(
                      opacity: _slideCtrl,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titles[i][lang],
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.025 * 27,
                              color: context.text1Color,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            descs[i][lang],
                            style: TextStyle(
                              fontSize: 15.5,
                              height: 1.5,
                              color: context.text2Color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  // Dots + button
                  Row(
                    children: [
                      // Page dots
                      Row(
                        children: List.generate(
                          OnboardingController.totalPages,
                          (k) => GestureDetector(
                            onTap: () => widget.ctrl.goToPage(k),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 240),
                              margin: const EdgeInsets.only(right: 7),
                              width: k == i ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: k == i
                                    ? AppColors.blue
                                    : context.lineColor,
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),

                      // Next / Get Started
                      GestureDetector(
                        onTap: widget.ctrl.nextPage,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          height: 50,
                          padding: EdgeInsets.symmetric(
                              horizontal: isLast ? 24 : 22),
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.blue.withValues(alpha: 0.32),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isLast ? _S.start[lang] : _S.next[lang],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.arrow_forward_rounded,
                                  color: Colors.white, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Floating artwork wrapper ────────────────────────────────────────────────
class _FloatWidget extends StatefulWidget {
  final Widget child;
  final double amplitude;
  final int durationMs;
  final bool reverse;

  const _FloatWidget({
    required this.child,
    this.amplitude = 8.0,
    this.durationMs = 2200,
    this.reverse = false,
  });

  @override
  State<_FloatWidget> createState() => _FloatWidgetState();
}

class _FloatWidgetState extends State<_FloatWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.durationMs))
      ..repeat(reverse: true);
    _anim = Tween<double>(
      begin: 0.0,
      end: widget.reverse ? widget.amplitude : -widget.amplitude,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) =>
          Transform.translate(offset: Offset(0, _anim.value), child: child),
      child: widget.child,
    );
  }
}

// ─── Slide 1: ArtSell ───────────────────────────────────────────────────────
class _ArtSell extends StatelessWidget {
  const _ArtSell();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;
    final lineColor = isDark ? AppColors.lineDark : AppColors.lineLight;

    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Blob background
            Positioned(
              top: 22,
              left: 22,
              child: Container(
                width: 246,
                height: 246,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3D6BFF), Color(0xFF6C4DF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Opacity(opacity: 0.1, child: Container()),
              ),
            ),

            // Orbit ring
            Positioned(
              top: 50,
              left: 50,
              child: _OrbitRing(size: 200, color: const Color(0xFF3D6BFF)),
            ),

            // Main sale card (floats)
            Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: _FloatWidget(
                amplitude: 8,
                durationMs: 2200,
                child: _SaleCard(cardColor: cardColor, lineColor: lineColor),
              ),
            ),

            // Green badge (floats reverse)
            Positioned(
              top: 30,
              right: 14,
              child: _FloatWidget(
                amplitude: 6,
                durationMs: 1800,
                reverse: true,
                child: _Badge(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF28B866), Color(0xFF138A40)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.shopping_cart_outlined,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaleCard extends StatelessWidget {
  final Color cardColor;
  final Color lineColor;
  const _SaleCard({required this.cardColor, required this.lineColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: lineColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cylinder row
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E5BFF), Color(0xFF1E40D8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('12',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('LPG 12kg',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: context.text1Color)),
                    Text('৳1,450 / pc',
                        style: TextStyle(
                            fontSize: 12,
                            color: context.text2Color)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.greenBgLight,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check,
                        size: 11, color: AppColors.greenInk),
                    const SizedBox(width: 3),
                    Text('Cash',
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.greenInk)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Stepper
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.blueBgLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _StepBtn(icon: Icons.remove, color: AppColors.blueInk),
                const Expanded(
                  child: Center(
                    child: Text('2',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.02,
                            color: AppColors.blueInk)),
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.blue,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _StepBtn({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Icon(icon, size: 20, color: color),
    );
  }
}

// ─── Slide 2: ArtTrack ──────────────────────────────────────────────────────
class _ArtTrack extends StatelessWidget {
  const _ArtTrack();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;
    final lineColor = isDark ? AppColors.lineDark : AppColors.lineLight;

    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 22,
              left: 22,
              child: _OrbitRing(size: 200, color: const Color(0xFF16C7B8)),
            ),

            // 2-col stat cards (float)
            Positioned(
              top: 40,
              left: 20,
              right: 20,
              child: _FloatWidget(
                amplitude: 8,
                durationMs: 2200,
                child: Row(
                  children: [
                    Expanded(
                      child: _MiniStatCard(
                        gradient: AppColors.vibrantBlueGradient,
                        icon: Icons.inventory_2,
                        value: '19',
                        label: 'Sold today',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MiniStatCard(
                        gradient: AppColors.mintGradient,
                        icon: Icons.takeout_dining,
                        value: '15',
                        label: 'Left in van',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Allocation card (float slower)
            Positioned(
              bottom: 20,
              left: 14,
              right: 14,
              child: _FloatWidget(
                amplitude: 6,
                durationMs: 2600,
                reverse: true,
                child: _AllocationCard(
                    cardColor: cardColor, lineColor: lineColor),
              ),
            ),

            // Teal badge
            Positioned(
              top: 30,
              right: 10,
              child: _FloatWidget(
                amplitude: 5,
                durationMs: 1800,
                reverse: false,
                child: _Badge(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF16C7B8), Color(0xFF009E90)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.rotate_left,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final LinearGradient gradient;
  final IconData icon;
  final String value;
  final String label;
  const _MiniStatCard(
      {required this.gradient,
      required this.icon,
      required this.value,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.24),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 16, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(value,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.02)),
          const SizedBox(height: 3),
          Text(label,
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white70)),
        ],
      ),
    );
  }
}

class _AllocationCard extends StatelessWidget {
  final Color cardColor;
  final Color lineColor;
  const _AllocationCard(
      {required this.cardColor, required this.lineColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: lineColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('LPG 12kg',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: context.text1Color)),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: '7 ',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: context.text1Color)),
                    TextSpan(
                        text: 'left',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: context.text3Color)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: 0.62,
              minHeight: 7,
              backgroundColor: lineColor,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.mint),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Slide 3: ArtCollect ────────────────────────────────────────────────────
class _ArtCollect extends StatelessWidget {
  const _ArtCollect();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;
    final lineColor = isDark ? AppColors.lineDark : AppColors.lineLight;

    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 22,
              left: 22,
              child: _OrbitRing(size: 200, color: const Color(0xFFFF8A4B)),
            ),

            // Hero card (float)
            Positioned(
              top: 30,
              left: 16,
              right: 16,
              child: _FloatWidget(
                amplitude: 8,
                durationMs: 2200,
                child: _HeroCard(),
              ),
            ),

            // Customer card (float reverse, lower)
            Positioned(
              bottom: 16,
              left: 14,
              right: 14,
              child: _FloatWidget(
                amplitude: 6,
                durationMs: 2600,
                reverse: true,
                child: _CustomerCard(
                    cardColor: cardColor, lineColor: lineColor),
              ),
            ),

            // Orange badge
            Positioned(
              top: 28,
              right: 10,
              child: _FloatWidget(
                amplitude: 5,
                durationMs: 1800,
                child: _Badge(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF8A5B), Color(0xFFF2632E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icons.receipt_long,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        gradient: AppColors.duesGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF2563E).withValues(alpha: 0.45),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -24,
            top: -24,
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0x24FFFFFF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.account_balance_wallet, size: 14, color: Colors.white70),
                  SizedBox(width: 5),
                  Text('Cash in hand',
                      style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ],
              ),
              const SizedBox(height: 5),
              const Text('৳18,420',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.025,
                      color: Colors.white)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _HeroFoot(label: 'Profit', value: '৳2,140'),
                  const SizedBox(width: 28),
                  _HeroFoot(label: 'Collected', value: '৳9,600'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroFoot extends StatelessWidget {
  final String label;
  final String value;
  const _HeroFoot({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 10.5, fontWeight: FontWeight.w600, color: Colors.white70)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
      ],
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final Color cardColor;
  final Color lineColor;
  const _CustomerCard(
      {required this.cardColor, required this.lineColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: lineColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.orange,
              borderRadius: BorderRadius.circular(99),
            ),
            child: const Center(
              child: Text('KT',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Karim Tea Stall',
                    style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: context.text1Color)),
                Text('Due · ৳1,450',
                    style: TextStyle(
                        fontSize: 11.5, color: context.text2Color)),
              ],
            ),
          ),
          Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Center(
              child: Text('Collect',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared artwork helpers ──────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final LinearGradient gradient;
  final IconData icon;
  const _Badge({required this.gradient, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(icon, size: 24, color: Colors.white),
    );
  }
}

class _OrbitRing extends StatefulWidget {
  final double size;
  final Color color;
  const _OrbitRing({required this.size, required this.color});

  @override
  State<_OrbitRing> createState() => _OrbitRingState();
}

class _OrbitRingState extends State<_OrbitRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 26))
          ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _ctrl,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.color.withValues(alpha: 0.28),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignCenter,
          ),
        ),
      ),
    );
  }
}
