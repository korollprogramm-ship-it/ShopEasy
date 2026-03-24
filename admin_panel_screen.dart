import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/custom_button.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Provider.of<AppState>(context, listen: false).setAdmin(false);
            Navigator.pop(context);
          },
        ),
        title: const Text(
          '⚙️ Админ-панель',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildStatsCard(appState),
                const SizedBox(height: 20),
                CustomButton(
                  label: 'Очистить старые заказы (>30 дней)',
                  emoji: '🗑️',
                  color: const Color(0xFFFF4444),
                  onPressed: () => _showCleanDialog(context, appState),
                ),
                const SizedBox(height: 20),
                const Text(
                  '📋 Все заказы',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                ...appState.orders.map((order) => _buildOrderCard(order, appState)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCard(AppState appState) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  '📦',
                  '${appState.orders.length}',
                  'Всего заказов',
                ),
                _buildStatItem(
                  '🆕',
                  '${appState.newOrdersCount}',
                  'Новых',
                ),
                _buildStatItem(
                  '🛍️',
                  '${appState.products.length}',
                  'Товаров',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 32),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, AppState appState) {
    final status = order['status'] as String;
    final createdAt = DateTime.parse(order['created_at']);
    final totalAmount = order['total_amount'] as double;
    final customerName = order['customer_name'] as String;
    final customerPhone = order['customer_phone'] as String;
    final customerEmail = order['customer_email'] as String;

    Color statusColor;
    String statusEmoji;
    switch (status) {
      case 'new':
        statusColor = const Color(0xFF00FF00);
        statusEmoji = '🆕';
        break;
      case 'processing':
        statusColor = const Color(0xFFCCCCCC);
        statusEmoji = '⏳';
        break;
      case 'completed':
        statusColor = const Color(0xFF00FF00);
        statusEmoji = '✅';
        break;
      case 'cancelled':
        statusColor = const Color(0xFFFF4444);
        statusEmoji = '❌';
        break;
      default:
        statusColor = const Color(0xFFCCCCCC);
        statusEmoji = '📦';
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Заказ #${order['id']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<String>(
                    value: status,
                    underline: const SizedBox(),
                    icon: const SizedBox(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'new', child: Text('🆕 Новый')),
                      DropdownMenuItem(value: 'processing', child: Text('⏳ В обработке')),
                      DropdownMenuItem(value: 'completed', child: Text('✅ Выполнен')),
                      DropdownMenuItem(value: 'cancelled', child: Text('❌ Отменен')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        appState.updateOrderStatus(order['id'], value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('👤', customerName),
            _buildInfoRow('📱', customerPhone),
            _buildInfoRow('📧', customerEmail),
            const SizedBox(height: 8),
            _buildInfoRow(
              '📅',
              '${createdAt.day}.${createdAt.month}.${createdAt.year} ${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}',
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Сумма: ${totalAmount.toStringAsFixed(0)} ₽',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (status == 'new')
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FF00),
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onPressed: () => appState.updateOrderStatus(order['id'], 'processing'),
                    child: const Text('В работу'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCleanDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🗑️ Очистка заказов'),
        content: const Text(
          'Удалить все заказы старше 30 дней?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4444),
              shape: const StadiumBorder(),
            ),
            onPressed: () async {
              final count = await appState.deleteOldOrders();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Удалено $count старых заказов'),
                    backgroundColor: const Color(0xFF00FF00),
                  ),
                );
              }
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}
