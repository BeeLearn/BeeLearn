import 'package:beelearn/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../middlewares/api_middleware.dart' show showSnackBar;
import '../models/user_model.dart';

/// Todo make ui more cool
class SettingsEditProfile extends StatefulWidget {
  const SettingsEditProfile({super.key});

  @override
  State<SettingsEditProfile> createState() => _SettingsEditProfile();
}

class _SettingsEditProfile extends State<SettingsEditProfile> {
  late UserModel userModel;
  late TextEditingController usernameTextEditController, emailTextEditController;
  late TextEditingController lastNameTextEditController, firstNameTextEditController;

  @override
  void initState() {
    super.initState();

    userModel = Provider.of<UserModel>(
      context,
      listen: false,
    );

    emailTextEditController = TextEditingController(text: userModel.value.email);
    lastNameTextEditController = TextEditingController(text: userModel.value.lastName);
    firstNameTextEditController = TextEditingController(text: userModel.value.firstName);
    usernameTextEditController = TextEditingController(text: userModel.value.username);
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () async {
                context.loaderOverlay.show();

                final data = {
                  "email": emailTextEditController.text,
                  "last_name": lastNameTextEditController.text,
                  "first_name": firstNameTextEditController.text,
                  "username": usernameTextEditController.text,
                };

                await userController
                    .updateUser(
                  id: userModel.value.id,
                  body: data,
                )
                    .then((user) {
                  userModel.value = user;
                }).onError((error, stackTrace) {
                  showSnackBar(
                    leading: const Icon(Icons.error),
                    title: "An error occur while updating your profile",
                  );
                }).whenComplete(
                  () => context.loaderOverlay.hide(),
                );
              },
              child: const Text("Save"),
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      const CircleAvatar(
                        maxRadius: 64,
                      ),
                      TextButton(
                        onPressed: () async {
                          /// Todo upload image
                          final List<AssetEntity>? result = await AssetPicker.pickAssets(
                            context,
                            pickerConfig: const AssetPickerConfig(
                              maxAssets: 1,
                            ),
                          );
                        },
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
                    controller: firstNameTextEditController,
                    decoration: const InputDecoration(
                      labelText: "First Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: lastNameTextEditController,
                    decoration: const InputDecoration(
                      labelText: "Last Name",
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
