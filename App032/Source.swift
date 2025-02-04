import Foundation
import Photos
import SwiftUI
import AVFoundation
import ApphudSDK

final class Source: NSObject, ObservableObject, URLSessionDelegate {
    
    var productsApphud: Array<ApphudProduct> = []
    private var paywallID = "main"
    @Published var proSubscription = false
    var isEffect = true
    let dataManager = DataManager()
    var promt = ""
    var onAppearRequested = false
    
    var selectedEffect = ""
    var effectImage: UIImage?
    var localUrl: URL?
    var currentVideoId: String = ""
    
    func removeVideo(_ id: String) {
        guard let index = videoIDs.firstIndex(where: {$0.id == id}) else { return }
        videoIDs.remove(at: index)
        try? dataManager.removeVideo(id)
    }
    
    @Published var videoIDs: Array<Video> = []
    
    @MainActor func load(completion: @escaping (Bool) -> Void) {
        if let vids = try? dataManager.fetchVideoIds() {
            videoIDs = vids
        }
        loadPaywalls { value in
            if self.hasActiveSubscription() {
                self.proSubscription = true
            }
            completion(value)
        }
    }
    
    @MainActor
    func loadPaywalls(completion: @escaping (Bool) -> Void) {
        Apphud.paywallsDidLoadCallback { paywalls, arg in
            if let paywall = paywalls.first(where: {$0.identifier == self.paywallID}) {
                Apphud.paywallShown(paywall)
                let products = paywall.products
                self.productsApphud = products
                completion(products.count >= 2 ? true : false)
            }
        }
    }
    
    @MainActor
    func hasActiveSubscription() -> Bool {
        Apphud.hasActiveSubscription()
    }
    
    @MainActor
    func returnPrice(product: ApphudProduct) -> String {
        return product.skProduct?.price.stringValue ?? ""
    }
    
    @MainActor
    func returnPriceSign(product: ApphudProduct) -> String {
        return product.skProduct?.priceLocale.currencySymbol ?? ""
    }
    
    @MainActor
    func returnName(product: ApphudProduct) -> String {
        guard let subscriptionPeriod = product.skProduct?.subscriptionPeriod else { return "" }
        
        switch subscriptionPeriod.unit {
        case .day:
            return "Weekly"
        case .week:
            return "Weekly"
        case .month:
            return "Monthly"
        case .year:
            return "Annual"
        @unknown default:
            return "Unknown"
        }
    }
    
    @MainActor
    func startPurchase(product: ApphudProduct, escaping: @escaping(Bool)->Void) {
        let selectedProduct = product
        Apphud.purchase(selectedProduct) { result in
            if let error = result.error {
                debugPrint(error.localizedDescription)
                escaping(false)
            }
            debugPrint(result)
            if let subscription = result.subscription, subscription.isActive() {
                escaping(true)
            } else if let purchase = result.nonRenewingPurchase, purchase.isActive() {
                escaping(true)
            } else {
                if Apphud.hasActiveSubscription() {
                    escaping(true)
                }
            }
        }
    }
    
