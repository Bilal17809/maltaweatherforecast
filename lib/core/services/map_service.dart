import 'package:flutter/material.dart';
import '/core/common/app_exceptions.dart';
import 'package:url_launcher/url_launcher.dart';

class MapService {
  static Future<void> openMaps(double lat, double lng) async {
    final Uri mapsUrl = Uri.parse('geo:$lat,$lng?q=$lat,$lng');

    try {
      await launchUrl(mapsUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('${AppExceptions().failMap}: $e');
      rethrow;
    }
  }
}
