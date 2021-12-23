class BaseResponse<T> {
  bool status;
  String message;
  T data;

  BaseResponse({this.status, this.message, this.data});

  BaseResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'] is String ? (json['status'] == "success") : json['status'];
    message = json['message'];
    // data = json['data'] != null ? new T.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    // if (this.data != null) {
    //   data['data'] = this.data.toJson();
    // }
    return data;
  }
}

class VerifyResponseModel {
  String phoneNumber;
  bool isNewUser;
  int userId;
  bool isPaidUser;
  String emailId;
  String gender;
  String age;
  String hometown;
  String nativeLanguage;
  String fcmId;
  String dob;
  bool isEnable;
  String usingFluteLifeFor;
  List<String> interest;
  String userDp;
  bool isAdmin;
  String motto;
  String userName;
  String aboutMe;
  Null occupation;

  VerifyResponseModel(
      {this.phoneNumber,
        this.isNewUser,
        this.userId,
        this.isPaidUser,
        this.emailId,
        this.gender,
        this.age,
        this.hometown,
        this.nativeLanguage,
        this.fcmId,
        this.dob,
        this.isEnable,
        this.usingFluteLifeFor,
        this.interest,
        this.userDp,
        this.isAdmin,
        this.motto,
        this.userName,
        this.aboutMe,
        this.occupation});

  VerifyResponseModel.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phone_number'];
    isNewUser = json['is_new_user'];
    userId = json['user_id'];
    isPaidUser = json['is_paid_user'];
    emailId = json['email_id'];
    gender = json['gender'];
    age = json['age'];
    hometown = json['hometown'];
    nativeLanguage = json['native_language'];
    fcmId = json['fcm_id'];
    dob = json['dob'];
    isEnable = json['is_enable'];
    usingFluteLifeFor = json['using_flute_life_for'];
    interest = json['interest'].cast<String>();
    userDp = json['user_dp'];
    isAdmin = json['is_admin'];
    motto = json['motto'];
    userName = json['user_name'];
    aboutMe = json['aboutMe'];
    occupation = json['occupation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone_number'] = this.phoneNumber;
    data['is_new_user'] = this.isNewUser;
    data['user_id'] = this.userId;
    data['is_paid_user'] = this.isPaidUser;
    data['email_id'] = this.emailId;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['hometown'] = this.hometown;
    data['native_language'] = this.nativeLanguage;
    data['fcm_id'] = this.fcmId;
    data['dob'] = this.dob;
    data['is_enable'] = this.isEnable;
    data['using_flute_life_for'] = this.usingFluteLifeFor;
    data['interest'] = this.interest;
    data['user_dp'] = this.userDp;
    data['is_admin'] = this.isAdmin;
    data['motto'] = this.motto;
    data['user_name'] = this.userName;
    data['aboutMe'] = this.aboutMe;
    data['occupation'] = this.occupation;
    return data;
  }
}
