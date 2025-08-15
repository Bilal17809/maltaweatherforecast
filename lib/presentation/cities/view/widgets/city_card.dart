import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '/data/models/city_model.dart';
import '/core/theme/theme.dart';
import '/core/constants/constants.dart';
import '/core/services/services.dart';
import '/presentation/home/controller/home_controller.dart';
import '../../controller/cities_controller.dart';

class CityCard extends StatelessWidget {
  final CitiesController controller;
  final CityModel city;

  const CityCard({super.key, required this.controller, required this.city});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Obx(() {
      final isSelected =
          homeController.selectedCity.value?.cityAscii == city.cityAscii;
      final weather =
          controller.conditionService.allCitiesWeather[city.cityAscii];
      final temp = weather?.temperature.round().toString() ?? '--';
      final condition = weather?.condition ?? 'Loading...';
      final airQuality = weather?.airQuality != null
          ? 'AQI ${weather?.airQuality?.calculatedAqi} - ${weather?.airQuality?.category}'
          : 'Loading...';
      return GestureDetector(
        onTap: () async {
          FocusScope.of(context).unfocus();
          await controller.selectCity(city);
          if (controller.splashController.selectedCity.value != null &&
              LocationUtilsService.fromCityModel(
                    controller.splashController.selectedCity.value!,
                  ) ==
                  LocationUtilsService.fromCityModel(city)) {
            Future.delayed(const Duration(milliseconds: 160), () {
              Get.back(result: city);
            });
          }
        },
        child: Container(
          decoration: roundedDecor(context).copyWith(
            gradient: context.isDark
                ? (isSelected ? kSelectedGradient(context) : null)
                : (isSelected
                      ? kSelectedGradient(context)
                      : kContainerGradient(context)),
            color: context.isDark
                ? secondaryColorLight.withValues(alpha: 0.35)
                : null,
            border: isSelected
                ? Border.all(
                    color: context.isDark
                        ? secondaryColorDark
                        : selectedLightColor,
                    width: 2,
                  )
                : null,
          ),
          padding: const EdgeInsets.all(kBodyHp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      city.city,
                      style: titleSmallStyle(
                        context,
                      ).copyWith(color: kWhite, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Icon(
                    isSelected ? Icons.my_location : Icons.location_on,
                    color: kWhite,
                    size: smallIcon(context),
                  ),
                ],
              ),
              const Gap(kGap),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$temp°',
                    style: headlineMediumStyle(context).copyWith(color: kWhite),
                  ),
                  const Gap(kGap),
                  Flexible(
                    child: Text(
                      condition,
                      style: bodyMediumStyle(context).copyWith(color: kWhite),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Gap(kGap),
              Text(
                airQuality,
                style: bodyMediumStyle(context).copyWith(color: kWhite),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    });
  }
}
