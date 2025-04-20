package com.photogallary.cheq.photo_gallary

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.content.ContextCompat
import com.photogallary.cheq.photo_gallary.mediastore.MediaStoreDataSource
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch


class PhotoGalleryHandler(private val context: Context) : MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL_NAME = "com.photogallary.cheq/gallery"
    }


    private val mediaStoreDataSource = MediaStoreDataSource(context)

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getImages" -> {
                // Fetch images with pagination using coroutines
                fetchImages(result)
            }
            "saveAndFetchPhoto" -> {
                // Fetch the last image
                val path = call.argument<String>("path")
                if(path == null){
                    result.error("INVALID_ARGUMENT", "Path is required", null)
                    return
                }
                saveAndFetchPhoto(path,result)
            }
            else -> result.notImplemented()
        }
    }



    private fun fetchImages(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                // Check permissions before accessing gallery
                if (!hasStoragePermission()) {
                    throw SecurityException("Storage permission not granted")
                }
                // Fetch images asynchronously
                val images = mediaStoreDataSource.getPhotos()

                if(images.isSuccess){
                    result.success(images.getOrNull()?.map { it.toJson() })  // Return the photos to Flutter
                }else{
                    result.error("QUERY_FAILED", "Failed to fetch images: ${images.exceptionOrNull()?.message}", null)
                }

            } catch (e: Exception) {
                result.error("QUERY_FAILED", "Failed to fetch images: ${e.message}", null)
            }
        }
    }

    private fun saveAndFetchPhoto(path:String,result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                // Check permissions before accessing gallery
                if (!hasStoragePermission()) {
                    throw SecurityException("Storage permission not granted")
                }
                // Fetch the last image asynchronously
                val lastImage = mediaStoreDataSource.saveAndFetchPhoto(context,path)

                if(lastImage.isSuccess){
                    result.success(lastImage.getOrNull()?.toJson())  // Return the last image to Flutter
                }else{
                    result.error("QUERY_FAILED", "Failed to fetch last image: ${lastImage.exceptionOrNull()?.message}", null)
                }

            } catch (e: Exception) {
                result.error("QUERY_FAILED", "Failed to fetch last image: ${e.message}", null)
            }
        }
    }


    // Check if the required permission is granted
    private fun hasStoragePermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            ContextCompat.checkSelfPermission(
                context,
                android.Manifest.permission.READ_MEDIA_IMAGES
            ) == PackageManager.PERMISSION_GRANTED ||  ContextCompat.checkSelfPermission(
                context,
                android.Manifest.permission.READ_MEDIA_VISUAL_USER_SELECTED
            ) == PackageManager.PERMISSION_GRANTED
        }
        else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            ContextCompat.checkSelfPermission(
                context,
                android.Manifest.permission.READ_MEDIA_IMAGES
            ) == PackageManager.PERMISSION_GRANTED
        } else {
            ContextCompat.checkSelfPermission(
                context,
                android.Manifest.permission.READ_EXTERNAL_STORAGE
            ) == PackageManager.PERMISSION_GRANTED
        }
    }
}

