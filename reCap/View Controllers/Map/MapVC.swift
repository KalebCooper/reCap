//
//  MapVC.swift
//  reCap
//
//  Created by Jackson Delametter on 2/4/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import Firebase

class MapVC: UIViewController, MGLMapViewDelegate {
    
    // MARK: - Properties
    private var locations: [String]!
    private var locationDictionary: [String : [PictureData]]!
    
    var user: User!
    let ref = Database.database().reference()
    var mapView: NavigationMapView!
    var pins: [MGLPointAnnotation]! = []
    var pictureDataArray: [PictureData]! = []
    var pictureIDArray: [String]! = []
    var pictureArray: [UIImage]! = []
    
    var directionsRoute: Route?
    var mapViewNavigation: NavigationMapView!
    
    var imageToPass: UIImage?
    var pictureDataToPass: PictureData?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if user != nil {
            getUser()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }
    
    func getUser() {
        let id = FBDatabase.getSignedInUserID()
        FBDatabase.getUser(with_id: id!, ref: ref) { (user) in
            if user != nil {
                self.user = user
                self.setupMap()
            }
        }
    }



    func setupMap() {
        
        mapView = NavigationMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        
        mapView.styleURL = MGLStyle.outdoorsStyleURL()
        view.addSubview(mapView)
        
        setupPictures()
        
        
    }
    
    func setupPictures() {
        
        //Need to grab all user submitted images, grab their GPS locations and store as a Dictionary Array. Then put pins down.
        //For now, just grab current users images for pins.
        
        locations = []
        locationDictionary = [:]
        FBDatabase.getPictureData(for_user: self.user, ref: ref, with_completion: {(pictureDataList) in
            for pictureData in pictureDataList {
                let location = pictureData.locationName
                if !self.locations.contains(location!) {
                    // Location is not in the locations array
                    // Add it to the array and initialize
                    // an empty array for the key location
                    self.locations.append(location!)
                    self.locationDictionary[location!] = []
                }
                self.pictureDataArray = self.locationDictionary[location!]!
                self.pictureDataArray.append(pictureData)
                self.locationDictionary[location!] = self.pictureDataArray
                
                let pin = MGLPointAnnotation()
                pin.coordinate = CLLocationCoordinate2D(latitude: pictureData.gpsCoordinates[0], longitude: pictureData.gpsCoordinates[1])
                pin.title = pictureData.name
                pin.subtitle = pictureData.time
                
                self.pictureIDArray.append(pictureData.id)
                
                self.pins.append(pin)
                
            }
            
            print(self.locations)
            self.setupPins()
        })
        
    }
    
    func setupPins() {
        mapView.addAnnotations(pins)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        
        let user = mapView.userLocation?.coordinate
        mapView.setCenter(user!, zoomLevel: 2, direction: 0, animated: true)
        let camera = MGLMapCamera(lookingAtCenter: user!, fromDistance: 3000, pitch: 0, heading: 0)
        
        let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Animate the camera movement over 5 seconds.
            mapView.setCamera(camera, withDuration: 2, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
            
        }
        
        
    }
    
    
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    
    
    func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        for i in 0 ..< pins.count {
            if (annotation.coordinate.latitude == pins[i].coordinate.latitude) && annotation.coordinate.longitude == pins[i].coordinate.longitude {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
                FBDatabase.getPictureData(id: pictureIDArray[i], ref: ref) { (pictureData) in
                    if let realPictureData = pictureData{
                        FBDatabase.getPicture(pictureData: realPictureData, with_progress: {(progress, total) in
                            
                        }, with_completion: {(image) in
                            if let realImage = image {
                                imageView.image = realImage
                                imageView.contentMode = .scaleAspectFit
                                self.pictureDataToPass = realPictureData
                                self.imageToPass = realImage
                                imageView.hero.id = "imageID"
                            }
                            else {
                            }
                        })
                    }
                }
                return imageView
            }
        }
        return nil
    }
    
    
    
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        return UIButton(type: .detailDisclosure)
    }
    
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        // Hide the callout view.
        //mapView.deselectAnnotation(annotation, animated: true)
        
        self.calculateRoute(from: (mapView.userLocation!.coordinate), to: annotation.coordinate) { (route, error) in
            if error != nil {
                print("Error calculating route")
            }
        }
        
        // Ask user if they want to navigate to the pin.
        let alert = UIAlertController(title: "Navigate here?", message: nil , preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Set as Target", style: .default, handler: { (action) in
            // Set as target destination
            self.beginNavigation()
            
        }))
        alert.addAction(UIAlertAction(title: "Navigate", style: .default, handler: { (action) in
            // Calculate the route from the user's location to the set destination
            
           self.beginNavigation()
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        print("Tapped on image")
        //Present user to full screen image
        self.performSegue(withIdentifier: "ChallengeViewSegue", sender: self)
        
    }
    
    
    func calculateRoute(from origin: CLLocationCoordinate2D,
                        to destination: CLLocationCoordinate2D,
                        completion: @escaping (Route?, Error?) -> ()) {
        
        // Coordinate accuracy is the maximum distance away from the waypoint that the route may still be considered viable, measured in meters. Negative values indicate that a indefinite number of meters away from the route and still be considered viable.
        let origin = Waypoint(coordinate: origin, coordinateAccuracy: -1, name: "Start")
        let destination = Waypoint(coordinate: destination, coordinateAccuracy: -1, name: "Finish")
        
        // Specify that the route is intended for automobiles avoiding traffic
        let options = NavigationRouteOptions(waypoints: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)
        
        // Generate the route object and draw it on the map
        _ = Directions.shared.calculate(options) { [unowned self] (waypoints, routes, error) in
            self.directionsRoute = routes?.first
            // Draw the route on the map after creating it
            self.drawRoute(route: self.directionsRoute!)
        }
    }
    
    
    
    
    func drawRoute(route: Route) {
        guard route.coordinateCount > 0 else { return }
        // Convert the route’s coordinates into a polyline
        var routeCoordinates = route.coordinates!
        let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
        
        // If there's already a route line on the map, reset its shape to the new route
        if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
            source.shape = polyline
        } else {
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
            
            // Customize the route line color and width
            let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            lineStyle.lineColor = MGLStyleValue(rawValue: #colorLiteral(red: 0.1897518039, green: 0.3010634184, blue: 0.7994888425, alpha: 1))
            lineStyle.lineWidth = MGLStyleValue(rawValue: 3)
            
            // Add the source and style layer of the route line to the map
            mapView.style?.addSource(source)
            mapView.style?.addLayer(lineStyle)
        }
    }
    
    func beginNavigation() {
        print("Presenting Navigation View")
        let navigationViewController = NavigationViewController(for: self.directionsRoute!)
        self.present(navigationViewController, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let segueID = segue.identifier
        if segueID == "ChallengeViewSegue" {
            let nav = segue.destination as! UINavigationController
            let destination = nav.topViewController as! ChallengeViewVC
            
            //let destination = segue.destination as! ChallengeViewVC
            let pictureData = pictureDataToPass
            let picture = imageToPass
            destination.pictureData = pictureData
            destination.image = picture
            print("Segue Done")
        }
    }

}
