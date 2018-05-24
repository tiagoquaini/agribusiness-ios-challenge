//
//  ViewController.swift
//  Agribusiness
//
//  Created by Quaini, Tiago on 23/05/18.
//  Copyright © 2018 Quaini, Tiago. All rights reserved.
//

import UIKit
import GoogleMaps

class MapController: UIViewController {

    @IBOutlet fileprivate weak var mapView: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: 37.36, longitude: -122.0, zoom: 10.0)
        mapView.camera = camera
        mapView.settings.myLocationButton = true
        showMarker(position: camera.target)
        fetchRoute()
    }

    func showMarker(position: CLLocationCoordinate2D){
        let marker = GMSMarker()
        marker.position = position
        marker.title = "Palo Alto"
        marker.snippet = "San Francisco"
        marker.map = mapView
    }

    func fetchRoute() {
        let origin = "Mountain View"
        let destination = "San Jose"
        let apiKey = "AIzaSyBVjW1BbO04oUZBRgNqp-hLr314w5LdA-U"
        let urlString = "https://maps.googleapis.com/maps/api/directions/json"

        let query: [String: String] = [
            "key": apiKey,
            "origin": origin,
            "destination": destination
        ]

        let baseURL = URL(string: urlString)!
        let url = baseURL.withQueries(query)!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                print("oss")
                print(data)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as! [String : AnyObject]
                    let routes = json["routes"] as! NSArray

                    DispatchQueue.main.async {
                        self.mapView.clear()

                        for route in routes {
                            let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                            let points = routeOverviewPolyline.object(forKey: "points")
                            let path = GMSPath.init(fromEncodedPath: points! as! String)
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeWidth = 3

                            let bounds = GMSCoordinateBounds(path: path!)
                            self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))

                            polyline.map = self.mapView
                        }
                    }
                } catch let error as Error{
                    print("error:\(error)")
                }
            }
        }
        task.resume()
    }
}

extension MapController: GMSMapViewDelegate {

}

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self,
                                       resolvingAgainstBaseURL: true)
        components?.queryItems = queries.flatMap
            { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}
