package bored.codebyk.mint_task

import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.os.Build

class MainActivity: FlutterActivity() {
    private val CHANNEL = "bored.codebyk.mint_task/androidversion"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
          call, result ->
          // This method is invoked on the main thread.
          // TODO
          if (call.method == "getAndroidVersion") {
            val android_V = getAndroidVersion()
            result.success(android_V)
          } else {
            result.notImplemented()
          }
        }
      }

    fun getAndroidVersion(): Int {
        return Build.VERSION.SDK_INT
    }

}
