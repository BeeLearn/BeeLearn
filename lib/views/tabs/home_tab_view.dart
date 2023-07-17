import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key}) : super();

  @override
  Widget build(context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            title: Text(
              "BeeLearn",
              style: GoogleFonts.albertSans(
                textStyle: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            actions: [
              Container(
                padding: const EdgeInsets.only(left: 4.0, right: 8.0, top: 2.0, bottom: 2.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).splashColor),
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: const Row(
                  children: [
                    Icon(
                      CupertinoIcons.flame_fill,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text("3"),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none),
              ),
              const CircleAvatar(),
              const SizedBox(width: 8),
            ],
          )
        ];
      },
      body: const Column(),
    );
  }
}
