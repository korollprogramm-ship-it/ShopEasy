import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../models/faq.dart';
import '../models/message.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('business_agent.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        price REAL NOT NULL,
        image_url TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_name TEXT NOT NULL,
        customer_phone TEXT NOT NULL,
        customer_email TEXT NOT NULL,
        items TEXT NOT NULL,
        total_amount REAL NOT NULL,
        status TEXT NOT NULL DEFAULT 'new',
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE faqs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT NOT NULL,
        answer TEXT NOT NULL,
        category TEXT DEFAULT 'common'
      )
    ''');

    await db.execute('''
      CREATE TABLE chat_messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT NOT NULL,
        is_user INTEGER NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');

    await _insertInitialProducts(db);
    await _insertInitialFaqs(db);
  }

  Future<void> _insertInitialProducts(Database db) async {
    final products = [
      {
        'name': 'Умный планер для бизнеса',
        'description': 'Организуйте задачи и достигайте целей с помощью AI-помощника',
        'price': 990.0,
        'image_url': null,
      },
      {
        'name': 'Анализ рынка',
        'description': 'Глубокий анализ вашей ниши и конкурентов',
        'price': 2990.0,
        'image_url': null,
      },
      {
        'name': 'Консультация с AI-экспертом',
        'description': 'Персональные рекомендации для роста бизнеса',
        'price': 1990.0,
        'image_url': null,
      },
      {
        'name': 'Автоматизация процессов',
        'description': 'Настройка AI-ботов для рутинных задач',
        'price': 4990.0,
        'image_url': null,
      },
      {
        'name': 'Стратегия развития',
        'description': 'Комплексный план на 6 месяцев',
        'price': 7990.0,
        'image_url': null,
      },
    ];

    for (var product in products) {
      await db.insert('products', product);
    }
  }

  Future<void> _insertInitialFaqs(Database db) async {
    final faqs = [
      {
        'question': 'Как оформить заказ?',
        'answer': 'Выберите товар в каталоге, нажмите кнопку оформления, заполните контактные данные и подтвердите заказ.',
        'category': 'ordering',
      },
      {
        'question': 'Какие способы оплаты доступны?',
        'answer': 'Мы принимаем оплату банковской картой и перевод на счет.',
        'category': 'payment',
      },
      {
        'question': 'Как быстро выполняется заказ?',
        'answer': 'Большинство услуг оказываются в течение 1-3 рабочих дней.',
        'category': 'delivery',
      },
      {
        'question': 'Можно ли вернуть деньги?',
        'answer': 'Да, если услуга не была оказана, мы вернем полную стоимость.',
        'category': 'payment',
      },
      {
        'question': 'Как связаться с поддержкой?',
        'answer': 'Используйте чат с AI-помощником или напишите на email support@example.com',
        'category': 'support',
      },
    ];

    for (var faq in faqs) {
      await db.insert('faqs', faq);
    }
  }

  Future<List<Product>> getProducts() async {
    final db = await instance.database;
    final result = await db.query('products');
    return result.map((map) => Product.fromMap(map)).toList();
  }

  Future<int> insertProduct(Product product) async {
    final db = await instance.database;
    return await db.insert('products', product.toMap());
  }

  Future<int> updateProduct(Product product) async {
    final db = await instance.database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await instance.database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await instance.database;
    final result = await db.query(
      'orders',
      orderBy: 'created_at DESC',
    );
    return result;
  }

  Future<int> insertOrder(Order order) async {
    final db = await instance.database;
    final orderData = {
      'customer_name': order.customerName,
      'customer_phone': order.customerPhone,
      'customer_email': order.customerEmail,
      'items': order.items.map((item) => item.toMap()).toList().toString(),
      'total_amount': order.totalAmount,
      'status': order.status,
      'created_at': order.createdAt.toIso8601String(),
    };
    return await db.insert('orders', orderData);
  }

  Future<int> updateOrderStatus(int id, String status) async {
    final db = await instance.database;
    return await db.update(
      'orders',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getNewOrdersCount() async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM orders WHERE status = ?',
      ['new'],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> deleteOldOrders() async {
    final db = await instance.database;
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final result = await db.delete(
      'orders',
      where: 'created_at < ?',
      whereArgs: [thirtyDaysAgo.toIso8601String()],
    );
    return result;
  }

  Future<List<Faq>> getFaqs() async {
    final db = await instance.database;
    final result = await db.query('faqs');
    return result.map((map) => Faq.fromMap(map)).toList();
  }

  Future<int> insertFaq(Faq faq) async {
    final db = await instance.database;
    return await db.insert('faqs', faq.toMap());
  }

  Future<int> deleteFaq(int id) async {
    final db = await instance.database;
    return await db.delete('faqs', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<ChatMessage>> getChatMessages() async {
    final db = await instance.database;
    final result = await db.query(
      'chat_messages',
      orderBy: 'timestamp ASC',
    );
    return result.map((map) => ChatMessage.fromMap(map)).toList();
  }

  Future<int> insertChatMessage(ChatMessage message) async {
    final db = await instance.database;
    return await db.insert('chat_messages', message.toMap());
  }

  Future<int> clearChatHistory() async {
    final db = await instance.database;
    return await db.delete('chat_messages');
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
