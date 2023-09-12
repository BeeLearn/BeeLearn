import 'package:djira_client/djira_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_textfield/flutter_social_textfield.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';
import 'package:rich_text_view/rich_text_view.dart';
import 'package:timeago/timeago.dart' as timeago show format;

import '../models/topic_comment_model.dart';
import '../serializers/topic_comment.dart';
import '../socket_client.dart';
import 'components/message_text_field.dart';

class TopicCommentView extends StatefulWidget {
  final int topicId;

  const TopicCommentView({
    super.key,
    required this.topicId,
  });

  @override
  State<TopicCommentView> createState() => _TopicCommentViewState();
}

class _TopicCommentViewState extends State<TopicCommentView> {
  // Socket unsubscribe
  dynamic unsubscribe;

  String? nextUrl;
  late final TopicCommentModel topicCommentModel;

  // Current commenting parent
  TopicComment? parentComment;
  TopicComment? childComment;

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

    topicCommentModel = Provider.of<TopicCommentModel>(
      context,
      listen: false,
    );

    topicCommentModel.getTopicComments(
      query: {
        "topic": widget.topicId.toString(),
      },
    ).then(
      (topicComment) {
        topicCommentModel.setAll(topicComment.results);
        topicCommentModel.loading = false;
        nextUrl = topicComment.next;
      },
    );

    initialize();
  }

  initialize() async {
    unsubscribe = await client?.subscribe(
      namespace: "topic-comments",
      query: {"topicId": widget.topicId},
      onError: (response) {},
      onSuccess: (response) {
        final topicComment = TopicComment.fromJson(response.data);

        switch (response.type!) {
          case Type.created:
            topicCommentModel.setOne(topicComment);
          case Type.removed:
            topicCommentModel.removeOne(topicComment);
          case Type.updated:
            topicCommentModel.updateOne(topicComment);
          default:
            throw UnimplementedError("Subscription of type not implemented");
        }
      },
    );
  }

  @override
  dispose() async {
    super.dispose();

    await unsubscribe();
  }

  Future<bool> _onLoadMore() async {
    if (nextUrl != null) {
      return topicCommentModel.getTopicComments(url: nextUrl).then((response) {
        topicCommentModel.addAll(response.results);
        nextUrl = response.next;

        return true;
      });
    }

    return false;
  }

  Widget getCommentFragment({
    required TopicComment topicComment,
    required List<Widget> children,
    EdgeInsets? contentPadding,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16.0),
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            maxRadius: 16.0,
            child: topicComment.user.avatar == null
                ? Text(
                    topicComment.user.email.substring(0, 1),
                  )
                : Image.network(topicComment.user.avatar!),
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
                          Text(
                            topicComment.user.username,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            timeago.format(topicComment.createdAt),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.8),
                                ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<int>(
                      icon: Icon(
                        Icons.more_vert_outlined,
                        color: Theme.of(context).dividerColor,
                      ),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            child: Text("Edit"),
                          ),
                          const PopupMenuItem(
                            child: Text("Delete"),
                          ),
                          const PopupMenuItem(
                            child: Text("Report"),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: RichTextView(
                    maxLines: 3,
                    viewLessText: "hide",
                    text: topicComment.content,
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
                    linkStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                ...children,
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getReplyButton(TopicComment parent, TopicComment? child) {
    return TextButton(
      onPressed: () {
        final username = "@${(child ?? parent).user.username} ";

        messageTextFieldController.text = username;
        if (!messageTextFieldFocusNode.hasFocus) messageTextFieldFocusNode.requestFocus();

        parentComment = parent;
        messageTextFieldController.selection = TextSelection.fromPosition(TextPosition(offset: username.length));
      },
      child: const Text("Reply"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Comments"),
        ),
        body: Flex(
          direction: Axis.vertical,
          children: [
            Flexible(
              child: RefreshIndicator(
                onRefresh: () async {},
                child: Consumer<TopicCommentModel>(
                  builder: (context, model, child) {
                    final topicComments = model.items;

                    return model.loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : LoadMore(
                            onLoadMore: _onLoadMore,
                            isFinish: nextUrl == null,
                            child: ListView.builder(
                              itemCount: topicComments.length,
                              itemBuilder: (context, index) {
                                final TopicComment topicComment = topicComments[index];
                                final List<TopicComment>? subTopicComments = topicComment.subTopicComments;

                                return getCommentFragment(
                                  topicComment: topicComment,
                                  contentPadding: const EdgeInsets.only(left: 16.0),
                                  children: [
                                    getReplyButton(topicComment, null),
                                    ListView.builder(
                                      itemCount: subTopicComments?.length,
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        final subTopicComment = subTopicComments![index];
                                        return getCommentFragment(
                                          topicComment: subTopicComment,
                                          contentPadding: EdgeInsets.zero,
                                          children: [
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                    height: 24.0,
                                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                    decoration: BoxDecoration(
                                                      // onSelected color: Theme.of(context).dividerColor.withAlpha(147),
                                                      border: Border.all(color: Theme.of(context).dividerColor),
                                                      borderRadius: BorderRadius.circular(4.0),
                                                    ),
                                                    child: const Center(
                                                      child: Row(
                                                        children: [
                                                          Text("1k"),
                                                          SizedBox(width: 4.0),
                                                          Icon(
                                                            Icons.favorite,
                                                            size: 18.0,
                                                            color: Colors.red,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                getReplyButton(topicComment, subTopicComment),
                                              ],
                                            ),
                                          ],
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
            MessageTextField(
              focusNode: messageTextFieldFocusNode,
              controller: messageTextFieldController,
              onSend: (String message) {
                final Map<String, dynamic> data = {"topic": widget.topicId, "content": message};

                if (parentComment == null) {
                  final Map<String, dynamic> newComment = {"is_parent": true};
                  newComment.addAll(data);

                  return topicCommentModel.createTopicComment(data: newComment).then(
                    (response) {
                      topicCommentModel.setOne(response);
                      setState(() => parentComment = null);
                    },
                  );
                } else {
                  return topicCommentModel.updateTopicComment(
                    id: parentComment!.id,
                    data: {
                      "sub_topic_comments": {
                        "create": [data]
                      },
                    },
                  ).then(
                    (response) {
                      topicCommentModel.updateOne(response);
                      setState(() => parentComment = null);
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
