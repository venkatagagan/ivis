// Generated file.
//
// If you wish to remove Flutter's multidex support, delete this entire file.
//
// Modifications to this file should be done in a copy under a different name
// as this file may be regenerated.

package io.flutter.app;

import androidx.multidex.MultiDex;
import androidx.multidex.MultiDexApplication;
import android.content.Context;
import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

/**
 * Extension of {@link android.app.Application}, adding multidex support.
 */
public class FlutterMultiDexApplication extends MultiDexApplication {
  @Override
  protected void attachBaseContext(Context base) {
    super.attachBaseContext(base);
    MultiDex.install(this);
  }
}