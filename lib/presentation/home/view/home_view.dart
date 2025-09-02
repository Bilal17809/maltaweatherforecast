import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '/core/theme/theme.dart';
import '/presentation/app_drawer/app_drawer.dart';
import '/core/global_keys/global_key.dart';
import '../controller/home_controller.dart';
import 'widgets/home_body.dart';
import '/core/utils/home_dialog.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();


}

class _HomeViewState extends State<HomeView> {

  final homeController = Get.find<HomeController>();

  @override
  void initState() {
    homeController.requestTrackingPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          decoration: bgGradient(context),
          child: const SafeArea(child: HomeBody()),
        ),
      ),
    );
  }
}
