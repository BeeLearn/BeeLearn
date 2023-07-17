import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'tabs/category_tab_view.dart';
import 'tabs/favorite_tab_view.dart';
import 'tabs/home_tab_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    const CategoryTabView(),
    const FavoriteTab(),
    const HomeTab(),
  ];

  @override
  Widget build(context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _tabs,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              label: "Category",
              activeIcon: Icon(Icons.category),
              icon: Icon(Icons.category_outlined),
            ),
            BottomNavigationBarItem(
              label: "Liked",
              activeIcon: Icon(Icons.favorite),
              icon: Icon(Icons.favorite_outline),
            ),
            BottomNavigationBarItem(
              label: "Home",
              activeIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
