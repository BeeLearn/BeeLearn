import 'dart:developer';

import 'package:beelearn/views/fragments/dialog_fragment.dart';
import 'package:djira_client/djira_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_textfield/flutter_social_textfield.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';
import 'package:rich_text_view/rich_text_view.dart';
import 'package:timeago/timeago.dart';

import '../controllers/comment_controller.dart';
import '../controllers/reply_controller.dart';
import '../controllers/thread_controller.dart';
import '../models/models.dart';
import '../serializers/serializers.dart';
import '../socket_client.dart';
import 'components/message_text_field.dart';

/// Todo refactor and make generic
class ThreadView extends StatefulWidget {
  final String reference;

  const ThreadView({
    super.key,
    required this.reference,
  });

  @override
  State<ThreadView> createState() => _ThreadViewState();
}

class _ThreadViewState extends State<ThreadView> {
  String? nextUrl;
  // unsubscribe socket listeners
  dynamic unsubscribeThreadListener, unsubscribeReplyListener;

  late final UserModel userModel;
  late final ThreadModel threadModel;

  // replying comment commenting
  Comment? replyComment;
  (Comment?, Comment)? editComment;

  // Textfield states
  final FocusNode messageTextFieldFocusNode = FocusNode();
  final SocialTextEditingController messageTextFieldController = SocialTextEditingController()
    ..setTextStyle(
      DetectedType.mention,
      TextStyle(
        fontSize: 17.0,
        color: Colors.deepPurple[400],
        backgroundColor: Colors.deepPurple.withAlpha(50),
      ),
    );

  @override
  void initState() {
    super.initState();
    threadModel = Provider.of<ThreadModel>(
      context,
      listen: false,
    );
    userModel = Provider.of<UserModel>(
      context,
      listen: false,
    );

    threadController.getThreads(
      query: {
        "reference": widget.reference,
      },
    ).then(
      (response) {
        threadModel.setThreads(response.results);
        setState(() => nextUrl = response.next);
        threadModel.loading = false;
      },
    ).catchError((error, stackTrace) {
      log(
        "error",
        stackTrace: stackTrace,
        error: error,
      );
    });

    initialize();
  }

  initialize() async {
    unsubscribeThreadListener = await client?.subscribe(
      namespace: "threads",
      query: {"reference": widget.reference},
      onError: (response) {},
      onSuccess: (response) {
        final thread = Thread.fromJson(response.data);

        switch (response.type) {
          case Type.created:
            threadModel.addThread(thread);
          case Type.updated:
            threadModel.updateThread(thread);
          case Type.removed:
            threadModel.removeThread(thread);
          default:
            throw UnimplementedError("Subscription of type not implemented");
        }
      },
    );

    unsubscribeReplyListener = await client?.subscribe(
      namespace: "replies",
      query: {"thread_reference": widget.reference},
      onError: (response) {},
      onSuccess: (response) {
        final reply = Reply.fromJson(response.data);

        switch (response.type) {
          case Type.created:
            threadModel.setReply(reply);
          case Type.updated:
            threadModel.updateReply(reply);
          case Type.removed:
            threadModel.removeReply(reply);
          default:
            throw UnimplementedError("Subscription of type not implemented");
        }
      },
    );
  }

  @override
  dispose() async {
    super.dispose();

    await unsubscribeThreadListener();
    await unsubscribeReplyListener();
  }

  Future<bool> _onLoadMore() async {
    if (nextUrl != null) {
      return threadController.getThreads(url: nextUrl).then(
        (response) {
          threadModel.addThreads(response.results);
          setState(() => nextUrl = response.next);
          return true;
        },
      );
    }

    return false;
  }

