import Flutter
import UIKit
import Photos

public class PhotoGalleryPlugin: NSObject, FlutterPlugin {
  private let channel: FlutterMethodChannel

  init(channel: FlutterMethodChannel) {
    self.channel = channel
    super.init()
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "com.photogallary.cheq/gallery",
      binaryMessenger: registrar.messenger()
    )
    let instance = PhotoGalleryPlugin(channel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getImages":
      // Directly fetch assets without permission checks here
      retrieveAssets(result: result)
    case "saveAndFetchPhoto":
          // Expecting arguments as a dictionary with key "path"
          guard let args = call.arguments as? [String: Any],
                let sourcePath = args["path"] as? String else {
            result(FlutterError(
              code: "INVALID_ARGUMENT",
              message: "Expected map with key 'path' pointing to String",
              details: nil
            ))
            return
          }
          saveAndFetchPhoto(sourcePath: sourcePath, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func retrieveAssets(result: @escaping FlutterResult) {
    var photosArray: [[String: Any]] = []

    // Configure fetch: descending by creation date
    let options = PHFetchOptions()

    options.sortDescriptors = [
      NSSortDescriptor(key: "modificationDate", ascending: false)
    ]

    let assets = PHAsset.fetchAssets(with: .image, options: options)

    assets.enumerateObjects { asset, _, _ in
      let id = asset.localIdentifier
      let width = asset.pixelWidth
      let height = asset.pixelHeight
      let timestamp = asset.creationDate?.timeIntervalSince1970 ?? 0

      // Get resource info
      let resources = PHAssetResource.assetResources(for: asset)
      guard let resource = resources.first else { return }
      let filename = resource.originalFilename
      let fileSize = (resource.value(forKey: "fileSize") as? Int) ?? 0

      // Export to temporary file
      let tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
        .appendingPathComponent(filename)
      let reqOpts = PHAssetResourceRequestOptions()
      reqOpts.isNetworkAccessAllowed = true
      PHAssetResourceManager.default()
        .writeData(for: resource, toFile: tempURL, options: reqOpts) { _ in }

      // Append photo metadata
      photosArray.append([
        "id": id,
        "uri": id,
        "name": filename,
        "size": fileSize,
        "timestamp": timestamp,
        "path": tempURL.path,
        "width": width,
        "height": height,
        "orientation": 0
      ])
    }

    // Return results
    result(photosArray)
  }
    
   private func saveAndFetchPhoto(sourcePath: String, result: @escaping FlutterResult) {
       let fileURL = URL(fileURLWithPath: sourcePath)
       var placeholderId: String?

       PHPhotoLibrary.shared().performChanges({
         if let req = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileURL) {
           placeholderId = req.placeholderForCreatedAsset?.localIdentifier
         }
       }, completionHandler: { success, error in
         DispatchQueue.main.async {
           if let error = error {
             result(FlutterError(code: "SAVE_FAILED", message: error.localizedDescription, details: nil))
             return
           }
           guard success, let id = placeholderId else {
             result(FlutterError(code: "SAVE_FAILED", message: "Unknown save error", details: nil))
             return
           }

           let assets = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
           guard let asset = assets.firstObject else {
             result(FlutterError(code: "FETCH_FAILED", message: "Saved image not found", details: nil))
             return
           }

           let imgOptions = PHImageRequestOptions()
           imgOptions.isSynchronous = false
           imgOptions.isNetworkAccessAllowed = true
           imgOptions.version = .current
           imgOptions.deliveryMode = .highQualityFormat

           let fetchHandler: (Data?, String?, Any, [AnyHashable: Any]?) -> Void = { data, _, orientationRaw, _ in
             guard let data = data else {
               result(FlutterError(code: "FETCH_FAILED", message: "Failed to get image data", details: nil))
               return
             }
             let filename = asset.value(forKey: "filename") as? String ?? "image.jpg"
             let tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
               .appendingPathComponent(filename)
             do { try data.write(to: tempURL) } catch {
               result(FlutterError(code: "FETCH_FAILED", message: "Write error: \(error.localizedDescription)", details: nil))
               return
             }
             let fileSize = (try? FileManager.default.attributesOfItem(atPath: tempURL.path)[.size] as? NSNumber)?.intValue ?? 0
             let meta: [String: Any] = [
               "id": asset.localIdentifier,
               "uri": asset.localIdentifier,
               "name": filename,
               "size": fileSize,
               "timestamp": asset.creationDate?.timeIntervalSince1970 ?? 0,
               "path": tempURL.path,
               "width": asset.pixelWidth,
               "height": asset.pixelHeight,
               "orientation": (orientationRaw as? UInt32).flatMap({ Int32(bitPattern: $0) }) ?? Int32(orientationRaw as? Int ?? 0)
             ]
             result(meta)
           }

           if #available(iOS 13, *) {
             PHImageManager.default().requestImageDataAndOrientation(for: asset, options: imgOptions, resultHandler: fetchHandler)
           } else {
             PHImageManager.default().requestImageData(for: asset, options: imgOptions, resultHandler: fetchHandler)
           }
         }
       })
     }
}
