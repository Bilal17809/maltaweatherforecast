import 'package:flutter/material.dart';
import 'package:maltaweatherforecast/presentation/premium_screen/widgets/premium_body.dart';
import 'package:maltaweatherforecast/presentation/premium_screen/widgets/product_list.dart';
import '../../core/constants/constants.dart';
import '../../core/services/purchase_service.dart';
import '/core/services/services.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final PurchaseService _purchaseService = PurchaseService();

  @override
  void initState() {
    super.initState();
    _purchaseService.init(setState);
  }

  @override
  void dispose() {
    _purchaseService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PremiumBody(
        loading:
            !_purchaseService.isAvailable &&
            _purchaseService.queryProductError == null,
        purchasePending: _purchaseService.purchasePending,
        queryProductError: _purchaseService.queryProductError,
        onRestorePurchases: () =>
            _purchaseService.restorePurchases(context, setState),
        productListBuilder: ProductListWidget(
          screenWidth: mobileWidth(context),
          screenHeight: mobileHeight(context),
          products: _purchaseService.products,
          purchases: _purchaseService.purchases,
          removeAdsController: _purchaseService.removeAdsController,
          showPurchaseDialog: (ctx, product, purchase) =>
              _purchaseService.buyProduct(product, purchase, ctx),
          mounted: mounted,
        ),
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }
}
