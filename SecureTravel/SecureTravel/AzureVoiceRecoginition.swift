//
//  AzureVoiceRecoginition.swift
//  SecureTravel
//
//  Created by Siddharth on 14/09/19.
//  Copyright © 2019 Siddharth. All rights reserved.
//

import Foundation
import UIKit

let IdentificationUrl = "https://\(Region).api.cognitive.microsoft.com/spid/v1.0/identificationProfiles"

class AzureVoiceRecognition:NSObject {
    
    let APIKey = "f4e44d2f12e245f2ad8d9cfe3fb65a69" // Ocp-Apim-Subscription-Key
    let Region = "eastus"
    
    func detectUrl(givenId: String) -> String {
        return "https://\(Region).api.cognitive.microsoft.com/spid/v1.0/verify?verificationProfileId={\(givenId)}"
    }
    
    static let shared = AzureVoiceRecognition()
    
    func syncDetectVoiceId(voiceData: Data) {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/octet-stream"
        headers["Ocp-Apim-Subscription-Key"] = APIKey
        let response = self.makePOSTRequest(url: IdentificationUrl, postData: voiceData, headers: headers)
        for voiceInfo in response {
            if let voiceId = voiceInfo["identificationProfileId"] as? String  {
                print(voiceId)
            }
        }
    }
    
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
