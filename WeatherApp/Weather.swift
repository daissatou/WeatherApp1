//
//  DataModel.swift
//  WeatherApp
//
//  Created by Aicha Diallo on 6/19/17.
//  Copyright © 2017 Aicha Diallo. All rights reserved.
//

import Foundation
import ObjectMapper

class Weather: Mappable{
    
    var longitude: String = ""
    var latitude: String = ""
    var dailyWeather:[DailyWeatherData] = []
    
    init(lat:String, long:String, dailyWeather:[DailyWeatherData]){
        longitude = long
        latitude = lat
        self.dailyWeather = dailyWeather
    }
    
    init(map: Mapper<<#N: BaseMappable#>>) throws {
        lat = try map.from("latitude")
        long = try map.from("longitude")
        
        windSpeed = try map.from("currently.windSpeed")
        fahrenheit = try map.from("currently.temperature")
        
        hourlyDataPoints = try map.from("hourly.data")
    }

}



class DailyWeatherData{
    
    var date: String = ""
    var temperature: Double = 0.0
    var forecast: String = ""
    var icon: String = ""
    
    init(date: String, temperature: Double, forecast:String, icon:String) {
        
        self.date = date
        self.temperature = temperature
        self.forecast = forecast
        self.icon = icon
    }
    
    init(obj: DailyWeatherData)
    {
        
        date = obj.date
        
        
    }
}
