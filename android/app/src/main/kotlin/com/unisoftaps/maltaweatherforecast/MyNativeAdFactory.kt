package com.unisoftaps.maltaweatherforecast

import android.content.Context
import android.view.LayoutInflater
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class MyNativeAdFactory(private val context: Context) : NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val adView = LayoutInflater.from(context)
            .inflate(R.layout.native_ad_layout, null) as NativeAdView

        val headlineView = adView.findViewById<TextView>(R.id.ad_headline)
        val bodyView = adView.findViewById<TextView>(R.id.ad_body)
        val callToActionView = adView.findViewById<Button>(R.id.ad_call_to_action)
        val iconView = adView.findViewById<ImageView>(R.id.ad_icon)
        val advertiserView = adView.findViewById<TextView>(R.id.ad_advertiser)

        adView.headlineView = headlineView
        adView.bodyView = bodyView
        adView.callToActionView = callToActionView
        adView.iconView = iconView
        adView.advertiserView = advertiserView

        headlineView?.text = nativeAd.headline

        bodyView?.text = nativeAd.body
        bodyView?.visibility = if (nativeAd.body != null) android.view.View.VISIBLE else android.view.View.GONE

        callToActionView?.text = nativeAd.callToAction
        callToActionView?.visibility = if (nativeAd.callToAction != null) android.view.View.VISIBLE else android.view.View.GONE

        if (nativeAd.icon != null) {
            iconView?.setImageDrawable(nativeAd.icon?.drawable)
            iconView?.visibility = android.view.View.VISIBLE
        } else {
            iconView?.visibility = android.view.View.GONE
        }

        advertiserView?.text = nativeAd.advertiser
        advertiserView?.visibility = if (nativeAd.advertiser != null) android.view.View.VISIBLE else android.view.View.GONE

        adView.setNativeAd(nativeAd)

        return adView
    }
}