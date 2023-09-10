import 'package:beelearn/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:showcaseview/showcaseview.dart';

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

  get smallScreenNavigation {
    return BottomNavigationBar(
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
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth < 640 ? smallScreenNavigation : const Row();
        },
      ),
      body: Consumer<UserModel>(
        builder: (context, model, child) {
          return model.nullableValue == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Row(
                  children: [
                    ResponsiveVisibility(
                      visible: !ResponsiveBreakpoints.of(context).isMobile,
                      child: NavigationRail(
                        selectedIndex: _currentIndex,
                        groupAlignment: 0,
                        onDestinationSelected: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        labelType: NavigationRailLabelType.all,
                        destinations: const [
                          NavigationRailDestination(
                            icon: Icon(Icons.category_outlined),
                            selectedIcon: Icon(Icons.category),
                            label: Text("Categories"),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.favorite_outline),
                            selectedIcon: Icon(Icons.favorite),
                            label: Text("Favourite"),
                          ),
                          NavigationRailDestination(
                            icon: CircleAvatar(radius: 16),
                            label: Text("Profile"),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ShowCaseWidget(
                        builder: Builder(
                          builder: (context) => IndexedStack(
                            index: _currentIndex,
                            children: _tabs,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
