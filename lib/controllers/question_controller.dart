import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/models/question_models.dart';
import 'package:quizapp/views/score_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Category property
  final String category;

  // Constructor
  QuestionController({required this.category});

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _animation;
  Animation<double> get animation => _animation;

  // Page controller
  late PageController _pageController;
  PageController get pageController => _pageController;

  // Time related properties
  final _timePerQuestion = 30.obs;
  int get timePerQuestion => _timePerQuestion.value;

  // Question related properties
  final _isAnswered = false.obs;
  final _correctAns = 0.obs;
  final _selectedAns = 0.obs;
  final _numOfCorrectAns = 0.obs;
  final _questionNumber = 1.obs;
  RxList<Question> _questions = <Question>[].obs;
  RxList<Question> _filteredQuestions = <Question>[].obs;

  // Category management
  RxList<String> savedCategories = <String>[].obs;
  RxList<String> savedSubtitle = <String>[].obs;

  // SharedPreferences keys
  static const String _categoryKey = 'category_titles';
  static const String _subtitleKey = 'subtitles';

  // Getters
  bool get isAnswered => _isAnswered.value;
  int get correctAns => _correctAns.value;
  int get selectedAns => _selectedAns.value;
  int get numOfCorrectAns => _numOfCorrectAns.value;
  int get questionNumber => _questionNumber.value;
  List<Question> get questions => _filteredQuestions;

  // Text controllers
  final questionControllerText = TextEditingController();
  final List<TextEditingController> optionControllers =
      List.generate(4, (index) => TextEditingController());
  final correctAnswerController = TextEditingController();
  final categoryTitleController = TextEditingController();
  final categorySubtitleController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    _pageController = PageController();

    _animationController = AnimationController(
      duration: Duration(seconds: timePerQuestion),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1, end: 0).animate(_animationController)
      ..addListener(() {
        update();
      });

    loadQuestionsFromSharedPreferences().then((_) {
      setFilteredQuestions(category);
      _animationController.forward().whenComplete(nextQuestion);
    });
  }

  void updateQuestionNumber(int index) {
    _questionNumber.value = index + 1;
    update();
  }

  void checkAns(Question question, int selectedIndex) {
    _isAnswered.value = true;
    _selectedAns.value = selectedIndex;
    _correctAns.value = question.answer;

    if (selectedIndex == question.answer) {
      _numOfCorrectAns.value++;
    }

    _animationController.stop();
    update();

    Future.delayed(const Duration(seconds: 2), nextQuestion);
  }

  void nextQuestion() {
    if (_questionNumber.value < questions.length) {
      _isAnswered.value = false;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
      );

      _animationController.reset();
      _animationController.forward().whenComplete(nextQuestion);
    } else {
      Get.to(() => const ScorePage());
    }
  }

  void skipQuestion() {
    if (!_isAnswered.value) {
      _animationController.stop();
      nextQuestion();
    }
  }

  Future<void> loadQuestionsFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final questionJson = prefs.getStringList("questions");

    if (questionJson == null || questionJson.isEmpty) {
      _questions.clear();
    } else {
      final loadedQuestions = questionJson
          .map((jsonString) {
            try {
              return Question.fromJson(jsonDecode(jsonString));
            } catch (e) {
              print("Error decoding question: $e");
              return null;
            }
          })
          .whereType<Question>()
          .toList();

      _questions.assignAll(loadedQuestions);
    }
    update();
  }

  Future<void> loadQuestionCategoryFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final categories = prefs.getStringList(_categoryKey) ?? [];
    final subtitles = prefs.getStringList(_subtitleKey) ?? [];

    savedCategories.assignAll(categories);
    savedSubtitle.assignAll(subtitles);
    update();
  }

  Future<void> saveQuestionCategoryToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final categoryTitle = categoryTitleController.text.trim();
    final categorySubtitle = categorySubtitleController.text.trim();

    if (categoryTitle.isNotEmpty && categorySubtitle.isNotEmpty) {
      savedCategories.add(categoryTitle);
      savedSubtitle.add(categorySubtitle);

      await prefs.setStringList(_categoryKey, savedCategories.toList());
      await prefs.setStringList(_subtitleKey, savedSubtitle.toList());

      categoryTitleController.clear();
      categorySubtitleController.clear();
      Get.snackbar('Success', 'Category created successfully');
      update();
    }
  }

  void setFilteredQuestions(String category) {
    final filtered = _questions.where((q) => q.category == category).toList();
    _filteredQuestions.assignAll(filtered);
    _questionNumber.value = 1;
    update();
  }

  void resetQuiz() {
    _questionNumber.value = 1;
    _numOfCorrectAns.value = 0;
    _isAnswered.value = false;
    _animationController.reset();
    _pageController.jumpToPage(0);
    update();
  }

  Future<void> saveQuestionToSharedPreferences(Question question) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final questions = prefs.getStringList("questions") ?? [];

      // Convert the new question to JSON and add it to the list
      questions.add(jsonEncode(question.toJson()));

      // Save the updated list
      await prefs.setStringList("questions", questions);

      // Reload questions to update the in-memory list
      await loadQuestionsFromSharedPreferences();

      // Update filtered questions if category matches
      if (question.category == category) {
        setFilteredQuestions(category);
      }

      update();
    } catch (e) {
      print("Error saving question: $e");
      throw Exception("Failed to save question");
    }
  }

  @override
  void onClose() {
    _animationController.dispose();
    _pageController.dispose();
    questionControllerText.dispose();
    for (var controller in optionControllers) {
      controller.dispose();
    }
    correctAnswerController.dispose();
    categoryTitleController.dispose();
    categorySubtitleController.dispose();
    super.onClose();
  }
}
