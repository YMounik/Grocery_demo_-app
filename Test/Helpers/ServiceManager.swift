//
//  ServiceManager.swift
//  XfinityTest
//
//  Created by Mounik on 23/02/19.
//  Copyright © 2019 Mounik. All rights reserved.
//

import UIKit

public typealias networkSuccessHandler = (_ response: URLResponse?, _ json: Any) -> Void
public typealias networkFailureHandler = (_ response: URLResponse?, _ error: Error?) -> Void

class ServiceManager: NSObject {
    
    /// This method can be used to get the resource from the web service
    ///
    /// - Parameters:
    ///   - url: Resource of the path
    ///   - successHandler: Transfer the json data through success completion block if web service is success
    ///   - failureHandler: Returns the failure reason if any web service is failed to get data
    class func get(_ url: URL, _ successHandler: @escaping networkSuccessHandler, _ failureHandler: @escaping networkFailureHandler) -> Void {
        print("Request URL: \(url)")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: url) { (data, response, error) in
            if let errorMessage = error {
                failureHandler(response, errorMessage)
                debugPrint(errorMessage)
            }else {
                do {
                    if let jsonData = data {
                        print("Response: \(String(data: jsonData, encoding: .utf8) ?? "")")
                        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                        print(jsonObject)
                        successHandler(response, jsonObject as AnyObject)
                    }else {
                        failureHandler(response, error)
                    }
                }catch let error {
                    failureHandler(response, error)
                    debugPrint(error)
                }
            }
            }.resume()
    }
    
}
