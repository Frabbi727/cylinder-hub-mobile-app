import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  static const _pages = [
    _OnboardingPage(
      gradient: AppColors.homeGradient,
      icon: Icons.local_fire_department,
      iconBg: Color(0x33FFFFFF),
      title: 'Welcome to\nCylinderHub',
      description:
          'Your smart salesman portal for managing LPG cylinder sales, stock, and customer dues — all in one place.',
    ),
    _OnboardingPage(
      gradient: AppColors.historyGradient,
      icon: Icons.receipt_long,
      iconBg: Color(0x33FFFFFF),
      title: 'Track Every\nSale Easily',
      description:
          'Record cash, partial, and credit sales in seconds. Monitor outstanding dues and collect payments from customers on the go.',
    ),
    _OnboardingPage(
      gradient: AppColors.eodGradient,
      icon: Icons.task_alt,
      iconBg: Color(0x33FFFFFF),
      title: 'Close Your\nDay in Minutes',
      description:
          'Submit your end-of-day reconciliation, confirm stock returned, and hand in collected cash — simple and accurate.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Page content
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (_, i) => _PageContent(page: _pages[i]),
          ),

          // Skip button (top right)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 20,
            child: Obx(() {
              final isLast = controller.currentPage.value == _pages.length - 1;
              if (isLast) return const SizedBox.shrink();
              return GestureDetector(
                onTap: controller.skip,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }),
          ),

          // Bottom controls
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom + 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Obx(() {
                final page = controller.currentPage.value;
                final isLast = page == _pages.length - 1;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Page indicator dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 280),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == page ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == page
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Primary button
                    GestureDetector(
                      onTap: controller.nextPage,
                      child: Container(
                        height: 58,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          child: isLast
                              ? const Row(
                                  key: ValueKey('start'),
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Get Started',
                                      style: TextStyle(
                                        color: AppColors.blueInk,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded,
                                        color: AppColors.blueInk),
                                  ],
                                )
                              : const Row(
                                  key: ValueKey('next'),
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Next',
                                      style: TextStyle(
                                        color: AppColors.blueInk,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded,
                                        color: AppColors.blueInk),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final LinearGradient gradient;
  final IconData icon;
  final Color iconBg;
  final String title;
  final String description;

  const _OnboardingPage({
    required this.gradient,
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.description,
  });
}

class _PageContent extends StatelessWidget {
  final _OnboardingPage page;

  const _PageContent({required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(gradient: page.gradient),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Icon illustration
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: page.iconBg,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 32,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Icon(page.icon, size: 68, color: Colors.white),
              ),

              const Spacer(flex: 1),

              // Title
              Text(
                page.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.02,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 20),

              // Description
              Text(
                page.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.82),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.55,
                ),
              ),

              // Bottom spacer that leaves room for the controls overlay
              const SizedBox(height: 180),
            ],
          ),
        ),
      ),
    );
  }
}
