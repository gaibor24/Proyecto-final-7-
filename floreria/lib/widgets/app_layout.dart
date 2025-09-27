import 'package:floreria/controllers/generic_controller.dart';
import 'package:floreria/controllers/home_controller.dart';
import 'package:floreria/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../colors/app_colors.dart';
import '../constants/icons_constants.dart';
import '../controllers/orders_controller.dart';
import '../controllers/users_controller.dart';
import '../themes/texts_style.dart';
import '../views/orders/orders_view.dart';
import '../views/profile/profile_view.dart';
import '../views/shop/shop_view.dart';
import '../views/users/users_view.dart';
import 'custom_image_cache.dart';

enum AppSection {
  shop,
  products,
  users,
  orders,
  profile;

  String get title {
    switch (this) {
      case AppSection.shop:
        return 'Tienda';

      case AppSection.products:
        return 'Productos';

      case AppSection.users:
        return 'Usuarios';

      case AppSection.orders:
        return 'Pedidos';

      case AppSection.profile:
        return 'Mi Perfil';
    }
  }

  String get icon {
    switch (this) {
      case AppSection.shop:
        return IconsConstants.shop;

      case AppSection.products:
        return IconsConstants.products;

      case AppSection.users:
        return IconsConstants.users;

      case AppSection.orders:
        return IconsConstants.orders;

      case AppSection.profile:
        return IconsConstants.user;
    }
  }
}

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  late GenericController genericController;
  List<AppSection> sections = [];
  late AppSection section;
  int currentIndex = 0;
  bool isAdmin = false;
  String name = '';

  @override
  void initState() {
    super.initState();
    genericController = context.read<GenericController>();
    init();
  }

  void init() async {
    name = genericController.user?.name ?? '';
    isAdmin = genericController.user?.isAdmin ?? false;

    if (isAdmin) {
      sections = [
        AppSection.users,
        AppSection.products,
        AppSection.orders,
        AppSection.profile,
      ];
    } else {
      sections = [AppSection.shop, AppSection.orders, AppSection.profile];
    }

    section = sections[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => HomeController()),
          ChangeNotifierProvider(create: (context) => UsersController()),
          ChangeNotifierProvider(create: (context) => OrdersController()),
        ],
        child: SafeArea(
          /* top:
              (section == AppSection.shop || section == AppSection.orders)
                  ? true
                  : false, */
          child: Column(
            children: [
              /* AppBar(
                title: Text(section.title),
                actions:
                    isAdmin
                        ? (section == AppSection.products
                            ? [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return AddProductView();
                                      },
                                    ),
                                  );
                                },
                                icon: Icon(Icons.add),
                              ),
                            ]
                            : [])
                        : [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return CartView();
                                  },
                                ),
                              );
                            },
                            icon: Icon(Icons.shopping_bag_outlined),
                          ),
                        ],
              ), */
              Expanded(
                child: Column(
                  // fit: StackFit.expand,
                  children: [
                    Expanded(child: _child),
                    StylishBottomBar(
                      onTap: (index) {
                        section = sections[index];
                        currentIndex = index;
                        setState(() {});
                      },
                      backgroundColor: Colors.white,
                      currentIndex: currentIndex,
                      option: AnimatedBarOptions(
                        inkColor: AppColors.primary,
                        barAnimation: BarAnimation.blink,
                        opacity: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(0),
                      items:
                          sections.map((e) {
                            final isSelected = e == section;

                            return BottomBarItem(
                              icon: CustomImageCache(
                                url: e.icon,
                                width: isSelected ? 20 : 14,
                                height: isSelected ? 20 : 14,
                                imageColor:
                                    isSelected
                                        ? AppColors.primary
                                        : Colors.grey,
                              ),
                              title: Text(
                                e.title,
                                style:
                                    isSelected
                                        ? TextsStyle(context).bodyMedium
                                            .copyWith(color: AppColors.primary)
                                        : TextsStyle(
                                          context,
                                        ).bodySmall.copyWith(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _child {
    switch (section) {
      case AppSection.products:
        return HomeView(isAdmin: isAdmin);

      case AppSection.shop:
        return ShopView(name: name);

      case AppSection.users:
        return UsersView();

      case AppSection.orders:
        return OrdersView(isAdmin: isAdmin);

      case AppSection.profile:
        return ProfileView();
    }
  }
}
