import 'package:agriglance/Screens/Quiz/quiz_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../constants/quiz_question_card.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'quiz_score.dart';

class QuizQuestions extends StatefulWidget {
  QuizQuestions({this.quizName});

  final String quizName;

  @override
  _QuizQuestionsState createState() => _QuizQuestionsState();
}

class _QuizQuestionsState extends State<QuizQuestions> {
  int numOfQuestions = 0;
  List<String> _options = [];
  var _uid = FirebaseAuth.instance.currentUser != null
      ? FirebaseAuth.instance.currentUser.uid
      : "";

  String _correct = "0";
  String _incorrect = "0";

  Future<void> getNumberQuestions() async {
    List<String> _ques = [];
    final sample = await FirebaseFirestore.instance
        .collection("QuizTestName")
        .doc(widget.quizName)
        .collection("questions")
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                if (doc["isApprovedByAdmin"]) {
                  _ques.add(doc['ques']);
                  numOfQuestions += 1;
                }
              })
            });
  }

  @override
  void initState() {
    // TODO: implement initState
    getNumberQuestions();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Fluttertoast.showToast(
          msg: 'You must attempt the quiz',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return false;
      },
      child: Scaffold(
        floatingActionButton: (FirebaseAuth.instance.currentUser != null)
            ? FloatingActionButton(
                child: Column(
                  children: [
                    Icon(
                      Icons.done,
                      size: 40.0,
                    ),
                    Text(
                      "Submit",
                      style: TextStyle(fontSize: 8.0),
                    )
                  ],
                ),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("attemptedQuiz")
                      .doc(_uid)
                      .collection(widget.quizName)
                      .get()
                      .then((QuerySnapshot querySnapshot) => {
                            querySnapshot.docs.forEach((doc) {
                              if (doc["correct"] != null &&
                                  doc['incorrect'] != null &&
                                  doc['correct'] != "" &&
                                  doc['incorrect'] != "") {
                                setState(() {
                                  _correct = doc["correct"].toString();
                                  _incorrect = doc['incorrect'].toString();
                                });
                              } else {
                                setState(() {
                                  _correct = "0";
                                  _incorrect = "0";
                                });
                              }
                            })
                          });
                  print(
                      "------------------------------------------------------------------");
                  print(numOfQuestions);
                  print(_correct);
                  print(_incorrect);
                  print("------------------------------");

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuizScore(
                                quizName: widget.quizName,
                                numOfQuestions: numOfQuestions,
                                correctAnswers: _correct,
                                incorrectAnswers: _incorrect,
                              )));

                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => QuizHome()));
                })
            : null,
        appBar: AppBar(
          title: Text(widget.quizName),
          centerTitle: true,
        ),
        body: SafeArea(
          top: true,
          bottom: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.03),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("QuizTestName")
                      .doc(widget.quizName)
                      .collection("questions")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final questionNames = snapshot.data.docs;
                    List<QuestionCard> questionsWidgets = [];
                    for (var question in questionNames) {
                      if (question.get("isApprovedByAdmin")) {
                        final questionTest = question.get('ques').toString();
                        final option1 = question.get('option1').toString();
                        final option2 = question.get('option2').toString();
                        final option3 = question.get('option3').toString();
                        final option4 = question.get('option4').toString();
                        final correct = option1;
                        _options.add(option1);
                        _options.add(option2);
                        _options.add(option3);
                        _options.add(option4);
                        _options.shuffle();
                        final questionWidget = QuestionCard(
                          quizName: widget.quizName,
                          question: questionTest,
                          option1: _options[0],
                          option2: _options[1],
                          option3: _options[2],
                          option4: _options[3],
                          correct: correct,
                        );

                        questionsWidgets.add(questionWidget);
                      }
                    }

                    return (ListView(children: questionsWidgets));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
