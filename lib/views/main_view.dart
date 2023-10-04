import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:showcaseview/showcaseview.dart';

import '../controllers/controllers.dart';
import '../main_application.dart';
import '../models/models.dart';
import '../services/date_service.dart';
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
    const FavoriteTabView(),
    const ProfileTabView(),
  ];

  late final StreakModel _streakModel;
  late final ProductModel _productModel;
  late final NotificationModel _notificationModel;

  /// Call all non-blocking ui initialization stuffs here
  @override
  initState() {
    super.initState();

    _streakModel = Provider.of<StreakModel>(
      context,
      listen: false,
    );

    _productModel = Provider.of<ProductModel>(
      context,
      listen: false,
    );

    _notificationModel = Provider.of<NotificationModel>(
      context,
      listen: false,
    );

    /// Lazy Load this
    initialize().onError(
      (error, stackError) {
        log("lazy error", error: error, stackTrace: stackError);
      },
    );
  }

  Future<void> initialize() async {
    lazyLoadStreaks();
    lazyLoadProducts();
    lazyLoadNotifications();
  }

  /// Lazy load notifications
  /// Fetch notifications
  Future<void> lazyLoadNotifications() async {
    final response = await notificationController.listNotifications();

    _notificationModel.setAll(response.results);
    _notificationModel.loading = false;
  }

  /// Lazy load streaks
  /// fetch current month streaks
  Future<void> lazyLoadStreaks() async {
    final (monthStart, monthEnd) = DateService.getMonthStartAndEnd();

    final response = await streakController.getStreaks(
      query: {
        "no_page": "true",
        "date__range": "${DateService.defaultFormatter.format(monthStart)},${DateService.defaultFormatter.format(
          monthEnd.add(
            const Duration(
              days: 7,
            ),
          ),
        )}",
      },
    );

    _streakModel.setAll(response);
    _streakModel.loading = false;
  }

  /// Lazy load products
  /// Fetch subscription enlisting
  Future<void> lazyLoadProducts() async {
    final products = await productController.listProducts();

    _productModel.setAll(products.results);
    _productModel.loading = false;
  }

  get _smallScreenNavigation {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        const BottomNavigationBarItem(
          label: "Category",
          activeIcon: Icon(Icons.category),
          icon: Icon(Icons.category_outlined),
        ),
        const BottomNavigationBarItem(
          label: "Liked",
          activeIcon: Icon(Icons.favorite),
          icon: Icon(Icons.favorite_outline),
        ),
        BottomNavigationBarItem(
          label: "Profile",
          icon: Consumer<UserModel>(
            builder: (context, model, child) {
              return model.nullableValue == null
                  ? const CircleAvatar()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        model.value.avatar,
                        width: 32.0,
                        height: 32.0,
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }

  get _largeScreenNavigation {
    return NavigationRail(
      groupAlignment: 0,
      selectedIndex: _currentIndex,
      labelType: NavigationRailLabelType.all,
      onDestinationSelected: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      destinations: [
        const NavigationRailDestination(
          icon: Icon(Icons.category_outlined),
          selectedIcon: Icon(Icons.category),
          label: Text("Categories"),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.favorite_outline),
          selectedIcon: Icon(Icons.favorite),
          label: Text("Favourite"),
        ),
        NavigationRailDestination(
          icon: Consumer<UserModel>(
            builder: (context, model, child) {
              return model.nullableValue == null
                  ? const CircleAvatar()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        model.value.avatar,
                        width: 32.0,
                        height: 32.0,
                      ),
                    );
            },
          ),
          label: const Text("Profile"),
        ),
      ],
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth < 640 ? _smallScreenNavigation : const Row();
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
                      visible: ResponsiveBreakpoints.of(context).largerThan(MOBILE),
                      child: _largeScreenNavigation,
                    ),
                    Expanded(
                      child: ShowCaseWidget(
                        onComplete: (index, keys) => MainApplication.isNewUser = false,
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
