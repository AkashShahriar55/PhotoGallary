package com.photogallary.cheq.photo_gallary.mediastore

import android.content.ContentUris
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import com.photogallary.cheq.photo_gallary.mediastore.model.Photo
import java.io.File
import java.io.FileInputStream


fun fetchAllPhotos(context: Context, uri: Uri): List<Photo> {
    val photos = mutableListOf<Photo>()

    val projectionList = mutableListOf(
        MediaStore.MediaColumns._ID,
        MediaStore.MediaColumns.DISPLAY_NAME,
        MediaStore.MediaColumns.SIZE,
        MediaStore.MediaColumns.DATE_MODIFIED,
        MediaStore.Images.Media.DATA,
        MediaStore.MediaColumns.BUCKET_ID,
        MediaStore.MediaColumns.HEIGHT,
        MediaStore.MediaColumns.WIDTH,
        MediaStore.MediaColumns.ORIENTATION
    )


    val orderBy = "${MediaStore.Images.Media.DATE_MODIFIED} DESC"

    context.contentResolver.query(uri, projectionList.toTypedArray(), null, null, orderBy)?.use { cursor ->
        val idColumn = cursor.getColumnIndexOrThrow(MediaStore.MediaColumns._ID)
        val nameColumn = cursor.getColumnIndexOrThrow(MediaStore.MediaColumns.DISPLAY_NAME)
        val sizeColumn = cursor.getColumnIndexOrThrow(MediaStore.MediaColumns.SIZE)
        val dateColumn = cursor.getColumnIndexOrThrow(MediaStore.MediaColumns.DATE_MODIFIED)
        val imageUriIndex = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA)
        val widthIndex = cursor.getColumnIndexOrThrow(MediaStore.MediaColumns.WIDTH)
        val heightIndex = cursor.getColumnIndexOrThrow(MediaStore.MediaColumns.HEIGHT)
        val orientationIndex = cursor.getColumnIndexOrThrow(MediaStore.MediaColumns.ORIENTATION)
        while (cursor.moveToNext()) {
            val mediaId = cursor.getLong(idColumn)
            val mediaUri = ContentUris.withAppendedId(uri, mediaId)
            val fileName = cursor.getString(nameColumn) ?: "Unknown"
            val imagePath = cursor.getString(imageUriIndex)
            val fileSize = cursor.getLong(sizeColumn)
            val width = cursor.getInt(widthIndex)
            val height = cursor.getInt(heightIndex)
            val orientation = cursor.getInt(orientationIndex)

            val timestamp = cursor.getLong(dateColumn) * 1000

            photos.add(
                Photo(
                    id = mediaId,
                    uri = mediaUri.toString(),
                    name = fileName,
                    size = fileSize,
                    timestamp = timestamp,
                    path = imagePath,
                    width = width,
                    height = height,
                    orientation = orientation
                )
            )
        }
        cursor.close()
    }
    return photos
}


@Throws(Exception::class)
fun saveImageAndFetchPhoto(context: Context, sourcePath: String): Photo? {
    val sourceFile = File(sourcePath)
    if (!sourceFile.exists()) throw IllegalArgumentException("Source not found: $sourcePath")

    // 1) Prepare insertion metadata
    val values = ContentValues().apply {
        put(MediaStore.Images.Media.DISPLAY_NAME, sourceFile.name)
        put(MediaStore.Images.Media.MIME_TYPE, "image/${sourceFile.extension.lowercase()}")
        put(MediaStore.Images.Media.SIZE, sourceFile.length())
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            put(MediaStore.Images.Media.RELATIVE_PATH, "Pictures/MyApp")
            put(MediaStore.Images.Media.IS_PENDING, 1)
        }
    }

    val resolver = context.contentResolver
    val collection = MediaStore.Images.Media.EXTERNAL_CONTENT_URI

    // 2) Insert into MediaStore to reserve an entry
    val itemUri: Uri = resolver.insert(collection, values)
        ?: throw Exception("Failed to create MediaStore entry.")

    try {
        // 3) Copy file bytes into that new Uri
        resolver.openOutputStream(itemUri).use { out ->
            FileInputStream(sourceFile).use { input ->
                input.copyTo(out!!)
            }
        }

        // 4) Finalize visibility
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            values.clear()
            values.put(MediaStore.Images.Media.IS_PENDING, 0)
            resolver.update(itemUri, values, null, null)
        } else {
            context.sendBroadcast(Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, itemUri))
        }

        // 5) Query back all fields
        val projection = arrayOf(
            MediaStore.Images.Media._ID,
            MediaStore.Images.Media.DISPLAY_NAME,
            MediaStore.Images.Media.SIZE,
            MediaStore.Images.Media.DATE_ADDED,
            MediaStore.Images.Media.WIDTH,
            MediaStore.Images.Media.HEIGHT,
            MediaStore.Images.Media.ORIENTATION,
            MediaStore.Images.Media.DATA
        )
        resolver.query(itemUri, projection, null, null, null)?.use { cursor ->
            if (cursor.moveToFirst()) {
                val id        = cursor.getLong(cursor.getColumnIndexOrThrow(MediaStore.Images.Media._ID))
                val name      = cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DISPLAY_NAME))
                val size      = cursor.getLong(cursor.getColumnIndexOrThrow(MediaStore.Images.Media.SIZE))
                val dateSec   = cursor.getLong(cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATE_ADDED))
                val width     = cursor.getInt(cursor.getColumnIndexOrThrow(MediaStore.Images.Media.WIDTH))
                val height    = cursor.getInt(cursor.getColumnIndexOrThrow(MediaStore.Images.Media.HEIGHT))
                val orient    = cursor.getInt(cursor.getColumnIndexOrThrow(MediaStore.Images.Media.ORIENTATION))
                val realPath  = cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA))

                return Photo(
                    id          = id,
                    uri         = ContentUris.withAppendedId(collection, id).toString(),
                    name        = name,
                    size        = size,
                    timestamp   = dateSec * 1000,     // convert seconds to ms
                    path        = realPath,
                    width       = width,
                    height      = height,
                    orientation = orient
                )
            }
        }
    } catch (e: Exception) {
        // cleanup on failure
        resolver.delete(itemUri, null, null)
        throw e
    }

    return null
}
