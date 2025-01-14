import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/question_controller.dart';
import 'package:quizapp/views/admin/admin_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final QuestionController questionController = Get.put(
    QuestionController(category: ''),
  );

  @override
  void initState() {
    super.initState();
    questionController.loadQuestionCategoryFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),
      body: GetBuilder<QuestionController>(
        builder: (controller) {
          return ListView.builder(
            itemCount: controller.savedCategories.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    Get.to(() => AdminScreen(
                      quizCategory: controller.savedCategories[index],
                    ));
                  },
                  leading: const Icon(Icons.question_answer),
                  title: Text(controller.savedCategories[index]),
                  subtitle: Text(controller.savedSubtitle[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialogBox,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDialogBox() {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      title: "Add Quiz",
      content: Column(
        children: [
          TextFormField(
            controller: questionController.categoryTitleController,
            decoration: const InputDecoration(
              hintText: "Enter the category name",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
          TextFormField(
            controller: questionController.categorySubtitleController,
            decoration: const InputDecoration(
              hintText: "Enter the category subtitle",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
      textConfirm: "Create",
      textCancel: "Cancel",
      onConfirm: () {
        questionController.saveQuestionCategoryToSharedPreferences();
        Get.back();
      },
    );
  }
}
