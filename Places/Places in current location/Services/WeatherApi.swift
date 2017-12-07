//
//  TodayViewController.swift
//  Places In Current Location
//
//  Created by Andrew Konchak on 11/30/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherApi {
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    let summary:String
    let icon:String
    let temperature:Double
    
    static let basePath = "https://api.darksky.net/forecast/7d4844348f4f1050bb7a581a0d19e7c9/"
    
    init(json:[String:Any]) throws {
        
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
        guard let temperature = json["temperatureMax"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        
    }
    
    static func forecast (withLocation location:CLLocationCoordinate2D, completion: @escaping ([WeatherApi]?) -> ()) {
        
        let url = basePath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            var forecastArray:[WeatherApi] = []
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? WeatherApi(json: dataPoint) {
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    
                    print(error.localizedDescription)
                }
                
                completion(forecastArray)
            }
        }
        
        task.resume()
    }
}
