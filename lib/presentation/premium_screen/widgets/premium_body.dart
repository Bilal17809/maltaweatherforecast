import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/core/theme/theme.dart';
import '../../terms/terms_view.dart';
import '/core/common_widgets/common_widgets.dart';

class PremiumBody extends StatelessWidget {
  final bool loading;
  final bool purchasePending;
  final String? queryProductError;
  final VoidCallback onRestorePurchases;
  final Widget productListBuilder;
  final VoidCallback onClose;

  const PremiumBody({
    super.key,
    required this.loading,
    required this.purchasePending,
    required this.queryProductError,
    required this.onRestorePurchases,
    required this.productListBuilder,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (queryProductError != null) {
      return Center(child: Text(queryProductError!));
    }

    final List<Map<String, dynamic>> items = [
      {'icon': 'images/forecast.png', 'text': 'Real Time Forecast'},
      {'icon': 'images/weather_widget.png', 'text': 'Weather Icon'},
      {'icon': 'images/minimal.png', 'text': 'Minimal Ui'},
      {'icon': 'images/aqi.png', 'text': 'Aqi Index'},
    ];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          final bool isSmallScreen = width < 600;

          return SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: height),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: height * 0.32,
                        color: Colors.blue.withAlpha(200),
                      ),
                      Container(
                        height: height * 0.19,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(0, -100),
                              blurRadius: 110,
                              spreadRadius: 90,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.04),
                            SizedBox(
                              height: isSmallScreen ? 100 : height * 0.16,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      width: width * 0.4,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      decoration: roundedDecor(context),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              items[index]['icon'],
                                              width: isSmallScreen
                                                  ? 55
                                                  : height * 0.08,
                                              height: isSmallScreen
                                                  ? 55
                                                  : height * 0.08,
                                              fit: BoxFit.contain,
                                            ),
                                            const SizedBox(height: 6),
                                            Flexible(
                                              child: Text(
                                                items[index]['text'],
                                                style: TextStyle(
                                                  fontSize: isSmallScreen
                                                      ? 12
                                                      : height * 0.016,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: height * 0.05),
                            productListBuilder,
                            Column(
                              children: [
                                const Text(
                                  '>> Cancel anytime at least 24 hours before renewal',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: height * 0.03),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      child: const Text("Privacy | Terms"),
                                      onTap: () {
                                        Get.to(() => TermsView());
                                      },
                                    ),
                                    const Text("Cancel Anytime"),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 28),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Top Buttons
                  Positioned(
                    top: 8,
                    left: 8,
                    right: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GlassButton(icon: Icons.clear, onTap: onClose),
                        GlassButton(
                          text: "Restore",
                          width: 70,
                          onTap: onRestorePurchases,
                        ),
                      ],
                    ),
                  ),

                  // Headings
                  Positioned(
                    left: width * 0.08,
                    right: width * 0.08,
                    top: height * 0.36,
                    child: const Text(
                      "Forecast Without Limits",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize:22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                    left: width * 0.08,
                    right: width * 0.08,
                    top: height * 0.42,
                    child: const Text(
                      "Accurate weather, anytime, anywhere – always at your fingertips.",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Splash Icon
                  Positioned(
                    top: height * 0.02,
                    left: width * 0.20,
                    right: width * 0.20,
                    child: Image.asset(
                      'images/splash-icon.png',
                      height: height * 0.34,
                      fit: BoxFit.contain,
                    ),
                  ),

                  // Offer Icon
                  Positioned(
                    left: width * 0.65,
                    right: width * 0.01,
                    top: height * 0.74,
                    child: Image.asset(
                      "images/offer.png",
                      height: 64,
                      width: 64,
                    ),
                  ),

                  // Modal Overlay
                  if (purchasePending)
                    const Opacity(
                      opacity: 0.3,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
