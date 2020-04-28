//
//  AzureFaceRecognition.swift
//  SecureTravel
//
//  Created by Siddharth on 14/09/19.
//  Copyright © 2019 Siddharth. All rights reserved.
//

import UIKit

let APIKey = "353a80555bd2479890cffc6bc492fa47" // Ocp-Apim-Subscription-Key
let Region = "eastus"
let FindSimilarsUrl = "https://\(Region).api.cognitive.microsoft.com/face/v1.0/findsimilars"
let DetectUrl = "https://\(Region).api.cognitive.microsoft.com/face/v1.0/detect?returnFaceId=true"

class AzureFaceRecognition: NSObject {
    
    static let shared = AzureFaceRecognition()
    
    func syncDetectFaceIds(imageData: Data) -> String {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/octet-stream"
        headers["Ocp-Apim-Subscription-Key"] = APIKey
        
        let response = self.makePOSTRequest(url: DetectUrl, postData: imageData, headers: headers)
        for faceInfo in response {
            if let faceId = faceInfo["faceId"] as? String  {
                return faceId
            }
        }
        return ""
    }

    
    func findSimilars(currentFaceId: String, userFaceIds: [String], completion: @escaping (Bool) -> Void) {
        
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["Ocp-Apim-Subscription-Key"] = APIKey
        
        let params: [String: Any] = [
            "faceId": currentFaceId,
            "faceIds": userFaceIds,
            "mode": "matchFace"
        ]
        
        // Convert the Dictionary to Data
        let data = try! JSONSerialization.data(withJSONObject: params)
        
        DispatchQueue.global(qos: .background).async {
            let response = self.makePOSTRequest(url: FindSimilarsUrl, postData: data, headers: headers)
            var authenticated = false
            let minConfidence = 0.3
            for info in response {
//                if let faceId = info["faceId"] as? String  {
                let confidence = (info["confidence"] as! NSNumber).doubleValue
                print(confidence)
                if (confidence >= minConfidence) {
                    print(confidence)
                    authenticated = true
                }
            }
            DispatchQueue.main.async {
                completion(authenticated)
            }
        }
    }
    
    // Just a function that makes a POST request.
    private func makePOSTRequest(url: String, postData: Data, headers: [String: String] = [:]) -> [AnyObject] {
        var object: [AnyObject] = []
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        // Using semaphore to make request synchronous
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] {
                object = json
            }
            else {
                print("ERROR response: \(String(data: data!, encoding: .utf8) ?? "")")
            }
            
            semaphore.signal()
        }
        
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        return object
    }
}
