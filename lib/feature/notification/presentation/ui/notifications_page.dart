import 'package:citzenapp/feature/notification/data/models/notification_item_model.dart';
import 'package:citzenapp/feature/notification/presentation/bloc/notification_bloc.dart';
import 'package:citzenapp/feature/notification/presentation/bloc/notification_event.dart';
import 'package:citzenapp/feature/notification/presentation/bloc/notification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// استدعاء ملف الـ injection container الخاص بكِ
import 'package:citzenapp/core/service/get_it/injection_container.dart' as di;

// لوحة الألوان الخاصة بكِ
abstract class AppColors {
  static const Color brown = Color(0xffB8A47C);
  static const Color gray = Color(0xff817D7D);
  static const Color lightBrown = Color(0xffB8A57B);
  static const Color extraLightBaieg = Color(0xffF9F6EB);
  static const Color oldBrown = Color(0xffA39A5C);
  static const Color primaryGreen = Color(0xFF0D4633);
  static const Color darkGreen = Color(0xff1B4332);
  static const Color goldenBrown = Color(0xffB3A45F);
  static const Color textGrey = Color(0xff707070);
  static const Color backgroundLight = Color(0xffF7F7F5);
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // تزويد الصفحة بالـ BLoC المسجل في GetIt عند فتح الصفحة
    return BlocProvider<NotificationsBloc>(
      create: (_) => di.sl<NotificationsBloc>()..add(const FetchNotificationsEvent()),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatefulWidget {
  const _NotificationsView();

  @override
  State<_NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<_NotificationsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // ربط مستمع السكرول لتحميل الصفحة التالية فور الاقتراب من نهاية القائمة (Cursor Pagination)
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// التأكد مما إذا وصل المستخدم إلى 90% من طول القائمة لإطلاق طلب الصفحة التالية
  void _onScroll() {
    if (_isBottom) {
      context.read<NotificationsBloc>().add(FetchMoreNotificationsEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return
       Column(
        children: [
          // 1. شريط الفلاتر والإحصائيات العلوي
          _buildFilterHeader(context),

          // 2. قائمة الإشعارات الرئيسية
          Expanded(
            child: BlocBuilder<NotificationsBloc, NotificationsState>(
              builder: (context, state) {
                // حالة التحميل لأول مرة
                if (state is NotificationsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
                  );
                }

                // حالة وجود خطأ
                if (state is NotificationsError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.error_outline_rounded,
                              size: 48,
                              color: Colors.red.shade400,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () {
                              context
                                  .read<NotificationsBloc>()
                                  .add(const FetchNotificationsEvent());
                            },
                            icon: const Icon(Icons.refresh_rounded, size: 18),
                            label: const Text('إعادة المحاولة'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // حالة النجاح واستعراض البيانات
                if (state is NotificationsLoaded) {
                  if (state.items.isEmpty) {
                    return RefreshIndicator(
                      color: AppColors.primaryGreen,
                      onRefresh: () async {
                        context.read<NotificationsBloc>().add(
                              FetchNotificationsEvent(
                                  unread: state.unreadFilter ? true : null),
                            );
                      },
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 120),
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    color: AppColors.extraLightBaieg,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.notifications_off_outlined,
                                    size: 56,
                                    color: AppColors.goldenBrown,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'لا توجد إشعارات حالياً',
                                  style: TextStyle(
                                    color: AppColors.darkGreen,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'سنخطرك فور وجود تحديثات جديدة',
                                  style: TextStyle(
                                    color: AppColors.textGrey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.primaryGreen,
                    onRefresh: () async {
                      context.read<NotificationsBloc>().add(
                            FetchNotificationsEvent(
                                unread: state.unreadFilter ? true : null),
                          );
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(top: 8, bottom: 24),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount:
                          state.items.length + (state.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        // إذا وصل البناء لنهاية القائمة وجارٍ تحميل المزيد، نعرض مؤشر التحميل السفلي
                        if (index >= state.items.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          );
                        }

                        final item = state.items[index];
                        return NotificationItemCard(
                          notification: item,
                          onTap: () {
                            // يمكنكِ إضافة منطق عند الضغط على الإشعار هنا
                          },
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      );
    
  }

  /// ويدجت شريط التصفية والعدّاد العصريه
  Widget _buildFilterHeader(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        final unreadCount =
            (state is NotificationsLoaded) ? state.unreadCount : 0;
        final isUnreadFilter =
            (state is NotificationsLoaded) && state.unreadFilter;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // أزرار التصفية التفاعلية
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    _buildFilterChip(
                      label: 'الكل',
                      isSelected: !isUnreadFilter,
                      onTap: () {
                        context.read<NotificationsBloc>().add(
                              const ToggleUnreadFilterEvent(unreadOnly: false),
                            );
                      },
                    ),
                    const SizedBox(width: 4),
                    _buildFilterChip(
                      label: 'غير المقروءة',
                      isSelected: isUnreadFilter,
                      onTap: () {
                        context.read<NotificationsBloc>().add(
                              const ToggleUnreadFilterEvent(unreadOnly: true),
                            );
                      },
                    ),
                  ],
                ),
              ),

              // شارة عدد الإشعارات غير المقروءة
              if (unreadCount > 0)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryGreen.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$unreadCount غير مقروء',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textGrey,
          ),
        ),
      ),
    );
  }
}

class NotificationItemCard extends StatelessWidget {
  final NotificationItemModel notification;
  final VoidCallback? onTap;

  const NotificationItemCard({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: isUnread ? AppColors.extraLightBaieg : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread
              ? AppColors.lightBrown.withOpacity(0.4)
              : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          if (isUnread)
            BoxShadow(
              color: AppColors.brown.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          else
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. أيقونة نوع الإشعار داخل حاوية عصرية
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: _getBgColorForType(notification.type, isUnread),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIconForType(notification.type),
                    color: _getIconColorForType(notification.type, isUnread),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),

                // 2. تفاصيل الإشعار (العنوان + الرسالة + التاريخ)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isUnread
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: AppColors.darkGreen,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isUnread) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.goldenBrown,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.message,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textGrey,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 13,
                            color: AppColors.gray.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(notification.createdAt),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.gray.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// أيقونة تعبيرية بحسب نوع الإشعار القادم من الباك إند
  IconData _getIconForType(String type) {
    switch (type) {
      case 'transaction_rejected':
        return Icons.cancel_outlined;
      case 'transaction_approved':
        return Icons.check_circle_outline;
      case 'info':
        return Icons.info_outline;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  /// لون الأيقونة بحسب النوع والحالة
  Color _getIconColorForType(String type, bool isUnread) {
    switch (type) {
      case 'transaction_rejected':
        return Colors.red.shade700;
      case 'transaction_approved':
        return AppColors.primaryGreen;
      case 'info':
        return AppColors.goldenBrown;
      default:
        return isUnread ? AppColors.darkGreen : AppColors.gray;
    }
  }

  /// لون خلفية الأيقونة
  Color _getBgColorForType(String type, bool isUnread) {
    switch (type) {
      case 'transaction_rejected':
        return Colors.red.shade50;
      case 'transaction_approved':
        return AppColors.primaryGreen.withOpacity(0.1);
      case 'info':
        return AppColors.goldenBrown.withOpacity(0.15);
      default:
        return isUnread ? Colors.white : Colors.grey.shade100;
    }
  }

  /// تنسيق مبسط للوقت والتاريخ
  String _formatDate(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate).toLocal();
      return '${dateTime.year}/${dateTime.month}/${dateTime.day} - ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoDate;
    }
  }
}