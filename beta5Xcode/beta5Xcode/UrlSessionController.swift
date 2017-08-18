//
//  UrlSessionController.swift
//  beta5Xcode
//
//  Created by Akash on 18/08/17.
//  Copyright © 2017 Akash. All rights reserved.
//

import UIKit

class UrlSessionController: UIViewController {
    
    let boundary = "Boundary-\(NSUUID().uuidString)"

    override func viewDidLoad() {
        super.viewDidLoad()
        getJson()
        
    }
    func getJson() {
       Session.requestPost(completedJson: { response in
        print(response)
        
       })
    }
}



typealias RESPONSEJSON = [String: Any]

class Session {
    
    static let boundary = "Boundary-\(NSUUID().uuidString)"

    static var configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["X-Auth":"WKx0V4aULbHT8gf6i4fgDA&gws"]
        return config
    }()
    
    static var session: URLSession = {
        return URLSession(configuration: configuration)
    }()
    
    static var baseUrl = URL(string: "http://addonwebsolutions.net/mychatapp/mahesh_test/objects.php")!
    
    static var baseURLGET = URL(string: "http://addonwebsolutions.net/mychatapp/mahesh_test/objects.php?function=dashboard")!
    
    static func requestPost( completedJson: @escaping(RESPONSEJSON) -> (Void)) {
        
        let request = createRequestForMultipart()
        session.dataTask(with: request) { (data, response, error) in
            
//            print("Response received ::", (response as? HTTPURLResponse)?.statusCode ?? "" )
            
            guard error == nil else {
                return
            }
            if let data = data {
//                print("httpBody ::",String(data: data, encoding: .utf8) ?? "")
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! RESPONSEJSON
//                    print("json :: \(json)")
                    completedJson(json)
                }catch let error {
                    print("Error in json \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    static func createRequestforPost() -> URLRequest{
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let body = generateBody(parameters: [
            "function": "login",
            "mail_id": "mitesh@addonwebsolutions.com",
            "password": "12345"
            ])
        request.httpBody = body
        request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
        return request
    }
    
    static func createRequestforGet() -> URLRequest{
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "GET"
        let body = generateBody(parameters: [
            "function": "dashboard"
            ])
        request.httpBody = body
        request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
        return request
    }
    static func createRequestForMultipart() -> URLRequest{
        
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let body = generateBody(parameters: [
            "function": "new_place",
            "title": "new",
            "img": #imageLiteral(resourceName: "firebase"),
            "description": "this is urlsession demo multipartRequest",
            "lat":"22.11","long":"12.33"
            ])
        request.httpBody = body
        request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
        return request
    }
    static func getRequest() {
        
        var request = URLRequest(url: baseURLGET)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { (data, response, error) in
            
            print("Response received ::", (response as? HTTPURLResponse)?.statusCode ?? "" )
            
            guard error == nil else {
                return
            }
            
            if let data = data {
                
                print("httpBody ::",String(data: data, encoding: .utf8) ?? "")
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! RESPONSEJSON
                    print("json :: \(json)")
                    
                    
                    
                }catch let error {
                    print("Error in json \(error.localizedDescription)")
                }
                
            }
            
            }.resume()
    }
    
    static func generateBody(parameters : [String: Any]) -> Data {
        
        var body = Data()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            
            if let stringValue = value as? String {
                
                body.append(boundaryPrefix)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(stringValue)\r\n")
                
            }else if let image = value as? UIImage {
                
                let filename = "\(key).jpg"
                let data = UIImageJPEGRepresentation(image,1);
                let mimetype = "image/jpeg"
                
                body.append(boundaryPrefix)
                body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                body.append("Content-Type: \(mimetype)\r\n\r\n")
                body.append(data!)
                body.append("\r\n")
                
            }else if let imageArray = value as? [UIImage] {
                
                for i in 0..<imageArray.count {
                    let filename = "\(key)-\(i+1).jpg"
                    let data = UIImageJPEGRepresentation(imageArray[i],1);
                    let mimetype = "image/jpeg"
                    
                    body.append(boundaryPrefix)
                    body.append("Content-Disposition: form-data; name=\"\(key)[]\"; filename=\"\(filename)\"\r\n")
                    body.append("Content-Type: \(mimetype)\r\n\r\n")
                    body.append(data!)
                    body.append("\r\n")
                }
            }
        }
        body.append("--".appending(boundary.appending("--")))
        return body
    }
}
extension Data {
    
    mutating func append(_ string: String) {
        self.append(string.data(using: .utf8)!)
    }
    
}

