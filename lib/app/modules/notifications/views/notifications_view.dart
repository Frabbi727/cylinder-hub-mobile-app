import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/values/app_colors.dart';
import '../../../core/values/app_theme_ext.dart';
import '../../../core/widgets/vibrant_app_bar.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          VibrantAppBar(
            title: 'Notifications',
            sub: 'Updates and alerts',
            accent: AppColors.vibrantBlueGradient,
            curve: true,
            onBack: () => Get.back(),
            child: Obx(() {
              if (controller.unreadCount == 0) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: TextButton.icon(
                  onPressed: controller.markAllRead,
                  icon: const Icon(Icons.done_all, color: Colors.white70, size: 16),
                  label: const Text('Mark all read',
                      style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              );
            }),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.notifications.isEmpty) {
                return _buildEmptyState();
              }
              return RefreshIndicator(
                onRefresh: controller.fetchNotifications,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, i) => _buildNotificationCard(context, controller.notifications[i]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, dynamic notification) {
    final isRead = notification.isRead as bool;
    final createdAt = DateTime.tryParse(notification.createdAt ?? '') ?? DateTime.now();
    final timeAgo = _formatTimeAgo(createdAt);

    return InkWell(
      onTap: () => controller.markRead(notification),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead ? null : AppColors.blueBgLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRead ? context.lineColor : AppColors.blue.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isRead ? context.line2Color : AppColors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _iconForType(notification.type),
                color: isRead ? context.text3Color : Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: isRead ? FontWeight.w600 : FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.body,
                    style: TextStyle(fontSize: 13, color: context.text2Color),
                  ),
                  const SizedBox(height: 6),
                  Text(timeAgo, style: TextStyle(fontSize: 11, color: context.text3Color)),
                ],
              ),
            ),
            if (!isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(color: AppColors.blue, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: AppColors.blueBgLight, borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.notifications_none, color: AppColors.blueInk, size: 30),
          ),
          const SizedBox(height: 16),
          const Text('No notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          Builder(builder: (ctx) => Text("You're all caught up!", style: TextStyle(color: ctx.text3Color))),
        ],
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'sale':
        return Icons.shopping_cart;
      case 'due':
        return Icons.account_balance_wallet;
      case 'allocation':
        return Icons.inventory_2;
      default:
        return Icons.notifications;
    }
  }

  String _formatTimeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('d MMM').format(time);
  }
}
