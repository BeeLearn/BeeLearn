import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../controllers/user_controller.dart';
import '../middlewares/api_middleware.dart' show showSnackBar;
import '../models/user_model.dart';
import '../views/fragments/dialog_fragment.dart';

/// Todo make ui more cool
class SettingsEditProfile extends StatefulWidget {
  const SettingsEditProfile({super.key});

  @override
  State<SettingsEditProfile> createState() => _SettingsEditProfile();
}

class _SettingsEditProfile extends State<SettingsEditProfile> {
  late final UserModel userModel;
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController usernameTextEditController, emailTextEditController;
  late final TextEditingController lastNameTextEditController, firstNameTextEditController;

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

  Widget _getBody(BuildContext context) {
    return LoaderOverlay(
      overlayOpacity: 0,
      overlayColor: Colors.black45,
      child: Consumer<UserModel>(
        builder: (context, model, child) {
          return Form(
            key: _formKey,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Edit Profile"),
                centerTitle: true,
                actions: [
                  TextButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      context.loaderOverlay.show();

                      final data = {
                        "email": emailTextEditController.text,
                        "last_name": lastNameTextEditController.text,
                        "first_name": firstNameTextEditController.text,
                        "username": usernameTextEditController.text,
                      };
                      try {
                        userModel.value = await userController.updateUser(
                          id: userModel.value.id,
                          body: data,
                        );
                        showSnackBar(
                          leading: Icon(
                            Icons.check_circle_rounded,
                            color: Colors.greenAccent[700],
                          ),
                          title: "Profile updated successfully",
                        );
                      } catch (error, stackTrace) {
                        showSnackBar(
                          leading: const Icon(
                            Icons.error,
                            color: Colors.redAccent,
                          ),
                          title: "An error occur while updating your profile",
                        );

                        rethrow;
                      } finally {
                        context.loaderOverlay.hide();
                      }
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                userModel.value.avatar,
                                width: 80.0,
                                height: 80.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                context.loaderOverlay.show();
                                final List<AssetEntity>? result = await AssetPicker.pickAssets(
                                  context,
                                  pickerConfig: const AssetPickerConfig(
                                    maxAssets: 1,
                                  ),
                                );

                                if (result != null && result.isNotEmpty) {
                                  final File file = (await result[0].file)!;

                                  userModel.value = await userController.updateMultipartUser(
                                    id: userModel.value.id,
                                    multipartFiles: [
                                      await MultipartFile.fromPath(
                                        "avatar",
                                        file.path,
                                        contentType: MediaType.parse(result[0].mimeType!),
                                      ),
                                    ],
                                  ).onError(
                                    (error, stackTrace) {
                                      log(
                                        "Upload error",
                                        error: error,
                                        stackTrace: stackTrace,
                                      );

                                      return Future.error(error!);
                                    },
                                  ).whenComplete(() => context.loaderOverlay.hide());
                                }
                              },
                              child: const Text("Change profile picture"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: emailTextEditController,
                          validator: ValidationBuilder().required().email().build(),
                          decoration: const InputDecoration(
                            labelText: "Email",
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: firstNameTextEditController,
                          maxLength: 16,
                          validator: ValidationBuilder().required().minLength(3).maxLength(16).build(),
                          decoration: const InputDecoration(
                            labelText: "First Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: lastNameTextEditController,
                          maxLength: 16,
                          validator: ValidationBuilder().required().minLength(3).maxLength(16).build(),
                          decoration: const InputDecoration(
                            labelText: "Last Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: usernameTextEditController,
                          maxLength: 16,
                          validator: ValidationBuilder().required().minLength(3).maxLength(16).build(),
                          decoration: const InputDecoration(
                            labelText: "Username",
                            prefix: Text("@"),
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
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogFragment(
      insetPadding: EdgeInsets.zero,
      alignment: Alignment.topRight,
      builder: _getBody,
    );
  }
}
