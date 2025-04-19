package com.photogallary.cheq.photo_gallary

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec

class MainActivity : FlutterActivity(){
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val taskQueue = flutterEngine.dartExecutor.binaryMessenger.makeBackgroundTaskQueue()
        val channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            PhotoGalleryHandler.CHANNEL_NAME,
            StandardMethodCodec.INSTANCE,
            taskQueue
        )
        channel.setMethodCallHandler(PhotoGalleryHandler(context))
    }
}
