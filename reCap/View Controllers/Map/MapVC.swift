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
    
    private static let TAKE_PIC_FROM_RECENT = "Recent Photos (+1 point)"
    private static let TAKE_PIC_FROM_WEEK = "Photos over a week ago (+5 points)"
    private static let TAKE_PIC_FROM_MONTH = "Photos over a month ago (+15 points)"
    private static let TAKE_PIC_FROM_YEAR = "Photos from over a year ago (+50 points)"
    private static let CHALLENGE_RECENT_POINTS = 1
    private static let CHALLENGE_WEEK_POINTS = 5
    private static let CHALLENGE_MONTH_POINTS = 10
    private static let CHALLENGE_YEAR_POINTS = 20
    static let SECONDS_IN_WEEK = 604800
    static let SECONDS_IN_MONTH = PhotoLibChallengeVC.SECONDS_IN_WEEK * 4
    static let SECONDS_IN_YEAR = PhotoLibChallengeVC.SECONDS_IN_MONTH * 12
    
    // MARK: - Properties
    private var locations: [String]!
    private var locationDictionary: [String : [PictureData]]!
    
    var user: User!
    let ref = Database.database().reference()
    var mapView: NavigationMapView!
    var pins: [MGLPointAnnotation]! = []
    var pictureDataArray: [PictureData]! = []
    var userPictureDataArray: [PictureData]! = []
    
    
    var pictureIDArray: [String]! = []
    var pictureArray: [UIImage]! = []
    
    
    var directionsRoute: Route?
    var mapViewNavigation: NavigationMapView!
    
    var imageToPass: UIImage?
    var pictureDataToPass: PictureData?
    
    let darkColor = UIColor(red: 48/255, green: 48/255, blue: 48/255, alpha: 1.0)
    
    @IBOutlet weak var styleControl: UISegmentedControl!
    @IBOutlet weak var centerButton: UIButton!
    @IBAction func styleControlAction(_ sender: Any) {
        
        if styleControl.selectedSegmentIndex == 0 {
            mapView.styleURL = MGLStyle.outdoorsStyleURL()
            
            styleControl.tintColor = darkColor
            mapView.attributionButton.tintColor = darkColor
        }
        else {
            mapView.styleURL = MGLStyle.darkStyleURL()
            styleControl.tintColor = UIColor.white
            mapView.attributionButton.tintColor = UIColor.white
        }
        
    }
    @IBAction func centerAction(_ sender: Any) {
        
        if self.user.activeChallengeID != "" {
            FBDatabase.getPictureData(id: self.user.activeChallengeID, ref: ref) { (pictureData) in
                let lat = pictureData?.gpsCoordinates[0]
                let long = pictureData?.gpsCoordinates[1]
                let coordinate = CLLocationCoordinate2DMake(lat!, long!)
                self.mapView.setCenter(coordinate, zoomLevel: self.mapView.zoomLevel, direction: 0, animated: true)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let id = FBDatabase.getSignedInUserID()!
        let ref = Database.database().reference()
        FBDatabase.getUserOnce(with_id: id, ref: ref, with_completion: {(user) in
            if let activeUser = user {
                self.user = activeUser
                self.setupMap()
                let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.setupCamera()
                }
            }
        })
        /*if user != nil {
            setupMap()
            let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.setupCamera()
            }
            
        }*/
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupPictures()
        
        let when = DispatchTime.now() + 1.5 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            if self.user.activeChallengeID == "" {
                self.centerButton.isHidden = true
            }
            else {
                self.centerButton.isHidden = false
            }
        }
        
        
    }
    
    func setupCamera() {
        
        let user = self.mapView.userLocation?.coordinate
        self.mapView.setCenter(user!, zoomLevel: 2, direction: 0, animated: true)
        let camera = MGLMapCamera(lookingAtCenter: user!, fromDistance: 3000, pitch: 0, heading: 0)
        
        let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Animate the camera movement over 5 seconds.
            self.mapView.setCamera(camera, withDuration: 2, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
            
        }
    }
    
    func setupMap() {
        
        mapView = NavigationMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.compassView.isHidden = true
        
        
        
        if Bool.checkIfTimeIs(between: 0, and: 7) == true || Bool.checkIfTimeIs(between: 18, and: 23) == true {
            mapView.styleURL = MGLStyle.darkStyleURL()
            styleControl.selectedSegmentIndex = 1
            styleControl.tintColor = UIColor.white
            mapView.attributionButton.tintColor = UIColor.white
        }
        else {
            mapView.styleURL = MGLStyle.outdoorsStyleURL()
            styleControl.selectedSegmentIndex = 0
            styleControl.tintColor = darkColor
            mapView.attributionButton.tintColor = darkColor
        }
        
        view.addSubview(mapView)
        view.bringSubview(toFront: styleControl)
        view.bringSubview(toFront: centerButton)
        
        setupPictures()
        
        
    }
    
    
    func setupPictures() {
        
        //Need to grab all user submitted images, grab their GPS locations and store as a Dictionary Array. Then put pins down.
        //For now, just grab current users images for pins.
        
        locations = []
        locationDictionary = [:]
        
        if self.pins.count > 0 {
            self.mapView.removeAnnotations(self.pins)
            self.pins.removeAll()
        }
        
        
        
        FBDatabase.getAllMostRecentPictureData(ref: ref) { (rawPictureDataArray) in
            
            if rawPictureDataArray.count > 0 {
                for rawPictureData in rawPictureDataArray {
                    
                    let pin = MGLPointAnnotation()
                    pin.coordinate = CLLocationCoordinate2D(latitude: (rawPictureData.gpsCoordinates[0]), longitude: (rawPictureData.gpsCoordinates[1]))
                    pin.title = rawPictureData.name
                    pin.subtitle = rawPictureData.locationName
                    
                    self.pictureIDArray.append((rawPictureData.id)!)
                    self.pictureDataArray.append(rawPictureData)
                    
                    self.pins.append(pin)

                    if rawPictureData.id == rawPictureDataArray.last?.id {
                        self.setupPins()
                    }
                }
            }
            
        }
        
        
    }
    
    func setupPins() {
        self.mapView.addAnnotations(self.pins)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        
        
        
        
    }
    
    
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        
        // Assign a reuse identifier to be used by both of the annotation views, taking advantage of their similarities.
        let reuseIdentifier = "reusableDotView"
        
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            
            for picture in pictureDataArray {
                
                if picture.id == self.user.activeChallengeID {
                    if (annotation.coordinate.latitude == picture.gpsCoordinates[0]) && annotation.coordinate.longitude == picture.gpsCoordinates[1] {
                        annotationView!.backgroundColor = UIColor(red: 204/255, green: 51/255, blue: 51/255, alpha: 1.0)
                        return annotationView
                    }
                }
                
                if picture.id == pictureDataArray.last?.id {
                    annotationView!.backgroundColor = UIColor(red: 99/255, green: 207/255, blue: 155/255, alpha: 1.0)
                    return annotationView
                }
                
            }
            
            return annotationView
        }
        return annotationView
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
        
        if annotation is MGLUserLocation && mapView.userLocation != nil {
            return nil
        }
        else {
            return UIButton(type: .detailDisclosure)
        }
        
        
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
        let alert = UIAlertController(title: "What would you like to do?", message: nil , preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Navigate Here", style: .default, handler: { (action) in
            // Calculate the route from the user's location to the set destination
            self.beginNavigation()
        }))
        alert.addAction(UIAlertAction(title: "Set as Active Challenge", style: .default, handler: { (action) in
            // Calculate the route from the user's location to the set destination
            
            FBDatabase.getAllMostRecentPictureData(ref: self.ref, with_completion: { (pictureArray) in
                
                for picture in pictureArray {
                    
                    if (annotation.coordinate.latitude == picture.gpsCoordinates[0]) && annotation.coordinate.longitude == picture.gpsCoordinates[1] {
                        self.addChallengeToUser(pictureData: picture)
                        
                        self.centerButton.isHidden = false
                        break
                    }
                }
                
            })
            
            
            
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
    
    
    
    
    private func getPicChallengeCategory(pictureData: PictureData, currentDate: Date) -> String {
        //let pictureDate = DateGetter.getDateFromString(string: pictureData.time)
        let dateDiffSec = Int(abs(TimeInterval(pictureData.time)! - currentDate.timeIntervalSince1970))
        //let dateDiffSec = Int(abs(pictureDate.timeIntervalSince(currentDate)))
        if dateDiffSec >= MapVC.SECONDS_IN_YEAR {
            return MapVC.TAKE_PIC_FROM_YEAR
        }
        else if dateDiffSec >= MapVC.SECONDS_IN_MONTH {
            return MapVC.TAKE_PIC_FROM_MONTH
        }
        else if dateDiffSec >= MapVC.SECONDS_IN_WEEK {
            return MapVC.TAKE_PIC_FROM_WEEK
        }
        else {
            return MapVC.TAKE_PIC_FROM_RECENT
        }
    }
    
    private func addChallengeToUser(pictureData: PictureData) {
        let challengeCategory = getPicChallengeCategory(pictureData: pictureData, currentDate: Date())
        var points = 0
        if challengeCategory == MapVC.TAKE_PIC_FROM_WEEK {
            points = MapVC.CHALLENGE_WEEK_POINTS
        }
        else if challengeCategory == MapVC.TAKE_PIC_FROM_MONTH {
            points = MapVC.CHALLENGE_MONTH_POINTS
        }
        else if challengeCategory == MapVC.TAKE_PIC_FROM_YEAR {
            points = MapVC.CHALLENGE_YEAR_POINTS
        }
        else if challengeCategory == MapVC.TAKE_PIC_FROM_RECENT {
            points = MapVC.CHALLENGE_RECENT_POINTS
        }
        self.user.activeChallengeID = pictureData.id
        self.user.activeChallengePoints = points.description
        FBDatabase.addUpdateUser(user: self.user, with_completion: {(error) in
            if let actualError = error {
                print(actualError)
            }
            else {
                print("Added challenge to user")
            }
        })
        
        let lat = pictureData.gpsCoordinates[0]
        let long = pictureData.gpsCoordinates[1]
        let coordinate = CLLocationCoordinate2DMake(lat, long)
        self.mapView.setCenter(coordinate, zoomLevel: self.mapView.zoomLevel, direction: 0, animated: true)
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


// MGLAnnotationView subclass
class CustomAnnotationView: MGLAnnotationView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Force the annotation view to maintain a constant size when the map is tilted.
        scalesWithViewingDistance = false
        
        // Use CALayer’s corner radius to turn this view into a circle.
        layer.cornerRadius = frame.width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Animate the border width in/out, creating an iris effect.
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.duration = 0.1
        layer.borderWidth = selected ? frame.width / 4 : 2
        layer.add(animation, forKey: "borderWidth")
    }
}
