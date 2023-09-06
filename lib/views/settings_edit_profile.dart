import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';

class SettingsEditProfile extends StatefulWidget {
  const SettingsEditProfile({super.key});

  @override
  State<SettingsEditProfile> createState() => _SettingsEditProfile();
}

class _SettingsEditProfile extends State<SettingsEditProfile> {
  late UserModel userModel;
  late TextEditingController usernameTextEditController;
  late TextEditingController emailTextEditController;
  late TextEditingController fullNameTextEditController;

  @override
  void initState() {
    super.initState();

    userModel = Provider.of<UserModel>(
      context,
      listen: false,
    );

    fullNameTextEditController = TextEditingController(text: "Hey Boy");
    emailTextEditController = TextEditingController(text: userModel.user.email);
    usernameTextEditController = TextEditingController(text: userModel.user.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Save"),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Consumer<UserModel>(
              builder: (context, model, child) {
                return Column(
                  children: [
                    Column(
                      children: [
                        const CircleAvatar(
                          maxRadius: 64,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Change profile picture"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: emailTextEditController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: fullNameTextEditController,
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: usernameTextEditController,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
