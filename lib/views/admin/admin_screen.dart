import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/question_controller.dart';
import 'package:quizapp/models/question_models.dart';

class AdminScreen extends StatelessWidget {
  final String quizCategory;

  AdminScreen({super.key, required this.quizCategory});
  final QuestionController questionController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Questions to $quizCategory"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                controller: questionController.questionControllerText,
                decoration: const InputDecoration(labelText: "Question"),
              ),
              for (var i = 0; i < 4; i++)
                TextFormField(
                  controller: questionController.optionControllers[i],
                  decoration: InputDecoration(labelText: "Option ${i + 1}"),
                ),
              TextFormField(
                controller: questionController.correctAnswerController,
                decoration: const InputDecoration(labelText: "Correct Answer (0 - 3)"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (questionController.questionControllerText.text.isEmpty) {
                    Get.snackbar("Required", "Question field is empty");
                    print("Question field is empty");
                  } else if (questionController.optionControllers[0].text.isEmpty) {
                    Get.snackbar("Required", "Option 1 is empty");
                    print("Option 1 is empty");
                  } else if (questionController.optionControllers[1].text.isEmpty) {
                    Get.snackbar("Required", "Option 2 is empty");
                    print("Option 2 is empty");
                  } else if (questionController.optionControllers[2].text.isEmpty) {
                    Get.snackbar("Required", "Option 3 is empty");
                    print("Option 3 is empty");
                  } else if (questionController.optionControllers[3].text.isEmpty) {
                    Get.snackbar("Required", "Option 4 is empty");
                    print("Option 4 is empty");
                  } else {
                    print("All fields are filled, proceeding to add questions.");
                    addQuestions();
                  }
                },
                child: const Text("Add Questions"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void addQuestions() async {
    try {
      // Validate inputs
      if (questionController.questionControllerText.text.isEmpty) {
        Get.snackbar("Required", "Question field is empty");
        return;
      }
      
      for (var i = 0; i < 4; i++) {
        if (questionController.optionControllers[i].text.isEmpty) {
          Get.snackbar("Required", "Option ${i + 1} is empty");
          return;
        }
      }

      // Get values from controllers
      final String questionText = questionController.questionControllerText.text;
      final List<String> options = questionController.optionControllers
          .map((controller) => controller.text)
          .toList();
      final int correctAnswer =
          int.tryParse(questionController.correctAnswerController.text) ?? 0;

      // Create new question
      final Question newQuestion = Question(
        id: DateTime.now().microsecondsSinceEpoch,
        questions: questionText,
        category: quizCategory,
        options: options,
        answer: correctAnswer,
      );

      // Save question
      await questionController.saveQuestionToSharedPreferences(newQuestion);
      
      // Show success message
      Get.snackbar("Success", "Question Added Successfully");
      
      // Clear form
      questionController.questionControllerText.clear();
      for (var controller in questionController.optionControllers) {
        controller.clear();
      }
      questionController.correctAnswerController.clear();
      
    } catch (e) {
      print("Error adding question: $e");
      Get.snackbar("Error", "Failed to add question");
    }
  }
}
