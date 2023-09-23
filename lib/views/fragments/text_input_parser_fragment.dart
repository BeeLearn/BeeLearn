import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

class TextInputFragment extends StatefulWidget {
  final String placeholder;
  final void Function(String value) onSubmit;

  const TextInputFragment({
    super.key,
    required this.placeholder,
    required this.onSubmit,
  });

  @override
  State<TextInputFragment> createState() => TextInputFragmentState();
}

class TextInputFragmentState extends State<TextInputFragment> {
  bool isCorrect = false;
  final inputController = TextEditingController();

  bool validateField() {
    if ("%${inputController.text}%" == widget.placeholder) setState(() => isCorrect = true);
    return isCorrect;
  }

  void inputPlaceholder() {
    inputController.text = widget.placeholder.substring(1, widget.placeholder.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.center,
      controller: inputController,
      validator: ValidationBuilder().required().add(
        (value) {
          if ("%$value%" != widget.placeholder) return "";
          return null;
        },
      ).build(),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        border: const OutlineInputBorder(),
        enabledBorder: isCorrect
            ? const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0,
                  color: Colors.green,
                ),
              )
            : null,
        focusedBorder: isCorrect
            ? const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2.0,
                  color: Colors.green,
                ),
              )
            : null,
        errorMaxLines: 1,
        errorStyle: const TextStyle(
          height: 0,
          fontSize: 0,
        ),
      ),
      onChanged: (value) {
        setState(() => isCorrect = false);
      },
    );
  }
}
