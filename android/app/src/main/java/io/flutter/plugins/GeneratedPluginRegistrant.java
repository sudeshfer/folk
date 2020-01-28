package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import rocks.biessek.fluttercountrypicker.FlutterCountryPickerPlugin;
import com.roughike.facebooklogin.facebooklogin.FacebookLoginPlugin;
import com.babariviere.sms.SmsPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    FlutterCountryPickerPlugin.registerWith(registry.registrarFor("rocks.biessek.fluttercountrypicker.FlutterCountryPickerPlugin"));
    FacebookLoginPlugin.registerWith(registry.registrarFor("com.roughike.facebooklogin.facebooklogin.FacebookLoginPlugin"));
    SmsPlugin.registerWith(registry.registrarFor("com.babariviere.sms.SmsPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
