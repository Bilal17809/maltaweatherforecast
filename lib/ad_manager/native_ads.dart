import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:maltaweatherforecast/ad_manager/remove_ads.dart';
import 'package:shimmer/shimmer.dart';
import '../core/constants/constants.dart';
import '../core/services/services.dart';
import '../core/theme/theme.dart';

// class NativeAdManager extends GetxController {
//   NativeAd? _nativeAd;
//   final RxBool isAdLoaded = false.obs;
//   final RxBool isAdLoading = false.obs;
//   final RxBool hasError = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     initRemoteConfig();
//     _loadNativeAd();
//   }
//
//   @override
//   void onClose() {
//     _nativeAd?.dispose();
//     super.onClose();
//   }
//
//   String get _adUnitId {
//     return Platform.isAndroid
//         ? 'ca-app-pub-8172082069591999/8558354089'
//         : throw UnsupportedError('Unsupported platform');
//   }
//
//   Future<void> initRemoteConfig() async {
//     try {
//       await RemoteConfigService().init();
//       final showNativeAd = RemoteConfigService().getBool('NativeAdv', '');
//       if (showNativeAd) {
//         _loadNativeAd();
//       }
//     } catch (e) {
//       debugPrint("Failed to init native remote config: $e");
//     }
//   }
//
//   void _loadNativeAd() {
//     if (_nativeAd != null || isAdLoading.value) return;
//
//     isAdLoading.value = true;
//     hasError.value = false;
//
//     _nativeAd = NativeAd(
//       adUnitId: _adUnitId,
//       factoryId: 'listTile',
//       request: const AdRequest(),
//       listener: NativeAdListener(
//         onAdLoaded: (ad) {
//           debugPrint('Native ad loaded successfully');
//           isAdLoaded.value = true;
//           isAdLoading.value = false;
//           hasError.value = false;
//         },
//         onAdFailedToLoad: (ad, error) {
//           debugPrint('Failed to load native ad: ${error.toString()}');
//           ad.dispose();
//           _nativeAd = null;
//           isAdLoaded.value = false;
//           isAdLoading.value = false;
//           hasError.value = true;
//           Future.delayed(const Duration(seconds: 5), () {
//             if (!isAdLoaded.value && !isAdLoading.value) {
//               _loadNativeAd();
//             }
//           });
//         },
//         onAdClicked: (ad) {
//           debugPrint('Native ad clicked');
//         },
//         onAdImpression: (ad) {
//           debugPrint('Native ad impression recorded');
//         },
//       ),
//     );
//
//     _nativeAd!.load();
//   }
//
//   void reloadAd() {
//     if (_nativeAd != null) {
//       _nativeAd!.dispose();
//       _nativeAd = null;
//     }
//     isAdLoaded.value = false;
//     isAdLoading.value = false;
//     hasError.value = false;
//     _loadNativeAd();
//   }
//
//   Widget showNativeAd() {
//     if (isAdLoaded.value && _nativeAd != null) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
//         child: Container(
//           height: 90,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.1),
//                 blurRadius: 4,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: AdWidget(ad: _nativeAd!),
//           ),
//         ),
//       );
//     } else if (isAdLoading.value) {
//       return const NativeAdShimmer();
//     } else if (hasError.value) {
//       return Container(
//         height: 90,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.grey[100],
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.error_outline, color: Colors.grey[600], size: 24),
//               const SizedBox(height: 4),
//               Text(
//                 'Ad failed to load',
//                 style: TextStyle(color: Colors.grey[600], fontSize: 12),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//     return const SizedBox.shrink();
//   }
// }

class NativeAdShimmer extends StatelessWidget {
  const NativeAdShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
      child: Shimmer.fromColors(
        baseColor: getPrimaryColor(context).withValues(alpha: 0.4),
        highlightColor: getPrimaryColor(context).withValues(alpha: 0.6),
        child: Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}





class NativeAdController extends GetxController {
  NativeAd? _nativeAd;
  final RxBool isAdReady = false.obs;
  bool showAd = false;

  final TemplateType templateType;

  NativeAdController({this.templateType = TemplateType.small});

  @override
  void onInit() {
    super.onInit();
    initializeRemoteConfig();
  }

  Future<void> initializeRemoteConfig() async {
    try {
      // final remoteConfig = FirebaseRemoteConfig.instance;
      //
      // await remoteConfig.setConfigSettings(
      //   RemoteConfigSettings(
      //     fetchTimeout: const Duration(seconds: 3),
      //     minimumFetchInterval: const Duration(seconds: 1),
      //   ),
      // );
      // await remoteConfig.fetchAndActivate();
      // final key = Platform.isAndroid ? 'NativeAdvAd' : 'NativeAdv';
      // showAd = remoteConfig.getBool(key);
      await RemoteConfigService().init();
      final showAd = RemoteConfigService().getBool('NativeAdv','NativeAdvAd');

      if (showAd) {
        loadNativeAd();
      } else {
        print('Native ad disabled via Remote Config.');
      }
    } catch (e) {
      print('Error fetching remote config: $e');
    }
  }

  void loadNativeAd() {
    isAdReady.value = false;

    final adUnitId = Platform.isAndroid
        ? 'ca-app-pub-8172082069591999/8558354089'
        : 'ca-app-pub-5405847310750111/9655350315';

    _nativeAd = NativeAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          _nativeAd = ad as NativeAd;
          isAdReady.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          isAdReady.value = false;
          ad.dispose();
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        mainBackgroundColor: Colors.white,
        templateType: templateType,
      ),
    );

    _nativeAd!.load();
  }

  @override
  void onClose() {
    _nativeAd?.dispose();
    super.onClose();
  }
}

class MyNativeAdWidget extends StatefulWidget {
  final TemplateType templateType;

  const MyNativeAdWidget({
    Key? key,
    this.templateType = TemplateType.small,
  }) : super(key: key);

  @override
  _MyNativeAdWidgetState createState() => _MyNativeAdWidgetState();
}

class _MyNativeAdWidgetState extends State<MyNativeAdWidget> {
  late final NativeAdController _adController;
  late final String _tag;
  final RemoveAds removeAds = Get.find<RemoveAds>();

  @override
  void initState() {
    super.initState();
    _tag = UniqueKey().toString();
    _adController = Get.put(
      NativeAdController(templateType: widget.templateType),
      tag: _tag,
    );
    _adController.loadNativeAd();
  }

  @override
  void dispose() {
    Get.delete<NativeAdController>(tag: _tag);
    super.dispose();
  }

  Widget shimmerWidget(double width) {
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer Image
            AspectRatio(
              aspectRatio: 55 / 15,
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // First Text Line
            Container(
              width: double.infinity,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: width * 0.7,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS && removeAds.isSubscribedGet.value) {
      return const SizedBox();
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final adHeight = widget.templateType == TemplateType.medium
        ? screenHeight * 0.48
        : screenHeight * 0.14;

    return Obx(() {
      if (_adController.isAdReady.value && _adController._nativeAd != null) {
        return Container(
          height: adHeight,
          margin: const EdgeInsets.symmetric(vertical:5,horizontal:5),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AdWidget(ad: _adController._nativeAd!),
        );
      } else {
        return shimmerWidget(adHeight);
      }
    });
  }
}