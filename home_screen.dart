import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'AI Business Agent',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Consumer<AppState>(
            builder: (context, appState, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.admin_panel_settings, color: Colors.black),
                    onPressed: () => _showAdminDialog(context, appState),
                  ),
                  if (appState.newOrdersCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF4444),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '${appState.newOrdersCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF00FF00).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  children: [
                    Text(
                      '🤖',
                      style: TextStyle(fontSize: 60),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Добро пожаловать!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Привет! Рад помочь с выбором. 😊',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
              label: 'Каталог товаров',
              emoji: '🛍️',
              color: const Color(0xFF00FF00),
              onPressed: () => Navigator.pushNamed(context, '/catalog'),
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: 'FAQ - Вопросы и ответы',
              emoji: '❓',
              color: const Color(0xFFCCCCCC),
              onPressed: () => Navigator.pushNamed(context, '/faq'),
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: 'AI Поддержка',
              emoji: '💬',
              color: const Color(0xFF00FF00),
              onPressed: () => Navigator.pushNamed(context, '/chat'),
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: 'Мои заказы',
              emoji: '📋',
              color: const Color(0xFFCCCCCC),
              onPressed: () => Navigator.pushNamed(context, '/orders'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAdminDialog(BuildContext context, AppState appState) {
    final TextEditingController pinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🔐 Доступ к админ-панели'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Введите ПИН-код'),
            const SizedBox(height: 10),
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'ПИН-код',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (pinController.text == '1234') {
                appState.setAdmin(true);
                Navigator.pop(context);
                Navigator.pushNamed(context, '/admin');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Неверный ПИН-код'),
                    backgroundColor: Color(0xFFFF4444),
                  ),
                );
              }
            },
            child: const Text('Войти'),
          ),
        ],
      ),
    );
  }
}
