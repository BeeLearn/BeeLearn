import 'package:beelearn/models/course_model.dart';
import 'package:beelearn/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../serializers/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final void Function()? onTap;
  final void Function(Course)? onUpdate;

  const CourseCard({
    super.key,
    this.onTap,
    this.onUpdate,
    required this.course,
  });

  static void intentToModules(BuildContext context, Course course) {
    context.push("/modules/?course=${course.id}&courseName=${course.name}");
  }

  intent(BuildContext context) {
    (onTap == null) ? intentToModules(context, course) : onTap!();
  }

  @override
  Widget build(context) {
    final userModel = Provider.of<UserModel>(
      context,
      listen: false,
    );

    return InkWell(
      onTap: () async {
        if (course.isEnrolled) {
          intent(context);
        } else {
          intent(context);

          final response = await CourseModel.updateCourse(
            id: course.id,
            data: {
              "course_enrolled_users": {
                "add": [userModel.value.id]
              },
            },
          );

          if (onUpdate != null) onUpdate!(response);
        }
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              course.image,
              fit: BoxFit.cover,
            ),
            if (course.isNew)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25C19B),
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: const Text(
                    "New",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 8.0,
              left: 4.0,
              right: 4.0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        course.name,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
