import 'package:Taayza/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({
    super.key,
    required this.users,
    required this.color,
    required this.icon, required this.subtitle,
  });

  final RxList<ProfileModel> users;
  final Color color;
  final IconData icon;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final data = users[index];
            return Card(
              elevation: 0,
              color: color,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    icon,
                  ),
                ),
                title: Text(
                  data.name,
                ),
                subtitle: Text('$subtitle${data.totalCourses}'),
              ),
            );
          },
        ),
      ),
    );
  }
}