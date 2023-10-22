import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/models.dart';
import '../../controllers/user_controller.dart';
import '../../middlewares/api_middleware.dart';

class ChangeProfileFragment extends StatefulWidget {
  const ChangeProfileFragment({super.key});

  @override
  State<StatefulWidget> createState() => _ChangeProfileFragmentState();
}

class _ChangeProfileFragmentState extends State<ChangeProfileFragment> {
  bool loading = false;
  dynamic selectedAvatar;

  late final UserModel _userModel;
  late final avatars = _loadAvatars();

  @override
  initState() {
    super.initState();

    _userModel = Provider.of<UserModel>(
      context,
      listen: false,
    );
  }

  Future<XFile?> getImageFiles() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(
      source: ImageSource.gallery,
    );
  }

  Future<List<String>> _loadAvatars() async {
    final manifestEncode = await rootBundle.loadString("AssetManifest.json");
    final Map<String, dynamic> manifest = jsonDecode(manifestEncode);

    return manifest.keys
        .where(
          (key) => key.startsWith("assets/images/avatars"),
        )
        .toList()
      ..insert(0, "local");
  }

  @override
  Widget build(BuildContext context) {
    final user = _userModel.value;

    return AlertDialog(
      title: const Text("Select An Avatar"),
      content: SizedBox(
        height: 180,
        child: FutureBuilder<List<String>>(
          future: avatars,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final avatars = snapshot.requireData;

                return GridView.builder(
                  itemCount: avatars.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    final avatar = avatars[index];

                    if (avatar == "local") {
                      return InkWell(
                        onTap: () async {
                          final file = await getImageFiles();
                          setState(() => selectedAvatar = file);
                        },
                        child: CircleAvatar(
                          child: Stack(
                            children: [
                              Positioned.fill(
                                top: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: selectedAvatar is XFile
                                        ? Image.file(
                                            File((selectedAvatar as XFile).path),
                                            fit: BoxFit.cover,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: user.avatar,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 0,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  child: Icon(
                                    Icons.add_photo_alternate,
                                    color: Theme.of(context).colorScheme.primaryContainer,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return InkWell(
                        onTap: () {
                          setState(() => selectedAvatar = avatar);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: CircleAvatar(
                                  child: avatar == "initial"
                                      ? Selector<UserModel, String>(
                                          selector: (context, model) => model.value.firstName,
                                          builder: (context, email, child) => Text(
                                            email.substring(0, 2),
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        )
                                      : Image.asset(
                                          avatar,
                                          width: 56,
                                          height: 56,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Visibility(
                                  visible: selectedAvatar == avatar,
                                  maintainState: true,
                                  maintainAnimation: true,
                                  child: Checkbox(
                                    value: selectedAvatar == avatar,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    onChanged: (bool? value) {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );

              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: FilledButton(
                onPressed: selectedAvatar == null
                    ? null
                    : () async {
                        setState(() => loading = true);

                        try {
                          _userModel.value = await userController.updateMultipartUser(
                            id: _userModel.value.id,
                            multipartFiles: [
                              if (selectedAvatar is XFile)
                                await MultipartFile.fromPath(
                                  "avatar",
                                  selectedAvatar.path,
                                  filename: "${user.username}.png",
                                  contentType: MediaType('image', 'png'),
                                ),
                              if (selectedAvatar is String && selectedAvatar != "initial")
                                MultipartFile.fromBytes(
                                  "avatar",
                                  (await rootBundle.load(selectedAvatar!)).buffer.asInt8List(),
                                  filename: "${user.username}.png",
                                  contentType: MediaType('image', 'png'),
                                ),
                            ],
                            fields: {
                              if (selectedAvatar == "initial") "avatar": "",
                            },
                          );

                          if (context.mounted) Navigator.pop(context);

                          showSnackBar(
                            leading: Icon(
                              Icons.check_circle,
                              color: Colors.greenAccent[700],
                            ),
                            title: "Profile picture was updated successfully.",
                          );
                        } catch (error, stackTrace) {
                          showSnackBar(
                            leading: const Icon(
                              Icons.error_rounded,
                              color: Colors.redAccent,
                            ),
                            title: "An error occur while updating profile picture. Try again!",
                          );

                          log("Fucked", error: error, stackTrace: stackTrace);

                          rethrow;
                        } finally {
                          setState(() => loading = false);
                        }
                      },
                child: loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text("Save"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
