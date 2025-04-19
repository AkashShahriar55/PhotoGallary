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
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func retrieveAssets(result: @escaping FlutterResult) {
    var photosArray: [[String: Any]] = []

    // Configure fetch: descending by creation date
    let options = PHFetchOptions()
    options.sortDescriptors = [
      NSSortDescriptor(key: "creationDate", ascending: false)
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
}
