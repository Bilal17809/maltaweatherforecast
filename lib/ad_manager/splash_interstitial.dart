import 'dart:io';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SplashInterstitialManager extends GetxController {
  InterstitialAd? _splashAd;
  bool _isAdReady = false;
  var isShowing = false.obs;
  bool displaySplashAd = true;

  @override
  void onInit() {
    super.onInit();
    _initRemoteConfig();
    _loadAd();
  }

  @override
  void onClose() {
    _splashAd?.dispose();
    super.onClose();
  }

  String get _adUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8172082069591999/9021905439';
    } else if (Platform.isIOS) {
      return '';
    } else {
      throw UnsupportedError("Platform not supported");
    }
  }

  Future<void> _initRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(seconds: 1),
        ),
      );
      String interstitialKey;
      if (Platform.isAndroid) {
        interstitialKey = 'SplashInterstitial';
      } else if (Platform.isIOS) {
        interstitialKey = 'SplashInterstitial';
      } else {
        throw UnsupportedError('Unsupported platform');
      }
      await remoteConfig.fetchAndActivate();
      displaySplashAd = remoteConfig.getBool(interstitialKey);
      debugPrint("Splash Interstitial Ad Enabled: $showSplashAd");
      _loadAd();
      update();
    } catch (e) {
      debugPrint('Error fetching Remote Config: $e');
      displaySplashAd = false;
    }
  }

  void _loadAd() {
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _splashAd = ad;
          _isAdReady = true;
          update();
        },
        onAdFailedToLoad: (error) {
          _isAdReady = false;
          debugPrint("Splash Interstitial load error: $error");
        },
      ),
    );
  }

  void showSplashAd(VoidCallback onAdClosed) {
    if (_splashAd == null || !_isAdReady) {
      debugPrint("Splash Interstitial not ready.");
      onAdClosed();
      return;
    }

    isShowing.value = true;

    _splashAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        isShowing.value = false;
        _resetAfterAd();
        onAdClosed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint("Splash Interstitial failed: $error");
        ad.dispose();
        isShowing.value = false;
        _resetAfterAd();
        onAdClosed();
      },
    );

    _splashAd!.show();
    _splashAd = null;
    _isAdReady = false;
  }

  void _resetAfterAd() {
    _isAdReady = false;
    _loadAd();
    update();
  }
}
