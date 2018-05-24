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
    let factoryAddress = "188 Avenida SAP, Sao Leopoldo, RS"
    let apiKey = "AIzaSyBVjW1BbO04oUZBRgNqp-hLr314w5LdA-U"
    let directionsUrl = "https://maps.googleapis.com/maps/api/directions/json"
    var farms: [Farm]?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFarms()
        let camera = GMSCameraPosition.camera(withLatitude: -29.7965353, longitude: -51.148414, zoom: 10.0)
        mapView.camera = camera
        showMarkers()
    }
    
    @IBAction func mapRouteBtnPress(_ sender: UIButton) {
        var imageSrc :String
        if !routeDisplayed {
            fetchRoute()
            showMarkers()
            imageSrc = "stop.png"
        } else {
            mapView.clear()
            showMarkers()
            imageSrc = "replay-icon.png"
        }
        if let image = UIImage(named: imageSrc) {
            mapRouteButton.setImage(image, for: .normal)
        }
        routeDisplayed = !routeDisplayed
    }
    
    func loadFarms() {
        farms = Farm.loadFarms() ?? Farm.loadSampleFarms()
        mapRouteButton.isEnabled = farms != nil
    }
    
    func showMarkers() {
        showMarkerInAddress(address: "188 Avenida SAP, Sao Leopoldo, RS", description: "Factory", isFactory: true)
        guard farms != nil else { return }
        for farm in farms! {
            showMarkerInAddress(address: farm.address, description: farm.name)
        }
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
        let url = buildUrl()

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as! [String : AnyObject]
                    let routes = json["routes"] as! NSArray
                    guard routes.count > 0 else { return }
                    let route = routes[0]

                    DispatchQueue.main.async {
                        self.mapView.clear()

                        let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                        let points = routeOverviewPolyline.object(forKey: "points")
                        let path = GMSPath.init(fromEncodedPath: points! as! String)
                        let polyline = GMSPolyline.init(path: path)
                        polyline.strokeWidth = 3

                        let bounds = GMSCoordinateBounds(path: path!)
                        self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))

                        polyline.map = self.mapView
                    }
                } catch let error as Error{
                    print("error:\(error)")
                }
            }
        }
        task.resume()
    }

    func buildUrl() -> URL {
        let query: [String: String] = [
            "key": apiKey,
            "origin": factoryAddress,
            "destination": factoryAddress,
            "waypoints": formatWaypoints(farms: farms!)
        ]
        let baseURL = URL(string: directionsUrl)!
        return baseURL.withQueries(query)!
    }

    func formatWaypoints(farms: [Farm]) -> String {
        var formatted: String = ""
        for farm in farms {
            if formatted.count > 0 {
                formatted += "|"
            }
            formatted += farm.address
        }
        return formatted
    }
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
