import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../controllers/user_controller.dart';
import '../middlewares/api_middleware.dart' show showSnackBar;
import '../models/user_model.dart';
import '../views/fragments/dialog_fragment.dart';
import '../widget_keys.dart';

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

  Future<XFile?> getImageFiles() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(
      source: ImageSource.gallery,
    );
  }

  Widget _getBody(BuildContext context) {
    return LoaderOverlay(
      overlayOpacity: 0,
      overlayColor: Colors.black45,
      disableBackButton: kReleaseMode,
      child: Consumer<UserModel>(
        builder: (context, model, child) {
          return Form(
            key: _formKey,
            child: Scaffold(
              appBar: AppBar(
                leading: const CloseButton(key: editProfileViewBackButtonKey),
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
                      } catch (error) {
                        showSnackBar(
                          leading: const Icon(
                            Icons.error,
                            color: Colors.redAccent,
                          ),
                          title: "An error occur while updating your profile",
                        );

                        rethrow;
                      } finally {
                        if(context.mounted) context.loaderOverlay.hide();
                      }

                      // Lazy update
                      final user = userModel.value;
                      FirebaseAuth.instance.currentUser?.updateDisplayName(user.fullName);
                      FirebaseAuth.instance.currentUser?.updatePhotoURL(user.avatar);
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
                                final file = await getImageFiles();

                                if (file != null) {
                                  userModel.value = await userController.updateMultipartUser(
                                    id: userModel.value.id,
                                    multipartFiles: [
                                      await MultipartFile.fromPath(
                                        "avatar",
                                        file.path,
                                        contentType: MediaType.parse("image/png"),
                                      ),
                                    ],
                                  ).onError(
                                    (error, stackTrace) {
                                      showSnackBar(
                                        leading: const Icon(
                                          Icons.error_rounded,
                                          color: Colors.redAccent,
                                        ),
                                        title: "An error occur while updating profile picture. Try again!",
                                      );

                                      return Future.error(error!);
                                    },
                                  ).whenComplete(() => context.loaderOverlay.hide());

                                  showSnackBar(
                                    leading: Icon(
                                      Icons.check_circle,
                                      color: Colors.greenAccent[700],
                                    ),
                                    title: "Profile picture was updated successfully.",
                                  );
                                } else {
                                  if(context.mounted) context.loaderOverlay.hide();
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
