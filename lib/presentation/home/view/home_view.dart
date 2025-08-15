import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:maltaweatherforecast/core/theme/app_theme.dart';
import '/presentation/app_drawer/app_drawer.dart';
import '/core/global_keys/global_key.dart';
import '../controller/home_controller.dart';
import 'widgets/home_body.dart';
import '/core/utils/home_dialog.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, value) async {
        if (didPop) return;
        final shouldExit = await HomeDialogs.showExitDialog(context);
        if (shouldExit == true) SystemNavigator.pop();
      },
      child: Scaffold(
        key: globalDrawerKey,
        drawer: const AppDrawer(),
        onDrawerChanged: (isOpen) {
          homeController.isDrawerOpen.value = isOpen;
        },
        body: Container(
          decoration: bgGradient,
          child: const SafeArea(child: HomeBody()),
        ),
      ),
    );
  }
}
