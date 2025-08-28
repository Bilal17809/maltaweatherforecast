import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '/ad_manager/ad_manager.dart';

class ProductListWidget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final List<ProductDetails> products;
  final List<PurchaseDetails> purchases;
  final RemoveAds removeAdsController;
  final void Function(
    BuildContext context,
    ProductDetails product,
    PurchaseDetails? purchase,
  )
  showPurchaseDialog;
  final bool mounted;

  const ProductListWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.products,
    required this.purchases,
    required this.removeAdsController,
    required this.showPurchaseDialog,
    required this.mounted,
  });

  @override
  Widget build(BuildContext context) {
    double horizontalPadding = screenWidth * 0.02;
    double verticalPadding = screenHeight * 0.01;
    bool isSmallScreen = screenWidth < 600;

    final Map<String, PurchaseDetails> purchaseMap = {
      for (var purchase in purchases) purchase.productID: purchase,
    };

    bool isSubscribed = removeAdsController.isSubscribedGet.value;

    return Column(
      children: products.map((product) {
        final purchase = purchaseMap[product.id];

        if (isSubscribed) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: const Text(
              "You are on the ads-free version!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          );
        }

        return Card(
          color: Colors.blue.shade300,
          elevation: 1.0,
          margin: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: ListTile(
            title: Text(
              'Life Time Subscription',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 16 : screenHeight * 0.02,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              product.description,
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : screenHeight * 0.02,
                color: Colors.white,
              ),
            ),
            trailing: Text(
              product.price,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: isSmallScreen ? 16 : screenHeight * 0.02,
              ),
            ),
            onTap: () {
              if (mounted) {
                showPurchaseDialog(context, product, purchase);
              }
            },
          ),
        );
      }).toList(),
    );
  }
}
