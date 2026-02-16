import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // Set up iCloud platform channel
    let controller = window?.rootViewController as! FlutterViewController
    let iCloudChannel = FlutterMethodChannel(
      name: "com.billiardresults.app/icloud",
      binaryMessenger: controller.binaryMessenger
    )
    
    iCloudChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      self?.handleICloudMethod(call: call, result: result)
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func handleICloudMethod(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "saveToICloud":
      guard let args = call.arguments as? [String: Any],
            let fileName = args["fileName"] as? String,
            let content = args["content"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing fileName or content", details: nil))
        return
      }
      saveToICloud(fileName: fileName, content: content, result: result)
      
    case "loadFromICloud":
      guard let args = call.arguments as? [String: Any],
            let fileName = args["fileName"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing fileName", details: nil))
        return
      }
      loadFromICloud(fileName: fileName, result: result)
      
    case "fileExists":
      guard let args = call.arguments as? [String: Any],
            let fileName = args["fileName"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing fileName", details: nil))
        return
      }
      fileExistsInICloud(fileName: fileName, result: result)
      
    case "getFileModifiedDate":
      guard let args = call.arguments as? [String: Any],
            let fileName = args["fileName"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing fileName", details: nil))
        return
      }
      getFileModifiedDate(fileName: fileName, result: result)
      
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func getICloudURL() -> URL? {
    return FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
  }
  
  private func saveToICloud(fileName: String, content: String, result: @escaping FlutterResult) {
    guard let iCloudURL = getICloudURL() else {
      result(FlutterError(code: "UNAVAILABLE", message: "iCloud not available", details: nil))
      return
    }
    
    let fileURL = iCloudURL.appendingPathComponent(fileName)
    
    do {
      // Create Documents directory if it doesn't exist
      try FileManager.default.createDirectory(at: iCloudURL, withIntermediateDirectories: true, attributes: nil)
      
      // Write file
      try content.write(to: fileURL, atomically: true, encoding: .utf8)
      result(true)
    } catch {
      result(FlutterError(code: "WRITE_ERROR", message: "Failed to write to iCloud: \\(error.localizedDescription)", details: nil))
    }
  }
  
  private func loadFromICloud(fileName: String, result: @escaping FlutterResult) {
    guard let iCloudURL = getICloudURL() else {
      result(FlutterError(code: "UNAVAILABLE", message: "iCloud not available", details: nil))
      return
    }
    
    let fileURL = iCloudURL.appendingPathComponent(fileName)
    
    do {
      let content = try String(contentsOf: fileURL, encoding: .utf8)
      result(content)
    } catch {
      result(FlutterError(code: "READ_ERROR", message: "Failed to read from iCloud: \\(error.localizedDescription)", details: nil))
    }
  }
  
  private func fileExistsInICloud(fileName: String, result: @escaping FlutterResult) {
    guard let iCloudURL = getICloudURL() else {
      result(false)
      return
    }
    
    let fileURL = iCloudURL.appendingPathComponent(fileName)
    let exists = FileManager.default.fileExists(atPath: fileURL.path)
    result(exists)
  }
  
  private func getFileModifiedDate(fileName: String, result: @escaping FlutterResult) {
    guard let iCloudURL = getICloudURL() else {
      result(nil)
      return
    }
    
    let fileURL = iCloudURL.appendingPathComponent(fileName)
    
    do {
      let attributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
      if let modificationDate = attributes[.modificationDate] as? Date {
        let formatter = ISO8601DateFormatter()
        result(formatter.string(from: modificationDate))
      } else {
        result(nil)
      }
    } catch {
      result(nil)
    }
  }
}
