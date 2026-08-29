
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/empty_state.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.watch<AuthProvider>().user?.uid;
    final service = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: uid == null
          ? const SizedBox()
          : StreamBuilder<List<Map<String, dynamic>>>(
        stream: service.getOrders(uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data!;
          if (orders.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'No orders yet',
              subtitle: 'The first thing you buy will appear here',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, i) {
              final order = orders[i];
              final date = (order['date']).toDate();
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text('Order #${order['id'].toString().substring(0, 6)}'),
                  subtitle: Text(DateFormat('d MMM yyyy - hh:mm a').format(date)),
                  trailing: Text('\$${order['total'].toStringAsFixed(0)}',
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}