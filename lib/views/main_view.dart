import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../globals.dart';
import 'app_theme.dart';
import 'tabs/category_tab_view.dart';
import 'tabs/favorite_tab_view.dart';
import 'tabs/profile_tab_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    const CategoryTabView(),
    const FavoriteTab(),
    const ProfileTabView(),
  ];

  @override
  Widget build(context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: ResponsiveBreakpoints.builder(
        breakpoints: defaultBreakpoints,
        child: Scaffold(
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
                label: "Profile",
                icon: CircleAvatar(radius: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
