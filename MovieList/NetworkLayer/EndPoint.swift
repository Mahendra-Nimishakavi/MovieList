//
//  EndPoint.swift
//  MovieList
//
//  Created by mn669704 on 24/01/20.
//  Copyright © 2020 Tacit. All rights reserved.
//

//Represents an endpoint protocol
import Foundation
public enum HTTPMethod : String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
}

public typealias HTTPHeaders = [String:String]

protocol EndPoint {
    var baseURL : String {get }
    var path : String {get}
    var httpMethod : HTTPMethod {get}
    var headers : HTTPHeaders? {get}
    var parameters : HTTPHeaders? { get }
}
