import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../middlewares/api_middleware.dart';
import '../main_application.dart';
import 'fragments/dialog_fragment.dart';

class EmailLinkLoginView extends StatefulWidget {
  final bool requestEmail;

  const EmailLinkLoginView({
    super.key,
    this.requestEmail = false,
  });

  @override
  State<StatefulWidget> createState() => _EmailLinkLoginViewState();
}

class _EmailLinkLoginViewState extends State<EmailLinkLoginView> {
  bool isSubmitting = false;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      MainApplication.sharedPreferences.setString(
        "local.USER_EMAIL",
        _emailController.text,
      );

      setState(() => isSubmitting = true);

      if (widget.requestEmail) {
        Navigator.pop(context, _emailController.text);
        setState(() => isSubmitting = false);
        return;
      }

      try {
        await FirebaseAuth.instance.sendSignInLinkToEmail(
          email: _emailController.text,
          actionCodeSettings: ActionCodeSettings(
            handleCodeInApp: true,
            androidInstallApp: true,
            iOSBundleId: 'com.oasis.beelearn',
            androidPackageName: 'com.oasis.beelearn',
            url: 'https://usebeelearn.com/auth/?from=mobile',
          ),
        );

        showSnackBar(
          leading: Icon(
            Icons.check_circle_rounded,
            color: Colors.greenAccent[700],
          ),
          title: "Magic link sent to email successfully.",
        );
      } catch (error) {
        showSnackBar(
          leading: const Icon(
            Icons.error_rounded,
            color: Colors.redAccent,
          ),
          title: "An unexpected error occur. Try again!",
        );

        rethrow;
      } finally {
        setState(() => isSubmitting = false);
      }
    }
  }

  Widget get mainBody {
    return Padding(
      padding: const EdgeInsets.all(16.0).copyWith(top: 0),
      child: Flex(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Column(
              children: [
                Column(
                  children: [
                    Text(
                      "Sign In",
                      style: GoogleFonts.nunitoSans(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      "Get an email with signin link to login",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),
                Form(
                  key: _formKey,
                  child: Wrap(
                    runSpacing: 16.0,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: ValidationBuilder().email().required().build(),
                        decoration: const InputDecoration(
                          label: Text("Email"),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: _onSubmit,
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                              ),
                              child: isSubmitting
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(color: Colors.white),
                                    )
                                  : const Text("Send Email Link"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Flexible(
                child: Text.rich(
                  const TextSpan(children: [
                    TextSpan(text: "By continuing you agree with BeeLearn "),
                    TextSpan(
                      text: "terms of service ",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    TextSpan(text: "and "),
                    TextSpan(
                      text: "privacy policies.",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ]),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(context) {
    return DialogFragment(
      alignment: Alignment.topRight,
      insetPadding: EdgeInsets.zero,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            leading: const CloseButton(),
          ),
          body: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET)
              ? SingleChildScrollView(
                  child: mainBody,
                )
              : SafeArea(
                  bottom: true,
                  child: mainBody,
                ),
        );
      },
    );
  }
}
