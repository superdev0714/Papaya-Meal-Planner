//
//  recipe_config.swift
//  PapayaMealPlanner
//
//  Created by Norton Gumbo on 11/2/16.
//  Copyright © 2016 Papaya LC. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

func getRecipeIngredients(id: Int, completion: @escaping (_ results: [[String: AnyObject]]) -> Void){
    // Get recipe ingredients
    guard let token = KeychainWrapper.standard.string(forKey: "authToken") else {
        return
    }
    
    let baseUrl = "https://data.mypapaya.io/api/recipes/\(id)/ingredients"
    var request = URLRequest(url: URL(string: baseUrl)!)
    
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            // check for fundamental networking error
            print("error=\(error)")
            return
        }
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
            // check for http errors
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print("response = \(response)")
        }
        
        // Turns the response from json to dictionary
        let jsondata = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        let results = jsondata!["results"] as? [[String: AnyObject]]
        
        completion(results!)
    }
    task.resume()
}

func getRecipeNutritionInfo(id: Int, completion: @escaping (_ results: [String: AnyObject]) -> Void){
    // Get recipe ingredients
    guard let token = KeychainWrapper.standard.string(forKey: "authToken") else {
        return
    }
    
    let baseUrl = "https://data.mypapaya.io/api/recipes/\(id)/nutrition_info"
    var request = URLRequest(url: URL(string: baseUrl)!)
    
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            // check for fundamental networking error
            print("error=\(error)")
            return
        }
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
            // check for http errors
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print("response = \(response)")
        }
        
        // Turns the response from json to dictionary
        let jsondata = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        let results = jsondata!["result"]! as? [String: AnyObject]
        
        completion(results!)
    }
    task.resume()
}