  /// Comment display fragment
  /// [parent] comment ancestor, (optional, if parent)
  /// [comment] current comment for widget
  /// [children] widget children (optional)
  Widget getCommentFragment({
    Comment? parent,
    required Comment comment,
    List<Widget>? children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.only(
        left: 16.0,
        right: comment.isDeleted ? 16.0 : 0,
      ),
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            /// Todo, use a better fix than using margin
            margin: const EdgeInsets.only(top: 16.0), // make avatar align with text,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                comment.user.avatar,
                width: 32.0,
                height: 32.0,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              comment.user.tagUsername,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            format(comment.createdAt),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.8),
                                ),
                          ),
                        ],
                      ),
                    ),
                    if (!comment.isDeleted)
                      PopupMenuButton<int>(
                        icon: Icon(
                          Icons.more_vert_outlined,
                          color: Theme.of(context).dividerColor,
                        ),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context) {
                          return [
                            if (userModel.value.id == comment.user.id)
                              PopupMenuItem(
                                child: const Text("Edit"),
                                onTap: () {
                                  requestFocus(comment.content);
                                  editComment = (parent, comment);
                                },
                              ),
                            if (userModel.value.id == comment.user.id)
                              PopupMenuItem(
                                child: const Text("Delete"),
                                onTap: () async {
                                  final updatedComment = await commentController.deleteComment(id: comment.id);
                                  if (parent == null) {
                                    threadModel.updateOne(updatedComment);
                                  } else {
                                    threadModel.updateReply(
                                      Reply(
                                        parent: parent.id,
                                        comment: updatedComment,
                                      ),
                                    );
                                  }
                                },
                              ),
                            PopupMenuItem(
                              child: const Text("Share"),
                              onTap: () {},
                            ),
                            PopupMenuItem(
                              child: const Text("Report"),
                              onTap: () {},
                            ),
                          ];
                        },
                      ),
                  ],
                ),
                if (comment.isDeleted)
                  Container(
                    width: double.infinity,
                    height: 48.0,
                    margin: const EdgeInsets.only(top: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).colorScheme.secondaryContainer : Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Text("Deleted Comment"),
                  ),
                if (!comment.isDeleted)
                  RichTextView(
                    maxLines: 3,
                    selectable: true,
                    viewLessText: "hide",
                    text: comment.content,
                    supportedTypes: [
                      EmailParser(
                        onTap: (value) {},
                      ),
                      PhoneParser(
                        onTap: (value) {},
                      ),
                      UrlParser(
                        onTap: (value) {},
                      ),
                      HashTagParser(
                        onTap: (value) {},
                      ),
                      MentionParser(
                        onTap: (value) {},
                      ),
                      BoldParser(),
                    ],
                    truncate: true,
                    linkStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                if (!comment.isDeleted) const SizedBox(height: 4.0),
                if (!comment.isDeleted)
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          final newComment = await commentController.updateComment(
                            id: comment.id,
                            body: {
                              "likes": {
                                "add": [if (!comment.isLiked) userModel.value.id],
                                "remove": [if (comment.isLiked) userModel.value.id],
                              }
                            },
                          );

                          if (parent == null) {
                            threadModel.updateThread(
                              Thread(
                                reference: widget.reference,
                                comment: newComment,
                              ),
                            );
                          } else {
                            threadModel.updateReply(
                              Reply(
                                parent: parent.id,
                                comment: newComment,
                              ),
                            );
                          }
                        },
                        child: AnimatedContainer(
                          constraints: const BoxConstraints(
                            maxHeight: 24.0,
                            minWidth: 48.0,
                          ),
                          duration: const Duration(milliseconds: 1000),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(color: Theme.of(context).disabledColor),
                            color: comment.isLiked ? Theme.of(context).dividerColor.withAlpha(147) : null,
                          ),
                          child: Center(
                            child: Wrap(
                              spacing: 4.0,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  comment.likeCount.toString(),
                                  style: TextStyle(color: Theme.of(context).dividerColor),
                                ),
                                Icon(
                                  size: 16.0,
                                  color: comment.isLiked ? Colors.red : Theme.of(context).dividerColor,
                                  comment.isLiked ? Icons.favorite : Icons.favorite_outline,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      getReplyButton(
                        comment: comment,
                        parent: parent ?? comment,
                      ),
                    ],
                  ),
                if (children != null) ...children,
              ],
            ),
          )
        ],
      ),
    );
  }

  void requestFocus(String? value) {
    if (value != null) {
      messageTextFieldController.text = value;
      messageTextFieldController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: value.length,
        ),
      );
    }

    messageTextFieldFocusNode.requestFocus();
  }

  /// Reply button fragment
  /// [parent] reply parent, nullable if reply is a thread i.e root ancestor
  /// [comment] comment that own reply button
  Widget getReplyButton({
    Comment? parent,
    required Comment comment,
  }) {
    return TextButton(
      onPressed: () {
        requestFocus(comment.user.tagUsername);
        replyComment = parent;
      },
      child: const Text("Reply"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogFragment(
      alignment: Alignment.topRight,
      insetPadding: EdgeInsets.zero,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Comments"),
        ),
        body: Flex(
          direction: Axis.vertical,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: RefreshIndicator(
                  onRefresh: () async {},
                  child: Consumer<ThreadModel>(
                    builder: (context, model, child) {
                      final comments = model.items;

                      return model.loading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : LoadMore(
                              onLoadMore: _onLoadMore,
                              isFinish: nextUrl == null,
                              child: ListView.builder(
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  final comment = comments[index];
                                  final List<Comment>? replies = comment.replies?.toList();
                                  replies?.sort(
                                    (first, second) => first.createdAt.compareTo(second.createdAt),
                                  );

                                  return getCommentFragment(
                                    parent: null,
                                    comment: comment,
                                    children: [
                                      if (replies != null)
                                        ListView.builder(
                                          itemCount: replies.length,
                                          shrinkWrap: true,
                                          physics: const ClampingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            final reply = replies.elementAt(index);
                                            return getCommentFragment(
                                              comment: reply,
                                              parent: comment,
                                            );
                                          },
                                        ),
                                    ],
                                  );
                                },
                              ),
                            );
                    },
                  ),
                ),
              ),
            ),
            MessageTextField(
              focusNode: messageTextFieldFocusNode,
              controller: messageTextFieldController,
              onSend: (String message) async {
                if (editComment == null) {
                  if (replyComment == null) {
                    final newThread = await threadController.createThread(
                      body: {
                        "reference": widget.reference,
                        "comment": {
                          "content": message,
                        }
                      },
                    );

                    threadModel.addThread(newThread);
                  } else {
                    final newReply = await replyController.createReply(
                      body: {
                        "parent": replyComment!.id,
                        "comment": {
                          "content": message,
                        }
                      },
                    );

                    threadModel.setReply(newReply);
                  }
                  replyComment = null;
                } else {
                  final (parent, comment) = editComment as (Comment?, Comment);

                  final newComment = await commentController.updateComment(
                    id: comment.id,
                    body: {"content": message},
                  );

                  if (parent == null) {
                    threadModel.updateThread(
                      Thread(
                        comment: newComment,
                        reference: widget.reference,
                      ),
                    );
                  } else {
                    threadModel.updateReply(
                      Reply(
                        parent: parent.id,
                        comment: newComment,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
