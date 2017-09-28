//
//  ResultsTableViewController.swift
//  WeatherApp
//
//  Created by Aicha Diallo on 6/20/17.
//  Copyright © 2017 Aicha Diallo. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ResultsTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    let locationManager  = CLLocationManager()
    
    var coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    var weatherData = Weather(lat: "0", long: "0", dailyWeather: [])
    var city = ""
    var state = ""
    var weekSummary = ""
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var weekSummaryLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        //grab location of user
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        self.tableView.separatorStyle = .none

    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       return weatherData.dailyWeather.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as!
        ResultsTableViewCell
        cell.selectionStyle = .none


       let dailyWeatherData = weatherData.dailyWeather[indexPath.row]

        // Configure the cell...
        cell.dayLabel.text = dailyWeatherData.date
        cell.temperatureLabel.text = String(dailyWeatherData.temperature) + (" °F")
       // cell.thumbnailImageView.image = UIImage(named: dailyWeatherData.icon)
    
        return cell
    
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func grabForecast(coordinates:CLLocationCoordinate2D){
        
        //or make it a double?
        let longCordinate = String(coordinates.longitude)
        let latCordinate = String(coordinates.latitude)
        
        let path = "https://api.darksky.net/forecast/09c1571d2ee73ac53ed0120074fc8ff8/"
        let url = path + latCordinate + "," + longCordinate
        
        let forecastURL = URL(string: url)
        
        var dailyForecast:[DailyWeatherData] = []
        
        
        // let request = URLRequest(url: URL(string:url)!)
        Alamofire.request(forecastURL!).responseJSON{response in
            
            switch response.result{
            case .success:
                let result = response.result
                if let dict = result.value as? Dictionary<String,AnyObject>{
                    if let daily = dict["daily"] as? Dictionary<String,AnyObject>{
                        if let data = daily["data"] as? [Dictionary<String,AnyObject>]{
                            var index = 0
                            
                            while index < data.count{
                                if let dataObj = data[index] as? Dictionary<String,AnyObject>{
                                        if let summary = dataObj["summary"] as? String,
                                            let temperature = dataObj["temperatureMax"] as? Double,
                                            let date = dataObj["time"] as? Double,
                                            let icon = dataObj["icon"] as? String{
                                            
                                            let dateFormatter = DateFormatter()
                                            dateFormatter.dateStyle = .long
                                            dateFormatter.timeStyle = .none
                                            let date = Date(timeIntervalSince1970: date)
                                            let displayDate = dateFormatter.string(from: date)
                                            let weather = DailyWeatherData(date: displayDate, temperature: temperature, forecast: summary, icon:icon)
                                            dailyForecast.append(weather)
                                        
                                    }
                                    index = index+1
                                }
                            }
                         self.weatherData = Weather(lat: latCordinate, long: longCordinate, dailyWeather: dailyForecast)
                            
                          
                        }
                        if let weekSum = daily["summary"] as? String{
                            
                            self.weekSummary = weekSum
                            self.weekSummaryLabel.text = self.weekSummary
                        }
                    }
                
                    
                    //relaod the view with this new info
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            case .failure( _):
                print("error")
                break
            }//end Switch block
            
        }//end Alamofire closure
        
    
    }//end function grab weather

}//end class declaration


extension ResultsTableViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {
            (placemarks, error) -> Void in
            
            if error != nil{
                print("Reverse geocoder failed with Error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])!
                self.city = pm.locality!
                self.state = pm.administrativeArea!
                self.locationLabel.text = self.city + ", " + self.state

            }
            else{
                print("Error with data")
            }
        })
        
        let lastLocation: CLLocation = locations[locations.count - 1]
        locationManager.stopUpdatingLocation()
        
        coordinates.latitude = lastLocation.coordinate.latitude
        coordinates.longitude = lastLocation.coordinate.longitude
        
        //PUT THIS IN HERE OR IN VIEW DID LOAD ?
        grabForecast(coordinates: coordinates)

    
    }
    

}
