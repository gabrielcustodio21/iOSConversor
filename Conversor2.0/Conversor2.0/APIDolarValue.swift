//
//  APIDolarValue.swift
//  Conversor2.0
//
//  Created by gempe on 08/06/21.
//

import Foundation



struct DolarData : Codable {
    let USDBRL : (DolarValue)
}

struct DolarValue: Codable {
    let high : String
}



class NetworkManager {
    
    
    
    
    class func loadDolarValue(completion: @escaping (DolarData) -> Void) {
        let url = URL(string: "https://economia.awesomeapi.com.br/json/last/USD-BRL")!
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil{
                guard let response = response as? HTTPURLResponse else {return}
                if response.statusCode == 200 {
                    guard let data = data else {return}
                    do{
                        let dolarData = try JSONDecoder().decode(DolarData.self, from: data)
                        completion(dolarData)
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    print("Algum status inválido pelo servidor: ", response.statusCode)
                }
            } else {
                print("error!")
            }
          
        }
        task.resume()
    }
}
