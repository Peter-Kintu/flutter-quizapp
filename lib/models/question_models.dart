class Question {
  final int id;
  final String questions;
  final String category;
  final List<String> options;
  final int answer;

  Question({
    required this.category,
    required this.id,
    required this.questions,
    required this.options,
    required this.answer,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'questions': questions,
        'category': category,
        'options': options,
        'answer': answer,
      };

  factory Question.fromJson(Map<String, dynamic> json) {
    // Handle null values safely
    return Question(
      category: json["category"] ?? '',
      id: json["id"] ?? 0,
      questions: json["questions"] ?? '',
      options: (json["options"] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      answer: json["answer"] ?? 0,
    );
  }
}
