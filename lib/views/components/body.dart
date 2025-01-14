import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/question_controller.dart';
import 'package:quizapp/utils/constant.dart';
import 'package:quizapp/views/components/progress_bar.dart';
import 'package:quizapp/views/components/question_card.dart';

class Body extends GetView<QuestionController> {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBackground(),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: ProgressBar(),
              ),
              const SizedBox(height: kDefaultPadding),
              _buildQuestionCounter(context),
              const Divider(thickness: 1.5),
              const SizedBox(height: kDefaultPadding),
              _buildQuestionPageView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
    );
  }

  Widget _buildQuestionCounter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Obx(
        () => Text.rich(
          TextSpan(
            text: "Question ${controller.questionNumber}",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: ksecondaryColor,
                ),
            children: [
              TextSpan(
                text: "/${controller.questions.length}",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: ksecondaryColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionPageView() {
    return Expanded(
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        onPageChanged: controller.updateQuestionNumber,
        itemCount: controller.questions.length,
        itemBuilder: (context, index) => QuestionCard(
          question: controller.questions[index],
        ),
      ),
    );
  }
}
