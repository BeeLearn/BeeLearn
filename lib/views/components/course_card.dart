import 'package:beelearn/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../serializers/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final void Function(Course) onUpdate;

  const CourseCard({
    super.key,
    required this.course,
    required this.onUpdate,
  });

  void intentToModules(BuildContext context) {
    context.push("/modules/?courseId=${course.id}&courseName=${course.name}");
  }

  @override
  Widget build(context) {
    return GestureDetector(
      onTap: () {
        if (course.isEnrolled) {
          return intentToModules(context);
        }

        CourseModel.updateCourse(id: course.id, data: {
          "course_enrolled_users": {
            "add": [course.id]
          },
        }).then((course) {
          onUpdate(course);
          intentToModules(context);
        });
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
