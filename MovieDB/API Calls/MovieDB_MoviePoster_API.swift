//
//  MovieDB_MoviePoster_API.swift
//  MovieDB
//
//  Created by Aldo Bergamini on 26/09/2018.
//  Copyright © 2018 iBat Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

/*
 
 For a quick turnaround this source code file actually originates from a template-based code generation tool inside the macOS Paw app.
 
 Code edited (@AAB) to fit in application architecture.
 
 */

// API Key: "73bc7e190c9dfe6e7be35a5d11e44949"


private let kAPIURLString = "https://image.tmdb.org/t/p/original/"
private let kAPI_Key = "73bc7e190c9dfe6e7be35a5d11e44949"
private let kErrorDomain = "MovieDB_APIError"

// Convenience: Template Generated Code (Paw macOS App), that was adapted to fit in Coordinator/Service App Architecture

class MovieDB_MoviePoster_API {
    
    static func sendRequest(withID posterImageID: String, andOnCompletion completionBlock: @escaping (_ result: Any?, _ error: Error?) -> Void) {
        /* Configure session, choose between:
         * defaultSessionConfiguration
         * ephemeralSessionConfiguration
         * backgroundSessionConfigurationWithIdentifier:
         And set session-wide properties, such as: HTTPAdditionalHeaders,
         HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
         */
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        /* Create the Request:
         Get Movie Image By ImageID (GET https://image.tmdb.org/t/p/original/{posterImageID})
         */
        
        let commandURL = kAPIURLString + "%@"
        guard var URL = URL(string: String(format: commandURL, posterImageID)) else {return}

//        DLogWith(message: "URL: \(URL.absoluteString)")
        let URLParams = [
            "api_key": kAPI_Key,
            ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        // Headers
        
        //request.addValue("__cfduid=dd3b82066bfdbbc919cfd10283a4439e61537989479", forHTTPHeaderField: "Cookie")
        // ??
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if (error == nil) {
                
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
//                DLogWith(message: "URL Session Task Succeeded: HTTP \(statusCode)")
                
                if let data = data {
                    
//                    DLogWith(message: "Data: \(data)")
                    if let image = UIImage(data: data) {
                    
                        completionBlock(image, error)
                        
                    } else {
                        
                        let jsonError = NSError(domain: kErrorDomain, code: 1001, userInfo: ["StatusCode": statusCode])
                        completionBlock(nil, jsonError)
                    }
                } else {
                    
                    let jsonError = NSError(domain: kErrorDomain, code: 1000, userInfo: ["StatusCode": statusCode])
                    completionBlock(nil, jsonError)
                }
            }
            else {
                
                // Failure
//                DLogWith(message: "URL Session Task Failed: \(error!.localizedDescription)")
                
                if let error = error {
                    completionBlock(nil, error)
                }
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}

