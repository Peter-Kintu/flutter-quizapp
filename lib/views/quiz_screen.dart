import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/question_controller.dart';
import 'package:quizapp/views/components/body.dart';
import 'package:quizapp/utils/constants.dart';

class QuizScreen extends StatelessWidget {
  final String category;

  const QuizScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final QuestionController controller = Get.put(
      QuestionController(category: category),
      permanent: true,
    );

    return WillPopScope(
      onWillPop: () async {
        return await _showExitConfirmationDialog(context, controller) ?? false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: kSecondaryColor),
            onPressed: () => _showExitConfirmationDialog(context, controller),
          ),
          actions: [
            Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      "Score: ${controller.numOfCorrectAns * 10}",
                      style: const TextStyle(
                        color: kSecondaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),
            TextButton(
              onPressed: controller.skipQuestion,
              child: const Text(
                "Skip",
                style: TextStyle(color: kSecondaryColor, fontSize: 16),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: const Body(),
      ),
    );
  }

  Future<bool?> _showExitConfirmationDialog(
    BuildContext context,
    QuestionController controller,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text(
            'Are you sure you want to exit? Your progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.resetQuiz();
              Get.back(); // Close dialog
              Get.back(); // Exit quiz
            },
            child: const Text(
              'Exit',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
