import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/question_controller.dart';
import 'package:quizapp/utils/constant.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  late QuestionController questionController;

  @override
  void initState() {
    super.initState();
    questionController = Get.find<QuestionController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Score",
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: ksecondaryColor),
          ),
          const SizedBox(height: 30),
          Text(
            "${questionController.numOfCorrectAns * 10} / ${questionController.questions.length * 10}",
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: ksecondaryColor),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
