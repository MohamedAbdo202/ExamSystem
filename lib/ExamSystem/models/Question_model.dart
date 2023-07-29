class QuestionModel {
  late String question;
  late String option1;
  late String option2;
  late String option3;
  late String option4;
  late String correctOption;
  late bool answered;
  String? docId;
  String? keke;

  QuestionModel({
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    required this.correctOption,
    required this.answered,
    this.docId,
    this.keke,
  });

  QuestionModel.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    correctOption = json['option1'];
    answered = false;
    List<String> options = [
      json['option1'],
      json['option2'],
      json['option3'],
      json['option4'],
    ];
    options.shuffle();
    option1 = options[0];
    option2 = options[1];
    option3 = options[2];
    option4 = options[3];
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'option4': option4,
      'correctOption': option1,
      'answered': false,
    };
  }

  List<String> get options => [option1, option2, option3, option4];
}
