import 'package:beelearn/controllers/controllers.dart';
import 'package:beelearn/services/view_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../middlewares/api_middleware.dart';
import '../models/models.dart';

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

  Future<void> _refillHearts(BuildContext context) async {
    final userModel = Provider.of<UserModel>(
      context,
      listen: false,
    );

    final user = userModel.value;
    final bits = user.profile!.bits;
    final lives = user.profile!.lives;

    if (lives >= 3) {
      showSnackBar(
        leading: const Icon(
          Icons.info,
          color: Colors.redAccent,
        ),
        title: "You have reached the maximum heart refill",
      );

      return;
    }

    if (bits < 60) {
      showSnackBar(
        leading: const Icon(
          Icons.bolt_rounded,
          color: Colors.amber,
        ),
        title: "You have $bits bits, you need ${60 - bits} more!",
      );

      return;
    }

    /// Lazy update
    userController.updateUser(
      id: user.id,
      body: {
        "profile": {
          "lives": lives + 1,
          "bits": bits - 60,
        }
      },
    );

    user.profile!.bits -= 60;
    user.profile!.lives += 1;

    userModel.value = user;

    showSnackBar(
      leading: const Icon(
        Icons.favorite,
        color: Colors.redAccent,
      ),
      title: "An extra life beckons! You have got ${lives + 1} lives left.",
    );
  }

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Selector<UserModel, int>(
            selector: (context, model) => model.value.profile!.lives,
            builder: (context, lives, child) {
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
                      ),
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
                          color: Colors.grey,
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
                  onPressed: () => ViewService.showPremiumDialog(context),
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
                  onPressed: () => _refillHearts(context),
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
