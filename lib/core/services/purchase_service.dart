import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '/core/local_storage/local_storage.dart';
import '/ad_manager/ad_manager.dart';

class PurchaseService {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final RemoveAds removeAdsController = Get.put(RemoveAds());

  late StreamSubscription<List<PurchaseDetails>> _subscription;

  bool _purchasePending = false;
  bool get purchasePending => _purchasePending;

  bool _isAvailable = false;
  bool get isAvailable => _isAvailable;

  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  List<PurchaseDetails> _purchases = [];
  List<PurchaseDetails> get purchases => _purchases;

  String? _queryProductError;
  String? get queryProductError => _queryProductError;

  final bool _kAutoConsume = Platform.isIOS || true;
  final List<String> _kProductIds = const [
    'consumable',
    'upgrade',
    'com.maltaweatherremoveads',
  ];

  Future<void> init(void Function(void Function()) setState) async {
    _checkInternetConnection();

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (details) => _listenToPurchaseUpdated(details, setState),
      onDone: () => _subscription.cancel(),
      onError: (Object error) {
        debugPrint('Error in purchase stream: $error');
        if (Navigator.of(Get.context!).canPop()) {
          Navigator.of(Get.context!).pop();
        }
        setState(() => _purchasePending = false);
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text('Purchase stream error: ${error.toString()}')),
        );
      },
    );

    await initStoreInfo(setState);
  }

  void dispose() {
    _subscription.cancel();
  }

  Future<void> _checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.mobile) &&
        !connectivityResult.contains(ConnectivityResult.wifi)) {
      if (!Get.context!.mounted) return;
      ScaffoldMessenger.of(
        Get.context!,
      ).showSnackBar(const SnackBar(content: Text("No Internet Available")));
    }
  }

  Future<void> initStoreInfo(void Function(void Function()) setState) async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      setState(() {
        _isAvailable = false;
        _products = [];
        _purchases = [];
        _queryProductError = null;
        _purchasePending = false;
      });
      return;
    }

    final ProductDetailsResponse productDetailResponse = await _inAppPurchase
        .queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = available;
      });
      return;
    }

    setState(() {
      _isAvailable = available;
      _products = productDetailResponse.productDetails;
    });
  }

  Future<void> buyProduct(
    ProductDetails product,
    PurchaseDetails? purchase,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Connecting to store...'),
          ],
        ),
      ),
    );

    try {
      final purchaseParam = GooglePlayPurchaseParam(
        productDetails: product,
        changeSubscriptionParam:
            purchase != null && purchase is GooglePlayPurchaseDetails
            ? ChangeSubscriptionParam(oldPurchaseDetails: purchase)
            : null,
      );

      if (product.id == 'consumable') {
        await _inAppPurchase.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume: _kAutoConsume,
        );
      } else {
        await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      }
    } catch (e) {
      debugPrint('Purchase initiation error: $e');
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Failed to initiate purchase: ${e.toString()}')),
      );
      if (Navigator.of(Get.context!).canPop()) {
        Navigator.of(Get.context!).pop();
      }
    }
  }

  Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> detailsList,
    void Function(void Function()) setState,
  ) async {
    for (var details in detailsList) {
      if (details.status == PurchaseStatus.pending) {
        setState(() => _purchasePending = true);
      } else if (details.status == PurchaseStatus.error) {
        setState(() => _purchasePending = false);
        if (Navigator.of(Get.context!).canPop()) {
          Navigator.of(Get.context!).pop();
        }
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text(
              'Purchase failed: ${details.error?.message ?? "Unknown error"}',
            ),
          ),
        );
      } else if (details.status == PurchaseStatus.purchased ||
          details.status == PurchaseStatus.restored) {
        setState(() => _purchasePending = false);
        if (Navigator.of(Get.context!).canPop()) {
          Navigator.of(Get.context!).pop();
        }

        final prefs = LocalStorage();
        await prefs.setBool('SubscribeMalta', true);
        await prefs.setString('subscriptionAiId', details.productID);

        removeAdsController.isSubscribedGet(true);

        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Subscription purchased successfully!')),
        );

        if (details.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(details);
        }
      }
    }
  }

  Future<void> restorePurchases(
    BuildContext context,
    void Function(void Function()) setState,
  ) async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      ScaffoldMessenger.of(
        Get.context!,
      ).showSnackBar(const SnackBar(content: Text('Store is not available!')));
      return;
    }

    setState(() => _purchasePending = true);

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Restoring purchases...'),
          ],
        ),
      ),
    );

    try {
      await _inAppPurchase.restorePurchases();
      Timer(const Duration(seconds: 15), () {
        if (_purchasePending) {
          setState(() => _purchasePending = false);
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Restore timed out or no purchases found.'),
            ),
          );
        }
      });
    } catch (e) {
      setState(() => _purchasePending = false);
      if (Navigator.of(Get.context!).canPop()) {
        Navigator.of(Get.context!).pop();
      }
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('An error occurred during restore: $e')),
      );
    }
  }
}
