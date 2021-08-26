//
//  APIManager.swift
//  NotesApp
//
//  Created by SIVA on 20/03/21.
//

import UIKit

class APIManager: NSObject {
    
    enum DataManagerError: Error {
        case Unknown
        case FailedRequest
        case InvalidResponse
        
    }
    typealias Completion = (AnyObject, DataManagerError?) -> ()
    static let shared = APIManager()

    private override init() { }
                
    func fetchAPIDetails(_ completion:@escaping (Data,Error?) -> Void) {
        let urlString : String = kNOTESAPIDOMAIN
        let url = URL(string: urlString)!

        var request = URLRequest(url: url)
                request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
           //parsing response
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion(Data(), error)
                return
            }
            do {
                let dictonary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSArray
                print(dictonary)
                let httpURLResponse = response as? HTTPURLResponse
                let statusCode = httpURLResponse?.statusCode
                if ((statusCode == 201) || (statusCode == 200)) {
                    completion(data, nil)

                } else {
                    completion(data, error)
                }
            }
            catch {
                completion(data, error)
            }
        }
        task.resume()
    }

}
