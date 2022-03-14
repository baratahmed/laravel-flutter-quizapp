class QuizDash {
  final int id;
  final String quizName;
  final String description;
  final int questionsNo;
  final Map<String, dynamic> result;
  QuizDash(
      {this.id,
      this.quizName,
      this.description,
      this.questionsNo,
      this.result});
}
