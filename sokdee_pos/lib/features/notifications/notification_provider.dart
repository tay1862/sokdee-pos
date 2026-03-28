import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sokdee_pos/core/network/api_client.dart';

part 'notification_provider.g.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  factory AppNotification.fromJson(Map<String, dynamic> j) => AppNotification(
        id: j['id'] as String,
        title: j['title'] as String,
        body: j['body'] as String,
        createdAt: DateTime.tryParse(j['created_at'] as String? ?? '') ?? DateTime.now(),
        isRead: j['is_read'] as bool? ?? false,
      );
}

@riverpod
Future<List<AppNotification>> notifications(Ref ref) async {
  final client = ref.watch(apiClientProvider);
  final data = await client.get('/notifications');
  final list = data['notifications'] as List<dynamic>? ?? [];
  return list.map((e) => AppNotification.fromJson(e as Map<String, dynamic>)).toList();
}

@riverpod
int unreadCount(Ref ref) {
  final notifs = ref.watch(notificationsProvider).valueOrNull ?? [];
  return notifs.where((n) => !n.isRead).length;
}
