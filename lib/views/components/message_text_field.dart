import 'package:flutter/material.dart';
import 'package:flutter_social_textfield/flutter_social_textfield.dart';

///
class MessageTextField extends StatefulWidget {
  final int maxLength;
  final FocusNode focusNode;
  final SocialTextEditingController controller;
  final Future<dynamic> Function(String message) onSend;

  const MessageTextField({
    super.key,
    this.maxLength = 128,
    required this.onSend,
    required this.focusNode,
    required this.controller,
  });

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  int counter = 0;
  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).primaryColorDark : Theme.of(context).highlightColor.withAlpha(50),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              maxLines: null,
              focusNode: widget.focusNode,
              controller: widget.controller,
              maxLength: widget.maxLength,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: "Type your Comment...",
                border: InputBorder.none,
                counterText: "",
              ),
              onChanged: (value) {
                setState(() {
                  counter = value.length;
                });
              },
            ),
          ),
          Visibility(
            visible: counter > 0,
            child: Container(
              decoration: BoxDecoration(
                color: counter < 100
                    ? Colors.green
                    : counter == 128
                        ? Colors.red
                        : Colors.amber[700],
                borderRadius: BorderRadius.circular(100),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 2.0,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(counter.toString()),
            ),
          ),
          Visibility(
            visible: counter > 0 && widget.controller.text.trim().isNotEmpty,
            child: SizedBox(
              width: 32,
              height: 32,
              child: Center(
                child: IconButton.filled(
                  onPressed: () async {
                    if (isSending) return;
                    isSending = true;

                    await widget.onSend(widget.controller.text).then(
                      (value) {
                        setState(() {
                          counter = 0;
                          widget.controller.text = "";
                        });
                      },
                    ).whenComplete(() => setState(() => isSending = false));
                  },
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.arrow_upward,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
