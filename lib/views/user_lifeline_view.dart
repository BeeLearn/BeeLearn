import 'package:beelearn/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserLifeLineView extends StatelessWidget {
  const UserLifeLineView({super.key});

  Widget buildAdsWidget(Widget leading, Widget title, Widget action) {
    return Material(
      borderRadius: BorderRadius.circular(8.0),
      elevation: 2.0,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 8.0,
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  action,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Consumer<UserModel>(
            builder: (context, model, child) {
              final lives = model.value.profile!.lives;
              final hasRanOutOfLives = lives == 0;

              return Wrap(
                direction: Axis.vertical,
                spacing: 16.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        hasRanOutOfLives ? "You ran out of hearts" : "Keeps you learning!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.albertSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ), // You ran out of hearts
                      Text(
                        hasRanOutOfLives ? "Your hearts  will be refill in 4h 57 m" : "You have $lives Hearts. Take on your next Challenge",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 16.0,
                    alignment: WrapAlignment.center,
                    children: [
                      for (int live = 0; live < lives; live++)
                        const Icon(
                          Icons.favorite,
                          size: 48,
                          color: Colors.redAccent,
                        ),
                      for (int live = 0; live < 3 - lives; live++)
                        const Icon(
                          Icons.favorite,
                          size: 48,
                          color: Colors.redAccent,
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 8.0),
          Wrap(
            runSpacing: 16.0,
            children: [
              buildAdsWidget(
                Icon(
                  CupertinoIcons.infinite,
                  color: Colors.amber[700],
                  size: 56,
                ),
                const Text("Become a pro to unlock unlimited learning"),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text("Try for free"),
                ),
              ),
              buildAdsWidget(
                const Stack(
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 56,
                      color: Colors.red,
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const Text("Use your Bits to refill the Hearts."),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text("Refill for 60 bits"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
