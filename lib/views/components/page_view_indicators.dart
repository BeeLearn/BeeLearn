import 'package:flutter/material.dart';

class LinearProgressPageIndicator extends StatefulWidget {
  final int itemCount;
  final double width, height;
  final PageController pageController;

  const LinearProgressPageIndicator({
    super.key,
    this.width = 256,
    this.height = 4,
    required this.itemCount,
    required this.pageController,
  }) : super();

  @override
  State createState() => _LinearProgressPageIndicatorState();
}

class _LinearProgressPageIndicatorState extends State<LinearProgressPageIndicator> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.pageController.positions.isNotEmpty ? widget.pageController.page!.round() : 0;
    widget.pageController.addListener(_pageControllerListener);
  }

  @override
  void dispose() {
    super.dispose();
    widget.pageController.removeListener(_pageControllerListener);
  }

  void _pageControllerListener() {
    setState(() {
      _currentIndex = widget.pageController.page!.round();
    });
  }

  @override
  Widget build(context) {
    return Column(
      children: [
        SizedBox(
          width: widget.width,
          height: widget.height,
          child: Align(
            alignment: Alignment.center,
            child: ListView.builder(
              itemCount: widget.itemCount,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final active = _currentIndex == index;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: SizedBox(
                    width: (widget.width * (active ? 0.8 : 0.5)) / widget.itemCount,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        value: active ? 1 : 0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
