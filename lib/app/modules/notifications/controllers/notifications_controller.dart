import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../data/models/notification_model.dart';
import '../repository/notifications_repository.dart';

class NotificationsController extends BaseController {
  final NotificationsRepository repository;

  final notifications = <AppNotification>[].obs;

  NotificationsController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    showLoading();
    try {
      final response = await repository.getNotifications();
      if (response.success && response.data != null) {
        notifications.assignAll(response.data!);
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      hideLoading();
    }
  }

  Future<void> markRead(AppNotification notification) async {
    if (notification.isRead) return;
    try {
      await repository.markRead(notification.id);
      final index = notifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        notifications[index] = AppNotification(
          id: notification.id,
          type: notification.type,
          title: notification.title,
          body: notification.body,
          isRead: true,
          createdAt: notification.createdAt,
        );
      }
    } catch (_) {}
  }

  Future<void> markAllRead() async {
    try {
      await repository.markAllRead();
      notifications.assignAll(
        notifications.map((n) => AppNotification(
          id: n.id,
          type: n.type,
          title: n.title,
          body: n.body,
          isRead: true,
          createdAt: n.createdAt,
        )).toList(),
      );
    } catch (e) {
      handleError(e.toString());
    }
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;
}
