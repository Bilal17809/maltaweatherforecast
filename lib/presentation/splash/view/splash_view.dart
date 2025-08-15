import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '/core/animation/view/animation.dart';
import '/core/animation/view/text_animation.dart';
import '../controller/splash_controller.dart';
import '/core/theme/app_colors.dart';
import '/presentation/home/view/home_view.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key});

  final splashController = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGreen,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const _LogoSection(),
                const SizedBox(height: 18),
                _AppTitle(),
                const SizedBox(height: 6),
                const _SubtitleSection(),
                const SizedBox(height: 87),
                _StartButton(splashController: splashController),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    return const AnimatedImageSequence();
  }
}

class _AppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TypewriterText(
          text: "Malta Weather",
          speed: const Duration(milliseconds: 150),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 40,
            color: kYellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        TweenAnimationBuilder<Offset>(
          tween: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOutCirc,
          builder: (context, offset, child) {
            return Transform.translate(offset: offset * 200, child: child);
          },
          child: "Forecast".text.color(kYellow).bold.size(25).make(),
        ),
      ],
    );
  }
}

class _SubtitleSection extends StatelessWidget {
  const _SubtitleSection();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOut,
      builder: (context, offset, child) {
        return Transform.translate(offset: offset * 200, child: child);
      },
      child: Column(
        children: [
          "Weather App Leads in Malta".text.color(kWhite).bold.size(15).make(),
          "for Accurate Forecasts".text.color(kWhite).bold.size(15).make(),
        ],
      ),
    );
  }
}

class _StartButton extends StatelessWidget {
  final SplashController splashController;

  const _StartButton({required this.splashController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return splashController.isLoading.value
          ? const SpinKitThreeBounce(color: kWhite, size: 50.0)
          : ElevatedButton(
              onPressed: () {
                Get.off(() => HomeView());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kYellow,
                foregroundColor: kBlack,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: "Get Start".text.size(20).bold.make(),
              ),
            );
    });
  }
}
