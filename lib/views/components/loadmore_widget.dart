import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';

class CustomLoadMoreDelegate extends LoadMoreDelegate {
  const CustomLoadMoreDelegate();

  @override
  Widget buildChild(
    LoadMoreStatus status, {
    LoadMoreTextBuilder builder = DefaultLoadMoreTextBuilder.english,
  }) {
    switch(status){
      case LoadMoreStatus.idle:
      case LoadMoreStatus.nomore:
      case LoadMoreStatus.outScreen:
        return const SizedBox();
      case LoadMoreStatus.loading:
        return const Center(
          child: SizedBox(
            width: 32.0,
            height: 32.0,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        );
      default:
        return Text(builder(status));
    }
  }
}
