class SocialUserModel{
  late String? name;
  late  String? email;
  late String? phone;
  late String? uId;
  late String? role;
  late String? level;
  late String? image;
  List<String>? course = [];
  SocialUserModel({
    this.name,
    this.email,
    this.phone,
    this.uId,
    this.role,
    this.level,
    this.image,
    this.course,
  });
  SocialUserModel.fromJson(Map<String,dynamic>json){
    name=json['name'];
    email=json['email'];
    phone=json['phone'];
    uId=json['uId'];
    role=json['role'];
    level=json['level'];
    image=json['image'];
    course = List<String>.from(json['course'] ?? []);

  }
  Map<String,dynamic>toMap() {
    return{
      'name':name,
      'email':email,
      'phone':phone,
      'uId':uId,
      'role':role,
      'level':level,
      'image':image,
      'course':course,

    };


  }
}