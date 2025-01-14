import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/question_controller.dart';
import 'package:quizapp/utils/constant.dart';

class Options extends GetView<QuestionController> {
  final String text;
  final int index;
  final VoidCallback press;

  const Options({
    super.key,
    required this.text,
    required this.index,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: _handleTap,
          child: Container(
            margin: const EdgeInsets.only(top: kDefaultPadding),
            padding: const EdgeInsets.all(kDefaultPadding),
            decoration: BoxDecoration(
              border: Border.all(color: _getColor()),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildOptionText()),
                if (_shouldShowIcon()) _buildStatusIcon(),
              ],
            ),
          ),
        ));
  }

  void _handleTap() {
    if (!controller.isAnswered) {
      press();
    }
  }

  Color _getColor() {
    if (!controller.isAnswered) return kGrayColor;

    if (index == controller.correctAns) return kGreenColor;
    if (index == controller.selectedAns) return kRedColor;
    return kGrayColor;
  }

  bool _shouldShowIcon() {
    return controller.isAnswered && _getColor() != kGrayColor;
  }

  Widget _buildOptionText() {
    return Text(
      "${index + 1}. $text",
      style: TextStyle(
        color: _getColor(),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildStatusIcon() {
    return Container(
      height: 26,
      width: 26,
      decoration: BoxDecoration(
        color: _getColor(),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: _getColor()),
      ),
      child: Icon(
        _getColor() == kRedColor ? Icons.close : Icons.done,
        size: 16,
        color: Colors.white,
      ),
    );
  }
}
