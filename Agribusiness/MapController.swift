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
    @IBOutlet weak var mapRouteButton: UIButton!
    
    var routeDisplayed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: 37.36, longitude: -122.0, zoom: 10.0)
        mapView.camera = camera
    }
    
    @IBAction func mapRouteBtnPress(_ sender: UIButton) {
        var imageSrc :String
        if !routeDisplayed {
            fetchRoute()
            showMarkerInAddress(address: "Mountain View, CA")
            showMarkerInAddress(address: "Loyola, CA")
            showMarkerInAddress(address: "Cupertino, CA")
            showMarkerInAddress(address: "Sunnyvale, CA")
            imageSrc = "stop.png"
        } else {
            mapView.clear()
            imageSrc = "replay-icon.png"
        }
        if let image = UIImage(named: imageSrc) {
            mapRouteButton.setImage(image, for: .normal)
        }
        routeDisplayed = !routeDisplayed
    }
    
    func showMarkerInAddress(address: String, description: String = "Description") {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location
                else {
                    return
            }
            self.showMarker(position: location.coordinate, title: address, description: description)
        })
    }

    func showMarker(position: CLLocationCoordinate2D, title: String, description snippet: String ){
        let marker = GMSMarker()
        marker.position = position
        marker.title = title
        marker.snippet = snippet
        marker.map = mapView
    }

    func fetchRoute() {
        let origin = "Mountain View,CA"
        let destination = "Mountain View,CA"
        let apiKey = "AIzaSyBVjW1BbO04oUZBRgNqp-hLr314w5LdA-U"
        let urlString = "https://maps.googleapis.com/maps/api/directions/json"

        let query: [String: String] = [
            "key": apiKey,
            "origin": origin,
            "destination": destination,
            "waypoints": "Loyola,CA|Cupertino,CA|Sunnyvale,CA"
        ]

        let baseURL = URL(string: urlString)!
        let url = baseURL.withQueries(query)!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
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
