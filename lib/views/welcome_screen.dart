import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizapp/utils/constant.dart';
import 'package:quizapp/views/admin/admin_dashboard.dart';
import 'package:quizapp/views/quiz_category.dart';

class WelcomeScreen extends StatelessWidget {
  final TextEditingController userNameController = TextEditingController();

  WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true, // Center the title
        title: const Text(
          "Victorious Primary School Literacy QuizApp",
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2,),
                  const Text(
                    "Let's play Literacy Quiz",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Enter your user name below",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),

                  // User name field with controller
                  TextField(
                    controller: userNameController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.blue,
                      hintText: "Enter user name...",
                      hintStyle: TextStyle(color: Colors.blueGrey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),

                  // Button
                  GestureDetector(
                    onTap: () {
                      final userName = userNameController.text; // Corrected assignment

                      if (userName.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter your user name to proceed.'),
                          ),
                        );
                      } else if (userName == "Admin" || userName == 'admin') {
                        Get.to(() => AdminDashboard());
                      } else {
                        Get.to(
                          () => QuizCategoryScreen(username: userName),
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(kDefaultPadding * 0.75),
                      decoration: const BoxDecoration(
                        gradient: kPrimaryGradient,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Text(
                        "Press to start Literacy Quiz",
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
