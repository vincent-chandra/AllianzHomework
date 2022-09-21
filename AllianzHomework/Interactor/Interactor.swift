//
//  Interactor.swift
//  AllianzHomework
//
//  Created by Vincent on 19/09/22.
//

import Foundation

protocol InteractorProtocol {
    func didFinishGettingDataFromInteractor(data: Any)
}

class Interactor {
    
    static var shared = Interactor()
    var api: Any?
    var responseURL: HTTPURLResponse?
    
    var interactorProtocol: InteractorProtocol?
    
    func getDataUser(query: String, page: Int, completion: @escaping (Any) -> Void) {
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.github.com/search/users?q=\(query)&page=\(page)")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            var result: Any?
            self.responseURL = response as? HTTPURLResponse
            
            if self.responseURL?.statusCode == 200 {
                do{
                    result = try JSONDecoder().decode(UserEntity.self, from: data!)
                }catch{
                    print(error.localizedDescription)
                }
            } else if self.responseURL?.statusCode == 403 {
                do{
                    result = try JSONDecoder().decode(LimitExceed.self, from: data!)
                }catch{
                    print(error.localizedDescription)
                }
            }
            
            self.api = result
            completion(result ?? Any.self)
            self.interactorProtocol?.didFinishGettingDataFromInteractor(data: result!)
        }
        dataTask.resume()
    }
}
