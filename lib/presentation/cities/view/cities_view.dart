import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '/core/animation/view/animated_bg_builder.dart';
import '/core/theme/theme.dart';
import 'widgets/city_card.dart';
import 'widgets/current_location_card.dart';
import '/core/common_widgets/common_widgets.dart';
import '/core/constants/constants.dart';
import '../controller/cities_controller.dart';

class CitiesView extends StatelessWidget {
  const CitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    final CitiesController controller = Get.find<CitiesController>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            AnimatedBgImageBuilder(),
            SafeArea(
              child: Column(
                children: [
                  TitleBar(subtitle: 'Select City'),
                  const _SearchWidget(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kBodyHp,
                      vertical: kElementGap,
                    ),
                    child: CurrentLocationCard(controller: controller),
                  ),
                  _CitiesGrid(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CitiesGrid extends StatelessWidget {
  final CitiesController controller;
  const _CitiesGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        final cities = controller.filteredCities;
        if (cities.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: kGap),
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: mobileWidth(context) / 2,
              mainAxisSpacing: kElementGap,
              crossAxisSpacing: kElementGap,
            ),
            itemCount: cities.length,
            itemBuilder: (BuildContext context, index) {
              final city = cities[index];
              return CityCard(controller: controller, city: city);
            },
          ),
        );
      }),
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CitiesController>();
    return Obx(() {
      final hasError = controller.hasSearchError.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SearchBarField(
              controller: controller.searchController,
              onSearch: (value) => controller.searchCities(value),
              backgroundColor: getSearchBgColor(context),
              borderColor: hasError ? kRed : getSecondaryColor(context),
              iconColor: hasError ? kRed : getSecondaryColor(context),
              textColor: secondaryText(context),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: kRed,
                    size: smallIcon(context),
                  ),
                  const Gap(kGap),
                  Expanded(
                    child: Text(
                      controller.searchErrorMessage.value,
                      style: bodySmallStyle(
                        context,
                      ).copyWith(color: kRed, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
        ],
      );
    });
  }
}