    @MainActor
    func restorePurchase(escaping: @escaping (Bool) -> Void) {
        print("restore")
        Apphud.restorePurchases { subscriptions, _, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                escaping(false)
            }
            if subscriptions?.first?.isActive() ?? false {
                escaping(true)
            }
            if Apphud.hasActiveSubscription() {
                escaping(true)
            }
        }
    }
    
    var effectIdByName: Int {
        switch selectedEffect {
        case "Eye-pop it": return 3
        case "Levitate it": return 1
        case "Explode it": return 6
        default: return -1
        }
    }
    
    func generateEffect(
        userId: String,
        appId: String,
        completion: @escaping (String) -> Void,
        errorHandler: @escaping () -> Void
    ) {
        guard let url = URL(string: "https://vewapnew.online/api/generate") else {
            print("Invalid URL for generateEffect.")
            errorHandler()
            return
        }
        let templateId = "\(effectIdByName)"
        let imageFilePath = save(image: effectImage!)
        print(imageFilePath)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let bearerToken = "rE176kzVVqjtWeGToppo4lRcbz3HRLoBrZREEvgQ8fKdWuxySCw6tv52BdLKBkZTOHWda5ISwLUVTyRoZEF0A33Xpk63lF9wTCtDxOs8XK3YArAiqIXVb7ZS4IK61TYPQMu5WqzFWwXtZc1jo8w"
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"templateId\"\r\n\r\n")
        body.append("\(templateId)\r\n")
        
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"userId\"\r\n\r\n")
        body.append("\(userId)\r\n")
        
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"appId\"\r\n\r\n")
        body.append("\(appId)\r\n")
        
        if let imageFilePath = imageFilePath {
            do {
                let fileName = (imageFilePath as NSString).lastPathComponent
                print(fileName)
                let imageData = try Data(contentsOf: URL(fileURLWithPath: imageFilePath)) //guard let imageData = effectImage?.jpegData(compressionQuality: 0.5) else { return }//
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(fileName)\"\r\n")
                body.append("Content-Type: image/jpeg\r\n\r\n")
                body.append(imageData)
                body.append("\r\n")
            } catch {
                errorHandler()
                return
            }
        } else {
            errorHandler()
            print("No image file provided.")
        }
        
        body.append("--\(boundary)--\r\n")
        request.httpBody = body
        
        if let bodyString = String(data: body, encoding: .utf8) {
            print("Request body:\n\(bodyString)")
        }
        
        if let bodySize = request.httpBody?.count {
            print("HTTP Body size: \(bodySize) bytes")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let responseData = data else {
                errorHandler()
              print("nil Data received from the server")
              return
            }
            
            do {
                let response = try JSONDecoder().decode(ImageGenerationResult.self, from: responseData)
                print(response.data?.generationID)
                if let id = response.data?.generationID  {
                    if id.contains("went") {
                        errorHandler()
                    } else {
                        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let destinationURL = documentsURL.appendingPathComponent(id + ".mp4")
                        self.localUrl = destinationURL
                        self.save(id, isEffect: true)
                        completion(id)
                    }
                } else {
                    errorHandler()
                }
            } catch let error {
              //print(error.localizedDescription)
                errorHandler()
                print("error: ", error)
            }
//            
//            if let rawResponse = String(data: data, encoding: .utf8) {
//                print("Raw Response to generateEffect:\n\(rawResponse)")
//                print(data)
//                
//            } else {
//                print("Unable to parse raw response as string.")
//            }
//            
        }
        task.resume()
    }
    
    func saveUrl(id: String, url: String) {
        guard let index = videoIDs.firstIndex(where: {$0.id == id}) else { return }
        var item = Video(id: id, isEffect: videoIDs[index].isEffect, url: url)
        DispatchQueue.main.async {
            self.videoIDs[index] = item
        }
        
        dataManager.editVideo(id, url: url)
    }
    
    func getEffectURLById(id: String, completion: @escaping (URL?, Bool) -> Void, errorHandler: @escaping () -> Void) {
        var request = URLRequest(url: URL(string: "https://vewapnew.online/api/generationStatus?generationId=" + id)!,timeoutInterval: Double.infinity)

        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer rE176kzVVqjtWeGToppo4lRcbz3HRLoBrZREEvgQ8fKdWuxySCw6tv52BdLKBkZTOHWda5ISwLUVTyRoZEF0A33Xpk63lF9wTCtDxOs8XK3YArAiqIXVb7ZS4IK61TYPQMu5WqzFWwXtZc1jo8w", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
           guard let responseData = data else {
              
              print(String(describing: error))
              return
           }
            do {
                let response = try JSONDecoder().decode(ImageGenerationResult.self, from: responseData)
                if let status = response.data?.status, !status.contains("went") {
                    if status != "finished" {
                        completion(nil, false)
                    } else if let urlStr = response.data?.resultURL, let url = URL(string: urlStr) {
                        completion(url, true)
                    } else {
                        errorHandler()
                    }
                } else {
                    errorHandler()
                }
            } catch let error {
              //print(error.localizedDescription)
                errorHandler()
                print("error: ", error)
            }
        }

        task.resume()
    }
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func load(fileName: String) -> Data? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return imageData
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    func save(image: UIImage) -> String? {
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        if let imageData = image.jpegData(compressionQuality: 1.0) {
           try? imageData.write(to: fileURL, options: .atomic)
            return fileURL.path // ----> Save fileName
        }
        print("Error saving image")
        return nil
    }
    
