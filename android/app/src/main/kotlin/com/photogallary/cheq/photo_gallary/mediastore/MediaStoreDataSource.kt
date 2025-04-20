package com.photogallary.cheq.photo_gallary.mediastore

import android.content.Context
import android.provider.MediaStore
import com.photogallary.cheq.photo_gallary.mediastore.model.Photo
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class MediaStoreDataSource(private val context:Context) {
    suspend fun getPhotos(): Result<List<Photo>> = withContext(Dispatchers.IO) {
        return@withContext runCatching {
            val photos = mutableListOf<Photo>()
            photos.addAll(fetchAllPhotos(context,MediaStore.Images.Media.EXTERNAL_CONTENT_URI))
            photos
        }
    }

    suspend fun saveAndFetchPhoto(context: Context, sourcePath: String): Result<Photo?> = withContext(Dispatchers.IO) {
        return@withContext runCatching {
            saveImageAndFetchPhoto(context,sourcePath)
        }
    }
}