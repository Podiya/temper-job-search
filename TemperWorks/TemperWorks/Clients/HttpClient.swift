//
//  HttpClient.swift
//  TemperWorks
//
//  Created by Ravindu Senevirathna on 9/10/20.
//

import Foundation
import RxSwift

public enum HttpMethod<Body> {
    case get
    case post(Body)
    case put(Body)
}

extension HttpMethod {
    var methodString: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        }
    }
    func map<B>(f: (Body) -> B) -> HttpMethod<B> where B: Encodable {
        switch self {
        case .get:
            return .get
        case .post(let body):
            return .post(f(body))
        case .put(let body):
            return .put(f(body))
        }
    }
}

public enum RESTError: Error {
    case noContent
    case badRequest
    case unauthorized
    case somethingWentWrong
    case custom(String)
}


extension RESTError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noContent:
            return NSLocalizedString("Your request has no content", comment: "RESTError")
        case .badRequest:
            return NSLocalizedString("Bad request or API timeout", comment: "RESTError")
        case .unauthorized:
            return NSLocalizedString("Your request is unauthorized. Please try again or re-login", comment: "RESTError")
        case .somethingWentWrong:
            return NSLocalizedString("Something went wrong. check your connectivity and try again", comment: "RESTError")
        case .custom(let error):
            return NSLocalizedString(error, comment: "RESTError")
        }
    }
}

public struct Resource<A> where A: Decodable {
    let method: HttpMethod<Data>
    let url: URL
    var parse: (Data) -> A? = { data in
        do {
            return try JSONDecoder().decode(A.self, from: data)
        } catch (let e) {
            print(e)
            return nil
        }
    }
    fileprivate var components: URLComponents = URLComponents()
    var formData: String? = nil
    private var contents = Bundle.contentsOfFile(plistName: "Settings.plist")
    
    
    public init(method: HttpMethod<Data>, route: String, queryParams: [String:String]? = nil, formData: String? = nil) {
        self.method = method
        self.formData = formData
        if let host = contents["host"] as? String,
            let version = contents["version"] as? String {
            self.components.scheme = "https"
            self.components.host = host
            self.components.path = "/api/\(version)\(route)"
            if let params = queryParams {
                self.components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
            }
            self.url = self.components.url!
        } else {
            fatalError("URLComponents initialization falied")
        }
    }
}

extension URLRequest {
    public init<A>(resource: Resource<A>) {
        self.init(url: resource.url)
        httpMethod = resource.method.methodString
        if case let .post(data) = resource.method { httpBody = data }
        if case let .put(data) = resource.method {  httpBody = data }
    }
    
    @discardableResult
    func debugDetail() -> URLRequest {
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
        print(self.url ?? "No URL")
        print(self.allHTTPHeaderFields ?? "No headers")
        print(self.httpMethod ?? "No httpMethod")
        if let data = self.httpBody {
            print(data.prettyPrintedJSONString ?? "No httpBody")
        }
        print("=========================================")
        return self
    }
}

public class HttpClient {
    
    private init() {}
    
    public static func load<A>(resource: Resource<A>, requestDebug: Bool = true) -> Observable<A?> {
        
        Observable<A?>.create { observer in
            let request = URLRequest(resource: resource)
            if requestDebug {
                request.debugDetail()
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let _ = error {
                    observer.onError(RESTError.somethingWentWrong)
                }
                if let httpResponse = response as? HTTPURLResponse {
                    data?.responseDataDebug(url: httpResponse.url, statusCode: httpResponse.statusCode)

                    if httpResponse.statusCode == 401 {
                        observer.onError(RESTError.unauthorized)
                    } else if [200,202].contains(httpResponse.statusCode) {
                        observer.onNext(data.flatMap(resource.parse))
                    } else if httpResponse.statusCode == 201 {
                        observer.onNext(data.flatMap(resource.parse))
                    } else if httpResponse.statusCode == 204 {
                        observer.onError(RESTError.noContent)
                    } else if httpResponse.statusCode == 400 {
                        observer.onError(RESTError.badRequest)
                    }
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