//    func save(video url: UIImage) -> String? {
//        let fileName = UUID().uuidString + ".jpg"
//        let fileURL = documentsUrl.appendingPathComponent(fileName)
//        if let imageData = image.jpegData(compressionQuality: 1.0) {
//           try? imageData.write(to: fileURL, options: .atomic)
//            return fileURL.path // ----> Save fileName
//        }
//        print("Error saving image")
//        return nil
//    }
    
    func isGenerationFinished(id: String, completion: @escaping (Bool) -> (), errorHandler: @escaping () -> Void) {
        guard let url =  URL(string: API.url + "/" + id) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(API.key, forHTTPHeaderField: "access-token")
        request.httpMethod = "GET"
        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                print(error)
                errorHandler()
                return
            }
          // ensure there is valid response code returned from this HTTP response
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
          else {
            print("Invalid Response received from the server")
            errorHandler()
            return
          }
          // ensure there is data returned
          guard let responseData = data else {
              errorHandler()
            print("nil Data received from the server")
            return
          }
          
          do {
              let response = try JSONDecoder().decode(ResponseID.self, from: responseData)
              if response.isInvalid {
                  errorHandler()
              } else {
                  completion(response.isFinished)
              }
              print(response.id)
          } catch let error {
            //print(error.localizedDescription)
              errorHandler()
              print("error: ", error)
          }
        }
        task.resume()
    }
    
    func videoById(id: String, completion: @escaping (URL) -> (), errorHandler: @escaping () -> Void) {
        guard let url =  URL(string: API.url + "/file/" + id) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.addValue("*/*", forHTTPHeaderField: "accept")
        request.addValue(API.key, forHTTPHeaderField: "access-token")
        request.httpMethod = "GET"
        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                print(error)
                errorHandler()
                return
            }
          // ensure there is valid response code returned from this HTTP response
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
          else {
            print("Invalid Response received from the server")
            errorHandler()
            return
          }
          // ensure there is data returned
          guard let responseData = data else {
              errorHandler()
            print("nil Data received from the server")
            return
          }
            print("RESPONSE DATA")
            print(responseData)
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destinationURL = documentsURL.appendingPathComponent(id + ".mp4")
            do {
                try responseData.write(to: destinationURL)
                self.localUrl = destinationURL
                completion(destinationURL)
                //self.saveVideoToAlbum(videoURL: destinationURL, albumName: "MyAlbum")
                print(destinationURL)
            } catch {
                print("Error saving file:", error)
                errorHandler()
            }
        }
        task.resume()
    }
    
    func save(_ id: String, isEffect: Bool) {
        videoIDs.append(Video(id: id, isEffect: isEffect, url: nil))
        DispatchQueue.main.async {
            self.dataManager.saveVideoId(id, isEffect: isEffect)
        }
       
    }
    
    func documentsPathForFileName(name: String) -> String {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            return documentsPath.appending(name)
    }
    
    func textToVideo(text: String, errorHandler: @escaping () -> Void, completion: @escaping (String) -> ()) {
        let parameters: [String: Any] = [
            "prompt": text,
            "user_id" : API.key, //"c82d075d-b216-4e24-acbb-5f70db5dd864",
            "app_bundle": "string"
        ]
        guard let url =  URL(string: API.url) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(API.key, forHTTPHeaderField: "access-token")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        
        do {
            let json = try JSONSerialization.data(withJSONObject: parameters, options: [.fragmentsAllowed])
            let jsonTest = try JSONSerialization.jsonObject(with: json)
            print(jsonTest)
          request.httpBody = json
        } catch let error {
          print(error.localizedDescription)
            print(error)
          return
        }
        
        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                print(error)
                errorHandler()
                return
            }
          // ensure there is valid response code returned from this HTTP response
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
          else {
            print("Invalid Response received from the server")
            errorHandler()
            return
          }
          // ensure there is data returned
          guard let responseData = data else {
              errorHandler()
            print("nil Data received from the server")
            return
          }
          
          do {
              let response = try JSONDecoder().decode(ResponseID.self, from: responseData)
              print(response.id)
              if response.isInvalid {
                  errorHandler()
              } else {
                  self.save(response.id, isEffect: false)
                  completion(response.id)
              }
          } catch let error {
            //print(error.localizedDescription)
              errorHandler()
              print("error: ", error)
          }
        }
        task.resume()
    }
    
    func downloadVideo() {
        guard let url =  URL(string: API.url + "/file/" + "1f60444c-8237-4406-9764-d14e3a968ea2") else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.addValue("*/*", forHTTPHeaderField: "accept")
        request.addValue(API.key, forHTTPHeaderField: "access-token")
        request.httpMethod = "GET"
            let task = session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    print("ERROR DOWNLOAD")
                    return
                }
                print("123")
                let downloadTask = session.downloadTask(with: url)
                downloadTask.resume()
            }
            task.resume()
        }
    
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        guard let data = try? Data(contentsOf: location) else {
//            print("urlSession download task return")
//            return
//        }
//        
//        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let destinationURL = documentsURL.appendingPathComponent("myVideo.mp4")
//        do {
//            try data.write(to: destinationURL)
//            saveVideoToAlbum(videoURL: destinationURL, albumName: "MyAlbum")
//            print(destinationURL)
//        } catch {
//            print("Error saving file:", error)
//        }
//    }
    
    func saveVideoToAlbum(videoURL: URL, albumName: String, errorHandler: @escaping ()-> Void, completion: @escaping () -> Void) {
        if albumExists(albumName: albumName) {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
            let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            if let album = collection.firstObject {
                saveVideo(videoURL: videoURL, to: album, errorHandler: {errorHandler()})
            } else {
                errorHandler()
            }
        } else {
            var albumPlaceholder: PHObjectPlaceholder?
            PHPhotoLibrary.shared().performChanges({
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
            }, completionHandler: { success, error in
                if success {
                    guard let albumPlaceholder = albumPlaceholder else { return }
                    let collectionFetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [albumPlaceholder.localIdentifier], options: nil)
                    guard let album = collectionFetchResult.firstObject else { return }
                    self.saveVideo(videoURL: videoURL, to: album, errorHandler: {errorHandler()})
                } else {
                    print("Error creating album: \(error?.localizedDescription ?? "")")
                    errorHandler()
                }
            })
        }
    }
    
    private func albumExists(albumName: String) -> Bool {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        return collection.firstObject != nil
    }

    func saveVideo(videoURL: URL, to album: PHAssetCollection, errorHandler: @escaping () -> Void) {
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
            let enumeration: NSArray = [assetChangeRequest!.placeholderForCreatedAsset!]
            albumChangeRequest?.addAssets(enumeration)
        }, completionHandler: { success, error in
            if success {
                print("Successfully saved video to album")
            } else {
                print("Error saving video to album: \(error?.localizedDescription ?? "")")
                errorHandler()
            }
        })
    }
}

fileprivate extension URLRequest {
    func debug() {
        print("\(self.httpMethod!) \(self.url!)")
        print("Headers:")
        print(self.allHTTPHeaderFields!)
        print("Body:")
        //print(String(data: self.httpBody ?? Data(), encoding: .utf8)!)
    }
}

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
