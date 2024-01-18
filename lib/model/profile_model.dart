class ProfileModel {
  String name, number, uid, type;
  String? profilePicture;
  String? parentsMail;
  int joiningDate;
  int? totalCourses;
  bool? isAccountApproved;

  ProfileModel({
    required this.name,
    required this.number,
    required this.uid,
    required this.type,
    required this.joiningDate,
    this.totalCourses,
    this.profilePicture,
    this.parentsMail,
    this.isAccountApproved
  });

  set setProfilePicture(String? value) => profilePicture = value;
}
