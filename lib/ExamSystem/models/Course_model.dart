class CourseModel{
  late String? course_name;
  late String? course_id;
  late String? doctor_id;


  CourseModel({
    this.course_name,
    this.course_id,
    this.doctor_id,

  });
  CourseModel.fromJson(Map<String,dynamic>json){
    course_name=json['course_name'];
    course_id=json['course_id'];
    doctor_id=json['doctor_id'];

  }
  Map<String,dynamic>toMap() {
    return{
      'course_name':course_name,
      'course_id':course_id,
      'doctor_id':doctor_id,

    };


  }
}