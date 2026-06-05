import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_theme_ext.dart';
import '../../../core/values/languages/translation_keys.dart';
import '../../../core/widgets/vibrant_app_bar.dart';
import '../../../core/widgets/hero_card.dart';
import '../../../core/widgets/cstat_card.dart';
import '../../../core/widgets/quick_action.dart';
import '../../../core/widgets/cyl_badge.dart';
import '../controllers/my_day_controller.dart';
import '../../main_navigation/controllers/main_navigation_controller.dart';
import '../../../routes/app_pages.dart';

class MyDayView extends GetView<MyDayController> {
  const MyDayView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Column(
          children: [
            VibrantAppBar(
              title: controller.cachedUser?.name.split(' ').first ?? '...',
              sub: 'Salesman · Field App', 
              kicker: controller.greeting.value,
              curve: true,
              tall: true,
              onBell: controller.onNotificationTap,
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: AppHeroCard(
                  icon: Icons.account_balance_wallet,
                  label: TranslationKeys.cashInHand.tr,
                  amount: '৳${controller.stats.value?.totalCashToHandIn.toStringAsFixed(0) ?? '0'}',
                  foot: [
                    HeroFootItem(
                      label: TranslationKeys.todaysProfit.tr, 
                      value: '৳${controller.stats.value?.todayProfit.toStringAsFixed(0) ?? '0'}'
                    ),
                    HeroFootItem(
                      label: TranslationKeys.cashCollected.tr, 
                      value: '৳${controller.stats.value?.cashCollected.toStringAsFixed(0) ?? '0'}'
                    ),
                  ],
                ),
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSyncBanner(),
                    const SizedBox(height: 10),

                    // Stat Grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.1,
                      children: [
                        CStatCard(
                          gradient: AppColors.vibrantBlueGradient,
                          icon: Icons.inventory_2,
                          num: '${controller.stats.value?.totalSold ?? 0}',
                          label: TranslationKeys.totalSold.tr,
                          sub: TranslationKeys.soldSoFar.tr,
                        ),
                        CStatCard(
                          gradient: AppColors.mintGradient,
                          icon: Icons.takeout_dining,
                          num: '${controller.stats.value?.totalRemaining ?? 0}',
                          label: TranslationKeys.cylindersLeft.tr,
                          sub: TranslationKeys.canSell.tr,
                        ),
                        CStatCard(
                          gradient: AppColors.orangeGradient,
                          icon: Icons.timer,
                          num: '৳${controller.stats.value?.todayDueAmount.toStringAsFixed(0) ?? '0'}',
                          label: TranslationKeys.toCollect.tr,
                          sub: '${controller.recentSales.where((s) => s.dueAmount > 0).length} ${TranslationKeys.salesDue.tr}',
                        ),
                        CStatCard(
                          gradient: AppColors.reportsGradient,
                          icon: Icons.rotate_left,
                          num: '${controller.stats.value?.totalReturned ?? 0}',
                          label: TranslationKeys.emptiesBack.tr,
                          sub: TranslationKeys.todaysReturns.tr,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    _buildSectionHeader(TranslationKeys.myStock.tr, ctx: context),
                    const SizedBox(height: 10),
                    Obx(() => Card(
                      child: Column(
                        children: controller.allocations.isEmpty
                          ? [Padding(padding: const EdgeInsets.all(20), child: Text(TranslationKeys.noData.tr))]
                          : controller.allocations.map((a) => _buildStockItem(
                              context: context,
                              name: a.cylinder?.name ?? 'Unknown',
                              size: a.cylinder?.size ?? '',
                              sold: a.soldQty,
                              total: a.qty,
                              c1: Color(int.parse(a.cylinder?.color1?.replaceAll('#', '0xFF') ?? '0xFF2E5BFF')),
                              c2: Color(int.parse(a.cylinder?.color2?.replaceAll('#', '0xFF') ?? '0xFF6C4DF6')),
                              short: a.cylinder?.shortCode ?? '',
                            )).toList(),
                      ),
                    )),

                    const SizedBox(height: 24),
                    _buildSectionHeader(TranslationKeys.quickActions.tr, ctx: context),
                    const SizedBox(height: 10),
                    _buildQuickActionsCard(),

                    const SizedBox(height: 24),
                    _buildRecentSalesHeader(context),
                    const SizedBox(height: 10),
                    Obx(() => Card(
                      child: Column(
                        children: controller.recentSales.isEmpty
                          ? [Padding(padding: const EdgeInsets.all(20), child: Text(TranslationKeys.noData.tr))]
                          : controller.recentSales.map((s) => _buildSaleRow(
                              context: context,
                              saleId: s.id,
                              customer: s.customer?.name ?? TranslationKeys.walkIn.tr,
                              time: s.saleDate,
                              qty: s.items?.first.qty ?? 0,
                              size: s.items?.first.cylinder?.size ?? '',
                              amount: double.tryParse(s.totalAmount) ?? 0,
                              status: s.paymentType,
                              statusColor: s.paymentType == 'cash'
                                ? AppColors.green
                                : (s.paymentType == 'partial' ? AppColors.orange : AppColors.red),
                              c1: Color(int.parse(s.items?.first.cylinder?.color1?.replaceAll('#', '0xFF') ?? '0xFF2E5BFF')),
                              c2: Color(int.parse(s.items?.first.cylinder?.color2?.replaceAll('#', '0xFF') ?? '0xFF6C4DF6')),
                              short: s.items?.first.cylinder?.shortCode ?? '',
                            )).toList(),
                      ),
                    )),
                    
                    const SizedBox(height: 100), // Bottom padding for FAB
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSyncBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.greenBgLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 14, color: AppColors.greenInk),
          const SizedBox(width: 8),
          Text(
            TranslationKeys.synced.tr,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.greenInk,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onAction, String? actionText, BuildContext? ctx}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: ctx != null ? ctx.text3Color : AppColors.text3Light,
            letterSpacing: 0.05,
          ),
        ),
        if (onAction != null)
          TextButton(
            onPressed: onAction,
            child: Row(
              children: [
                Text(
                  actionText ?? '',
                  style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.w700),
                ),
                const Icon(Icons.chevron_right, size: 14, color: AppColors.blue),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStockItem({
    required BuildContext context,
    required String name,
    required String size,
    required int sold,
    required int total,
    required Color c1,
    required Color c2,
    required String short,
  }) {
    final left = total - sold;
    final pct = total > 0 ? sold / total : 0.0;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CylBadge(shortCode: short, color1: c1, color2: c2),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: '$left ', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                          TextSpan(
                            text: TranslationKeys.left.tr,
                            style: TextStyle(fontSize: 12.5, color: context.text3Color, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                LinearProgressIndicator(
                  value: pct,
                  backgroundColor: context.lineColor,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.mint),
                  minHeight: 7,
                  borderRadius: BorderRadius.circular(99),
                ),
                const SizedBox(height: 5),
                Text(
                  '$size · $sold ${TranslationKeys.sold.tr.toLowerCase()} / $total',
                  style: TextStyle(fontSize: 12.5, color: context.text3Color, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 8,
          children: [
            QuickAction(
              icon: Icons.add,
              tintColor: AppColors.blueInk,
              bgColor: AppColors.blueBgLight,
              label: TranslationKeys.newSale.tr,
              onTap: () => Get.find<MainNavigationController>().changeIndex(2),
            ),
            QuickAction(
              icon: Icons.account_balance_wallet,
              tintColor: AppColors.greenInk,
              bgColor: AppColors.greenBgLight,
              label: TranslationKeys.collect.tr,
              onTap: () => Get.find<MainNavigationController>().changeIndex(3),
            ),
            QuickAction(
              icon: Icons.rotate_left,
              tintColor: AppColors.mintInk,
              bgColor: AppColors.mintBgLight,
              label: TranslationKeys.emptyCyl.tr,
              onTap: () => Get.toNamed(Routes.EMPTY_RETURNS),
            ),
            QuickAction(
              icon: Icons.people,
              tintColor: AppColors.purpleInk,
              bgColor: AppColors.purpleBgLight,
              label: TranslationKeys.customers.tr,
              onTap: () => Get.toNamed(Routes.CUSTOMER_LIST),
            ),
            QuickAction(
              icon: Icons.bar_chart,
              tintColor: AppColors.pinkInk,
              bgColor: AppColors.pinkBgLight,
              label: TranslationKeys.myReports.tr,
              onTap: () => Get.find<MainNavigationController>().changeIndex(4),
            ),
            QuickAction(
              icon: Icons.shopping_cart,
              tintColor: AppColors.orangeInk,
              bgColor: AppColors.orangeBgLight,
              label: TranslationKeys.history.tr,
              onTap: () => Get.find<MainNavigationController>().changeIndex(1),
            ),
            QuickAction(
              icon: Icons.send,
              tintColor: AppColors.amberInk,
              bgColor: AppColors.amberBgLight,
              label: TranslationKeys.endOfDay.tr,
              onTap: () => Get.toNamed(Routes.END_OF_DAY),
            ),
            QuickAction(
              icon: Icons.grid_view,
              tintColor: AppColors.redInk,
              bgColor: AppColors.redBgLight,
              label: TranslationKeys.more.tr,
              onTap: () => Get.find<MainNavigationController>().changeIndex(4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSalesHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionHeader(TranslationKeys.recentSales.tr, ctx: context),
        TextButton(
          onPressed: () => Get.find<MainNavigationController>().changeIndex(1),
          child: Row(
            children: [
              Text(
                TranslationKeys.viewAll.tr,
                style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.w700),
              ),
              const Icon(Icons.chevron_right, size: 14, color: AppColors.blue),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaleRow({
    required BuildContext context,
    required int saleId,
    required String customer,
    required String time,
    required int qty,
    required String size,
    required double amount,
    required String status,
    required Color statusColor,
    required Color c1,
    required Color c2,
    required String short,
  }) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.SALE_DETAIL, arguments: saleId),
      child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CylBadge(shortCode: short, color1: c1, color2: c2, size: 38),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customer, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                Text(
                  '$qty × $size · $time',
                  style: TextStyle(fontSize: 13, color: context.text2Color),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '৳${amount.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
