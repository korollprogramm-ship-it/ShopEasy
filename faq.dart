class Faq {
  final int? id;
  final String question;
  final String answer;
  final String category;

  Faq({
    this.id,
    required this.question,
    required this.answer,
    this.category = 'common',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category': category,
    };
  }

  factory Faq.fromMap(Map<String, dynamic> map) {
    return Faq(
      id: map['id'],
      question: map['question'],
      answer: map['answer'],
      category: map['category'],
    );
  }
}
