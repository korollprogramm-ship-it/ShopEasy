import '../models/message.dart';

class AIService {
  Future<String> getResponse(String userMessage) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('заказ') || lowerMessage.contains('оформить')) {
      return 'Чтобы оформить заказ, перейдите в раздел "Каталог", выберите нужный товар и нажмите кнопку "Заказать". 😊 Приятных покупок!';
    } else if (lowerMessage.contains('цена') || lowerMessage.contains('сколько стоит')) {
      return 'Цены на все услуги указаны в каталоге. Вы можете сравнить их и выбрать наиболее подходящий вариант. 💰';
    } else if (lowerMessage.contains('оплата')) {
      return 'Мы принимаем оплату банковской картой и банковским переводом. После оформления заказа менеджер свяжется с вами для подтверждения. 💳';
    } else if (lowerMessage.contains('доставка') || lowerMessage.contains('срок')) {
      return 'Большинство услуг оказываются в течение 1-3 рабочих дней. Для сложных проектов сроки могут быть увеличены. ⏰';
    } else if (lowerMessage.contains('возврат')) {
      return 'Вы можете вернуть полную стоимость, если услуга не была оказана. Для этого напишите нам в поддержку. 💼';
    } else if (lowerMessage.contains('привет') || lowerMessage.contains('здравствуй')) {
      return 'Привет! Рад приветствовать вас! 😊 Я AI-помощник, готов помочь с выбором товаров, ответить на вопросы о заказах и оплате. Чем могу помочь?';
    } else if (lowerMessage.contains('спасибо')) {
      return 'Пожалуйста! Рад был помочь! 🙌 Если возникнут еще вопросы — обращайтесь в любое время!';
    } else if (lowerMessage.contains('помощь') || lowerMessage.contains('помог')) {
      return 'Конечно помогу! Я могу ответить на вопросы о наших товарах, заказах, оплате и сроках. Просто напишите свой вопрос! 🤝';
    } else if (lowerMessage.contains('поддержка')) {
      return 'Наша техподдержка работает с 9:00 до 18:00 по будням. Вы можете также написать нам на email support@example.com 📧';
    } else {
      return 'Спасибо за вопрос! Я постараюсь помочь. 🤔 Уточните, пожалуйста, о каком товаре или услуге вы хотите узнать подробнее? Или воспользуйтесь разделом FAQ для часто задаваемых вопросов.';
    }
  }
}
