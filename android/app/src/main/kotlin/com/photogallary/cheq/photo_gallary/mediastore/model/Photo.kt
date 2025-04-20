package com.photogallary.cheq.photo_gallary.mediastore.model


data class Photo (
    val id : Long,
    val uri: String,
    val name: String,
    val size: Long,   // File size in bytes
    val timestamp: Long? = null,
    val path:String,
    val width : Int,
    val height : Int,
    val orientation: Int
){
    // Manually implement toJson() method to convert Media to Map<String, dynamic>
    fun toJson(): Map<String, Any?> {
        return mapOf(
            "id" to id,
            "uri" to uri,
            "name" to name,
            "size" to size,
            "timestamp" to timestamp,
            "path" to path,
            "width" to width,
            "height" to height,
            "orientation" to orientation
        )
    }
}