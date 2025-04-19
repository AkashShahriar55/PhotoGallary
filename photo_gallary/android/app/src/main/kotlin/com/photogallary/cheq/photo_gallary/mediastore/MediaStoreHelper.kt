package com.photogallary.cheq.photo_gallary.mediastore

import android.content.ContentUris
import android.content.Context
import android.net.Uri
import android.provider.MediaStore
import com.photogallary.cheq.photo_gallary.mediastore.model.Photo


fun fetchAllPhotosPaginated(context: Context,uri: Uri): List<Photo> {
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
        while (cursor.moveToNext()) {
            val mediaId = cursor.getLong(idColumn)
            val mediaUri = ContentUris.withAppendedId(uri, mediaId)
            val fileName = cursor.getString(nameColumn) ?: "Unknown"
            val imagePath = cursor.getString(imageUriIndex)
            val fileSize = cursor.getLong(sizeColumn)
            val width = cursor.getInt(widthIndex)
            val height = cursor.getInt(heightIndex)

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
                    height = height
                )
            )
        }
        cursor.close()
    }
    return photos
}