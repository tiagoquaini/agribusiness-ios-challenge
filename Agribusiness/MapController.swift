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
        let camera = GMSCameraPosition.camera(withLatitude: -29.7965353, longitude: -51.148414, zoom: 10.0)
        mapView.camera = camera
    }
    
    @IBAction func mapRouteBtnPress(_ sender: UIButton) {
        var imageSrc :String
        if !routeDisplayed {
            fetchRoute()
            showMarkerInAddress(address: "188 Avenida SAP, Sao Leopoldo, RS", description: "Factory", isFactory: true)
            showMarkerInAddress(address: "2344 Avenida Presidente Vargas, Esteio, RS", description: "Farm")
            showMarkerInAddress(address: "Arena do Gremio, Porto Alegre, RS", description: "Farm")
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
    
    func showMarkerInAddress(address: String, description: String = "Description", isFactory: Bool = false) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location
                else {
                    return
            }
            let iconSrc = isFactory ? "factory.png" : "cow.png"
            self.showMarker(position: location.coordinate, title: address, description: description, iconSrc: iconSrc)
        })
    }

    func showMarker(position: CLLocationCoordinate2D, title: String, description snippet: String, iconSrc icon: String) {
        let marker = GMSMarker()
        marker.position = position
        marker.title = title
        marker.snippet = snippet
        marker.icon = UIImage(named: icon)
        marker.map = mapView
    }

    func fetchRoute() {
        let origin = "188 Avenida SAP, Sao Leopoldo, RS"
        let destination = "188 Avenida SAP, Sao Leopoldo, RS"
        let apiKey = "AIzaSyBVjW1BbO04oUZBRgNqp-hLr314w5LdA-U"
        let urlString = "https://maps.googleapis.com/maps/api/directions/json"

        let query: [String: String] = [
            "key": apiKey,
            "origin": origin,
            "destination": destination,
            "waypoints": "2344 Avenida Presidente Vargas, Esteio, RS|Arena do Gremio, Porto Alegre, RS"
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
