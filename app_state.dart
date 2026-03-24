import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../models/faq.dart';
import '../models/message.dart';
import '../services/database_helper.dart';

class AppState with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Product> _products = [];
  List<Map<String, dynamic>> _orders = [];
  List<Faq> _faqs = [];
  List<ChatMessage> _chatMessages = [];
  int _newOrdersCount = 0;
  bool _isAdmin = false;

  List<Product> get products => _products;
  List<Map<String, dynamic>> get orders => _orders;
  List<Faq> get faqs => _faqs;
  List<ChatMessage> get chatMessages => _chatMessages;
  int get newOrdersCount => _newOrdersCount;
  bool get isAdmin => _isAdmin;

  Future<void> initialize() async {
    await _dbHelper.deleteOldOrders();
    await loadProducts();
    await loadOrders();
    await loadFaqs();
    await loadChatMessages();
    await updateNewOrdersCount();
  }

  Future<void> loadProducts() async {
    _products = await _dbHelper.getProducts();
    notifyListeners();
  }

  Future<void> loadOrders() async {
    _orders = await _dbHelper.getOrders();
    notifyListeners();
  }

  Future<void> loadFaqs() async {
    _faqs = await _dbHelper.getFaqs();
    notifyListeners();
  }

  Future<void> loadChatMessages() async {
    _chatMessages = await _dbHelper.getChatMessages();
    notifyListeners();
  }

  Future<void> updateNewOrdersCount() async {
    _newOrdersCount = await _dbHelper.getNewOrdersCount();
    notifyListeners();
  }

  Future<int> addProduct(Product product) async {
    final id = await _dbHelper.insertProduct(product);
    await loadProducts();
    return id;
  }

  Future<int> updateProduct(Product product) async {
    await _dbHelper.updateProduct(product);
    await loadProducts();
    return product.id!;
  }

  Future<int> deleteProduct(int id) async {
    await _dbHelper.deleteProduct(id);
    await loadProducts();
    return id;
  }

  Future<int> addOrder(Order order) async {
    final id = await _dbHelper.insertOrder(order);
    await loadOrders();
    await updateNewOrdersCount();
    return id;
  }

  Future<void> updateOrderStatus(int id, String status) async {
    await _dbHelper.updateOrderStatus(id, status);
    await loadOrders();
    await updateNewOrdersCount();
  }

  Future<int> addFaq(Faq faq) async {
    final id = await _dbHelper.insertFaq(faq);
    await loadFaqs();
    return id;
  }

  Future<int> deleteFaq(int id) async {
    await _dbHelper.deleteFaq(id);
    await loadFaqs();
    return id;
  }

  Future<int> addChatMessage(ChatMessage message) async {
    final id = await _dbHelper.insertChatMessage(message);
    await loadChatMessages();
    return id;
  }

  Future<void> clearChat() async {
    await _dbHelper.clearChatHistory();
    await loadChatMessages();
  }

  Future<int> deleteOldOrders() async {
    final count = await _dbHelper.deleteOldOrders();
    await loadOrders();
    return count;
  }

  void setAdmin(bool isAdmin) {
    _isAdmin = isAdmin;
    notifyListeners();
  }
}
