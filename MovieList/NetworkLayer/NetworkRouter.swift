//
//  NetworkRouter.swift
//  MovieList
//
//  Created by mn669704 on 23/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

import Foundation
import Alamofire


public typealias NetworkRouterCompletion = (_ data: Data?,_ error: Error?)->()

enum Result<String>{
    case success
    case failure(String)
}

enum NetworkResponse:String,Error {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

class NetworkRouter {
    
    static let sharedInstance = NetworkRouter()
    
    private init(){
        
    }
    
    func request(from route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let urlString = self.getFullURL(from: route)
        let parameters = route.parameters ?? nil
        let headers = route.headers ?? nil
        let httpMethod = self.getHTTPMethod(from: route)
        
        Alamofire.request(urlString, method: httpMethod, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate().responseJSON { response in
            
            guard response.result.isSuccess
                else{
                    completion(nil,response.result.error)
                    return
                }
            
            guard let value = response.data
            else{
                completion(nil,response.result.error)
                return
            }
            
            completion(value,nil)
            print(value)
        }
    }
    
    func downloadImage(imageURL:URL,completion:@escaping NetworkRouterCompletion){
        
        Alamofire.request(imageURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).validate().responseData { response in
            guard  response.result.isSuccess
                else{
                    completion(nil,response.result.error)
                    return
            }
            guard let value = response.data
            else{
                completion(nil,response.result.error)
                return
            }
            
            completion(value,nil)
            
        }
    }
}


extension NetworkRouter {
    
    private func getFullURL(from endPoint:EndPoint) -> String {
        return endPoint.baseURL + endPoint.path
    }
    
    private func getHTTPMethod(from endPoint:EndPoint) -> Alamofire.HTTPMethod {
        switch endPoint.httpMethod {
            case .POST:
                return Alamofire.HTTPMethod.post
                
            case .GET:
                return Alamofire.HTTPMethod.get
            case .PUT :
                return Alamofire.HTTPMethod.put
            case .PATCH :
                return Alamofire.HTTPMethod.patch
            case .DELETE :
                return Alamofire.HTTPMethod.delete
        }
    }

}

extension NetworkRouter {
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
