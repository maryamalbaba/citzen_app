// import 'package:flutter/material.dart';
// import '../../data/models/notification_item_model.dart';

// class NotificationItemCard extends StatelessWidget {
//   final NotificationItemModel notification;
//   final VoidCallback? onTap;

//   const NotificationItemCard({
//     super.key,
//     required this.notification,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isUnread = !notification.isRead;

//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//       elevation: isUnread ? 2 : 0,
//       color: isUnread ? Colors.green.shade50.withOpacity(0.5) : Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(
//           color: isUnread ? Colors.green.shade200 : Colors.grey.shade200,
//           width: 1,
//         ),
//       ),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 1. أيقونة نوع الإشعار
//               CircleAvatar(
//                 radius: 20,
//                 backgroundColor: isUnread
//                     ? Colors.green.shade100
//                     : Colors.grey.shade100,
//                 child: Icon(
//                   _getIconForType(notification.type),
//                   color: isUnread ? Colors.green.shade800 : Colors.grey.shade600,
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 12),

//               // 2. تفاصيل الإشعار (العنوان + الرسالة + التاريخ)
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             notification.title,
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: isUnread
//                                   ? FontWeight.bold
//                                   : FontWeight.w600,
//                               color: Colors.black87,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         if (isUnread)
//                           Container(
//                             width: 8,
//                             height: 8,
//                             decoration: const BoxDecoration(
//                               color: Colors.green,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       notification.message,
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey.shade700,
//                         height: 1.3,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       _formatDate(notification.createdAt),
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: Colors.grey.shade500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   /// أيقونة تعبيرية بحسب نوع الإشعار القادم من الباك إند
//   IconData _getIconForType(String type) {
//     switch (type) {
//       case 'transaction_rejected':
//         return Icons.cancel_outlined;
//       case 'transaction_approved':
//         return Icons.check_circle_outline;
//       case 'info':
//         return Icons.info_outline;
//       default:
//         return Icons.notifications_none;
//     }
//   }

//   /// تنسيق مبسط للوقت والتاريخ
//   String _formatDate(String isoDate) {
//     try {
//       final dateTime = DateTime.parse(isoDate).toLocal();
//       return '${dateTime.year}/${dateTime.month}/${dateTime.day} - ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
//     } catch (_) {
//       return isoDate;
//     }
//   }
// }