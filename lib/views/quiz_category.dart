import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/controllers/question_controller.dart';
import 'package:quizapp/views/quiz_screen.dart';

class QuizCategoryScreen extends StatefulWidget {
  final String username;
  const QuizCategoryScreen({super.key, required this.username});

  @override
  QuizCategoryScreenState createState() => QuizCategoryScreenState();
}

class QuizCategoryScreenState extends State<QuizCategoryScreen> {
  final QuestionController questionController = Get.put(
    QuestionController(category: ''),
  );

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await questionController.loadQuestionCategoryFromSharedPreferences();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(
        "Building grid with ${questionController.savedCategories.length} items in QuizCategoryScreen.");
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Hello, ${widget.username}! Please pick a literacy quiz card to continue'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: questionController.savedCategories.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: GestureDetector(
                      onTap: () {
                        Get.delete<QuestionController>();
                        Get.to(() => QuizScreen(
                              category:
                                  questionController.savedCategories[index],
                            ));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.question_answer, size: 40.0),
                          const SizedBox(height: 10.0),
                          Text(
                            questionController.savedCategories[index],
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            questionController.savedSubtitle[index],
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
