//
//  ContentModel.swift
//  City Sights
//
//  Created by Semih Cetin on 28.09.2022.
//

import Foundation
import CoreLocation

class ContentModel: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    var locationManager = CLLocationManager()
    
    @Published var restaurants = [Business]()
    @Published var sights = [Business]()
    
    
    override init() {
        
        // Init method of NSObject
        super.init()
        
        // Set content model as the delegate of the location manager
        locationManager.delegate = self
        
        // Request permission from the user
        locationManager.requestWhenInUseAuthorization()
        
        // TODO: Start geolocating the user, after we get permission
        //locationManager.startUpdatingLocation()
    }
    
    // MARK: - Location Manager Delegate Methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            // We have permission
            locationManager.startUpdatingLocation()
        }
        else if locationManager.authorizationStatus == .denied {
            // We don't have permission
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // This function is firing continuously if you wont call .stopUpdatingLocation() parameter.
        
        // Gives us the location of the user
        let userLocation = locations.first
        
        if userLocation != nil {
            // We have a location
            // Stop requesting the location after we get it once
            locationManager.stopUpdatingLocation()
            
            // If we have the coordinates of the user, send into Yelp API
            getBusinesses(category: Constants.sightsKey, location: userLocation!)
            getBusinesses(category: Constants.restaurantsKey
                          , location: userLocation!)
        }
    }
    
    // MARK: - Yelp API methods
    func getBusinesses(category:String, location:CLLocation) {
        // Create URL - method 1 (url endpoint: https://api.yelp.com/v3/businesses/search)
        /*
         let urlString = "https://api.yelp.com/v3/businesses/search?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&categories=\(category)&limit=6"
         let url = URL(string: urlString)
         */
        
        // Create URL - method 2
        var urlComponents = URLComponents(string: Constants.apiUrl)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(location.coordinate.longitude)),
            URLQueryItem(name: "categories", value: category),
            URLQueryItem(name: "limit", value: "6")
        ]
        
        let url = urlComponents?.url
        
        if let url = url {
            // Create URL Request
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0) // .reloadIgnoringLocalCacheData secerek her zaman fresh data ile calisiyoruz.
            request.httpMethod = "GET" // url endpointi aldigimiz link icerisinde, end point basinda GET ile cekilmesi yaziyordu. GET haricinde "POST", "DELETE" gibi httpMethodlarda var.
            request.addValue("Bearer \(Constants.apiKey)", forHTTPHeaderField: "Authorization") // Bearer ardindan bosluk ve api key, ve forHTTPHeaderField icerisine yazilacak olanlari https://www.yelp.com/developers/documentation/v3/authentication bu link icerisinde bulunan "Authenticate API calls with the API key icerisinden aldik.
            
            // Get URLSession
            let session = URLSession.shared
            
            // Create Data Task
            let dataTask = session.dataTask(with: request) { data, response, error in
                // Check that there isn't an error
                if error == nil {
                    
                    
                    do {
                        // Parse JSON
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(BusinessSearch.self, from: data!) // data: dataTask icerisinden geliyor.
                        
                        DispatchQueue.main.async {
                            // Assign results to the appropriate property
                            switch category {
                            case Constants.sightsKey:
                                self.sights = result.businesses
                            case Constants.restaurantsKey:
                                self.restaurants = result.businesses
                            default:
                                break
                            }
                        }
                    }
                    catch {
                        print(error) // buradaki error dataTask icindeki error degil. swiftin dondurecegi error. dataTask icindeki error, response ile gelen errordur.
                    }
                }
            }
            
            // Start the Data Task
            dataTask.resume()
        }
    }
}
