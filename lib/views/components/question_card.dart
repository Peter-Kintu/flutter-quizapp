import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/question_controller.dart';
import 'package:quizapp/models/question_models.dart';
import 'package:quizapp/views/components/option.dart';

class QuestionCard extends GetView<QuestionController> {
  final Question question;

  const QuestionCard({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text(
            question.questions,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: const Color(0xFF101010)),
          ),
          const SizedBox(height: 20),
          ...List.generate(
            question.options.length,
            (index) => Options(
              text: question.options[index],
              index: index,
              press: () => controller.checkAns(question, index),
            ),
          ),
        ],
      ),
    );
  }
}
