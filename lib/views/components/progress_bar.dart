import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/question_controller.dart';
import 'package:quizapp/utils/constant.dart';

class ProgressBar extends GetView<QuestionController> {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF3F4768), width: 3),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Stack(
        children: [
          _buildProgressIndicator(),
          _buildProgressLabels(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Obx(() => LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * controller.animation.value,
            decoration: BoxDecoration(
              gradient: kPrimaryGradient,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ));
  }

  Widget _buildProgressLabels() {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTimerText(),
            _buildQuestionCounter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerText() {
    return Obx(() => Text(
          "${(controller.animation.value * controller.timePerQuestion).round()} sec",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ));
  }

  Widget _buildQuestionCounter() {
    return Obx(() => Text(
          "${controller.questionNumber}/${controller.questions.length}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}