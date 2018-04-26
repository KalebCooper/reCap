//
//  CameraContainerVC.swift
//  reCap
//
//  Created by Kaleb Cooper on 2/6/18.
//  Copyright © 2018 Kaleb Cooper. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SwiftLocation
import Hero
import Firebase
import CoreLocation
import CoreMotion
import FCAlertView
import RealmSwift

class CameraContainerVC: UIViewController, AVCapturePhotoCaptureDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, HorizontalDialDelegate {
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var logoText: UIImageView!
    @IBOutlet weak var profileOutlet: UIImageView!
    @IBOutlet weak var albumOutlet: UIButton!
    @IBOutlet weak var previousOutlet: UIButton!
    @IBOutlet weak var arrowOutlet: UIImageView!
    
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var bearingPickerOutlet: HorizontalDial!
    @IBOutlet weak var bearingOutlet: UILabel!
    
    var imageToPass: UIImage?
    var latToPass: Double?
    var longToPass: Double?
    var bearingToPass: Double?
    var locationToPass: String?
    private var isAtChallengeLocation: Bool!
    let locationManager = CLLocationManager()
    var destinationAngle: Double? = 0
    private var userData: UserData!
    private var realm: Realm!
    private var hasUpdateUserLocation = false
    
    var profileImage: UIImage?
    
    
    var session: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var photoSetting = AVCapturePhotoSettings()
    
    var captureDevice: AVCaptureDevice?
    
    var previousImageView: UIImageView?
    var previousImageContentMode: UIViewContentMode?
    
    var motionManager = CMMotionManager()
    
    
    let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    var user: User!
    private var activeChallengePicData: PictureData!
    //private let Threshold = 0.000017
    private let chalBestCoordThreshold = 0.0001
    private let chalCloseCoordThreshold = 0.005
//    private let chalBestCoordThreshold = 1.0
//    private let chalCloseCoordThreshold = 1.0
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        print("Button Pressed")
        if cameraButton.layer.borderColor == UIColor.red.cgColor {

            FCAlertView.displayAlert(title: "Error", message: "Please make sure the camera is perpendicular to the ground.", buttonTitle: "Okay", type: "warning", view: self, blur: true)

        }
        else {
            self.stillImageOutput?.capturePhoto(with: self.photoSetting, delegate: self)
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                
                let inputs = self.session?.inputs
                for oldInput:AVCaptureInput in inputs! {
                    self.session?.removeInput(oldInput)
                }
                
                let outputs = self.session?.outputs
                for oldOutput:AVCaptureOutput in outputs! {
                    self.session?.removeOutput(oldOutput)
                }
                
                self.session?.stopRunning()
                self.locationManager.stopUpdatingHeading()
                print("Camera Session Stopping")
            
            }
        }
        
        
    }
    @IBAction func albumAction(_ sender: Any) {
        self.performSegue(withIdentifier: "PhotoLibSegue", sender: self.user)
    }

    
    @IBAction func previousHoldAction(_ sender: Any) {
        print("Touching")
        
        self.previewView.addSubview(self.previousImageView!)
        
         if self.previousImageContentMode == .scaleToFill {
            
            if UIDevice.current.orientation == .portrait {
                UIView.animate(withDuration: 0.25, animations: {
                    self.previousImageView?.alpha = 1.0
                })
            }
            
        }
        else {
            
            UIView.animate(withDuration: 0.25, animations: {
                self.previousImageView?.alpha = 1.0
            })
            
        }
    }
    
    @IBAction func previousUpInside(_ sender: Any) {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.previousImageView?.alpha = 0.0
        })
        
        //self.previousImageView?.removeFromSuperview()
        print("Touching ended inside")
        
        
    }
    @IBAction func previousUpOutside(_ sender: Any) {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.previousImageView?.alpha = 0.0
        })
        //self.previousImageView?.removeFromSuperview()
        print("Touching ended outside")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Camera container loaded")
        setupHero()
        setupCamera(clear: false)
        configureButton()
        setupGestures()
        setupDial()
    }
    
    
    func setupDial() {
        
        bearingPickerOutlet?.delegate = self
        bearingPickerOutlet?.animateOption = .easeOutElastic
        bearingPickerOutlet?.enableRange = true
        bearingPickerOutlet?.minimumValue = 0
        bearingPickerOutlet?.maximumValue = 359
        bearingPickerOutlet?.value = 90
        bearingPickerOutlet?.tick = 10
        bearingPickerOutlet?.centerMarkWidth = 3
        bearingPickerOutlet?.centerMarkRadius = 3.0
        bearingPickerOutlet.centerMarkHeightRatio = 0.75
        bearingPickerOutlet?.markColor = UIColor.white
        bearingPickerOutlet.centerMarkColor = UIColor.red
        bearingPickerOutlet?.markWidth = 1.0
        //bearingPickerOutlet?.markRadius = 0.5
        bearingPickerOutlet?.markCount = 10
        bearingPickerOutlet?.padding = 16
        bearingPickerOutlet?.verticalAlign = "top"
        bearingPickerOutlet?.backgroundColor = UIColor.clear
        
        
    }
    
    
    func horizontalDialDidValueChanged(_ horizontalDial: HorizontalDial) {
        
        let value = horizontalDial.value.truncate(places: 3)
        
        let roundedValue = value.round(nearest: 1)
        
        if roundedValue.truncatingRemainder(dividingBy: 1) == 0 {
            
            if UIDevice.current.orientation == .landscapeLeft {
                if roundedValue + 90.0 > 360 {
                    bearingOutlet.text = String((roundedValue + 90.0) - 360) + "°"
                    self.bearingToPass = (roundedValue + 90.0) - 360
                }
                else {
                    bearingOutlet.text = String(roundedValue + 90.0) + "°"
                    self.bearingToPass = roundedValue + 90.0
                }
                
            }
            else if UIDevice.current.orientation == .landscapeRight {
                if roundedValue + 90.0 > 360 {
                    
                    bearingOutlet.text = String((roundedValue - 90.0) - 360) + "°"
                    self.bearingToPass = (roundedValue - 90.0) - 360
                    
                }
                else {
                    bearingOutlet.text = String(roundedValue - 90.0) + "°"
                    self.bearingToPass = roundedValue - 90.0
                }
            }
            else {
                bearingOutlet.text = String(roundedValue) + "°"
                self.bearingToPass = roundedValue
            }
            
            
        }
    }
    
    func updateHorizontalDialValue(value: Double) {
        
        bearingPickerOutlet.value = value
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hasUpdateUserLocation = false
    }
    
    func setupProfileImage() {
        if self.profileImage != nil {
            self.profileOutlet.image = self.profileImage
            self.profileOutlet.layer.borderWidth = 1
            self.profileOutlet.layer.borderColor = UIColor.white.cgColor
            self.profileOutlet.layer.cornerRadius = self.profileOutlet.layer.frame.width / 2
            self.profileOutlet.layer.masksToBounds = false
            self.profileOutlet.clipsToBounds = true
            self.profileOutlet.contentMode = .scaleAspectFill
        }
        else {
            FBDatabase.getProfilePicture(for_user: userData, with_progress: { (progress, total)  in
                
            }, with_completion: { (image) in
                if let actualImage = image {
                    self.profileImage = actualImage
                }
                else {
                    print("Did not get profile picture in Camera Container VC")
                }
                self.profileOutlet.image = self.profileImage
                self.profileOutlet.layer.borderWidth = 1
                self.profileOutlet.layer.borderColor = UIColor.white.cgColor
                self.profileOutlet.layer.cornerRadius = self.profileOutlet.layer.frame.width / 2
                self.profileOutlet.layer.masksToBounds = false
                self.profileOutlet.clipsToBounds = true
                self.profileOutlet.contentMode = .scaleAspectFill
            })
        }
    }
    
    
    func setupUserLocation() {
        Locator.requestAuthorizationIfNeeded(.always)
        let request = Locator.subscribePosition(accuracy: .room, onUpdate: { location in
            let lat = location.coordinate.latitude.truncate(places: 6)
            let long = location.coordinate.longitude.truncate(places: 6)
            let location = CLLocation(latitude: lat, longitude: long)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if error == nil {
                    try! self.realm.write {
                        self.userData.state = placemarks?.last?.administrativeArea
                        self.userData.country = placemarks?.last?.country
                    }
                }
                else {
                    try! self.realm.write {
                        self.userData.state = ""
                        self.userData.country = ""
                    }
                }
                
                let when = DispatchTime.now() + 5 // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when) {
                    /*FBDatabase.addUpdateUser(user: self.user, with_completion: { (error) in
                    })*/
                    
                    geocoder.cancelGeocode()
                }
                
            }
        }, onFail: { (error, last) in
            print(error)
            print("DID NOT GET LOCATION")
        })
        
        let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            Locator.stopRequest(request)
        }
    }
    
    /*
     Gets the GPS coordinates of the active
     picture challenges. Used to change the color
     of the gps coordinates when on the exact location
     */
    private func setupActiveChallenge() {
        self.activeChallengePicData = self.userData.activeChallengeID
        if self.activeChallengePicData != nil {
            // There is an active challenge
            self.previousOutlet.isEnabled = true
            self.arrowOutlet.isHidden = false
            FBDatabase.getPicture(pictureData: self.activeChallengePicData, with_progress: { (progress, total) in
                }, with_completion: { (image) in
                    if let realImage = image {
                        self.previousImageView = UIImageView(frame: self.view.frame)
                        self.previousImageView?.image = realImage
                        self.previousImageView?.alpha = 0.0
                        
                    if realImage.imageOrientation == .left || realImage.imageOrientation == .right {
                        self.previousImageView?.contentMode = .scaleToFill
                        self.previousImageContentMode = .scaleToFill
                    }
                    else {
                        self.previousImageView?.contentMode = .scaleAspectFill
                        self.previousImageContentMode = .scaleAspectFill
                    }
                    self.previewView.addSubview(self.previousImageView!)
                }
                else {
                    // Could not get image
                    self.previousOutlet.isEnabled = false
                    self.arrowOutlet.isHidden = true
                }
            })
        }
        else {
            self.previousOutlet.isEnabled = false
            self.arrowOutlet.isHidden = true
        }
    }
    
    func setupHero() {
        
        let duration: TimeInterval = TimeInterval(exactly: 0.5)!
        
        logoText.hero.modifiers = [.forceNonFade, .duration(duration), .useScaleBasedSizeChange]
        
        profileOutlet.hero.modifiers = [.duration(duration), .arc(intensity: 1.0)]
        
        albumOutlet.hero.modifiers = [.forceNonFade, .duration(duration), .arc(intensity: 1.0)]
        
        previousOutlet.hero.modifiers = [.fade, .duration(duration), .arc(intensity: 1.0)]
        
        cameraButton.hero.modifiers = [.duration(duration), .arc(intensity: 1.0)]
        
    }
    
    func setupGestures() {
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                self.performSegue(withIdentifier: "toProfileSegue", sender: self)
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    
    public func setupCamera(clear: Bool) {
        
        photoSetting = AVCapturePhotoSettings.init(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        photoSetting.isAutoStillImageStabilizationEnabled = true
        photoSetting.flashMode = .off
        
        
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSession.Preset.high
        
        
        
        let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        
        try! backCamera?.lockForConfiguration()
        backCamera?.focusMode = .continuousAutoFocus
        backCamera?.isSmoothAutoFocusEnabled = true
        backCamera?.whiteBalanceMode = .continuousAutoWhiteBalance
        backCamera?.unlockForConfiguration()
        
        
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera!)
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
        
        if error == nil && session!.canAddInput(input) {
            
            session!.addInput(input)
            // ...
            // The remainder of the session setup will go here...
            stillImageOutput = AVCapturePhotoOutput()
            stillImageOutput?.photoSettingsForSceneMonitoring?.livePhotoVideoCodecType = .jpeg
            
            
            if session!.canAddOutput(stillImageOutput!) {
                session!.addOutput(stillImageOutput!)
                
                // Configure the Live Preview here...
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
                videoPreviewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
                
                if UIDevice.current.orientation == .portrait {
                    videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                }
                else if UIDevice.current.orientation == .landscapeLeft {
                    videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
                }
                else if UIDevice.current.orientation == .landscapeRight {
                    videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
                }
                
                previewView.layer.addSublayer(videoPreviewLayer!)
                session!.startRunning()
                
                let when = DispatchTime.now() + 0.01 // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.viewDidAppear(false)
                }
                
            }
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureButton() {
        
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = 2
        cameraButton.layer.cornerRadius = 40
        
        
        // Ensure to keep a strong reference to the motion manager otherwise you won't get updates
        motionManager = CMMotionManager()
        if motionManager.isDeviceMotionAvailable == true {
            
            motionManager.deviceMotionUpdateInterval = 0.25;
            
            let queue = OperationQueue()
            //motionManager.startDeviceMotionUpdates(to: queue, withHandler: { [weak self] (motion, error) -> Void in
            motionManager.startDeviceMotionUpdates(using: CMAttitudeReferenceFrame.xArbitraryCorrectedZVertical, to: queue) { (motion, error) in
                
                let gravityZ: Double = motion!.gravity.z
                
                DispatchQueue.main.async {
                    
                    if (Swift.abs(gravityZ) < 0.25) {
                            self.cameraButton.layer.borderColor = UIColor.green.cgColor
                    }
                    else {
                            self.cameraButton.layer.borderColor = UIColor.red.cgColor
                    }
            
                }
                
            }
        }
        else {
            print("Device motion unavailable");
        }
        
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        
        
        UIView.animate(withDuration: 0.25, animations: {
            self.previousImageView?.alpha = 0.0
        })
        
        
        if self.previousImageContentMode == .scaleToFill {
            
            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
                
                self.previousImageView?.frame = self.previewView.frame
                self.previousImageView?.contentMode = .center
                self.previousOutlet.isEnabled = false
                
            }
            else {
                self.previousImageView?.contentMode = .scaleToFill
                self.previousOutlet.isEnabled = true
            }
            
        }
        
        
        let when = DispatchTime.now() + 0.01 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.viewDidAppear(false)
        }
    }
    
    
    func setupLocation() {
        Locator.requestAuthorizationIfNeeded(.always)
        Locator.requestAuthorizationIfNeeded(.whenInUse)
        // Azimuth
        if (CLLocationManager.headingAvailable()) {
            locationManager.headingFilter = 1
            locationManager.startUpdatingHeading()
            locationManager.delegate = self
        }
        Locator.subscribePosition(accuracy: .room, onUpdate: { location in
            let lat = location.coordinate.latitude.truncate(places: 6)
            let long = location.coordinate.longitude.truncate(places: 6)
            
            let gpsString = String.convertGPSCoordinatesToOutput(coordinates: [lat, long])
            self.locationOutlet.text = gpsString
            self.latToPass = lat
            self.longToPass = long
            self.locationToPass = gpsString
            
            if !self.hasUpdateUserLocation {
                try! self.realm.write {
                    self.userData.longitude = long
                    self.userData.latitude = lat
                }
                self.hasUpdateUserLocation = true
            }
            if self.activeChallengePicData != nil {
                let picLong = self.activeChallengePicData.longitude
                let picLat = self.activeChallengePicData.latitude
                var destination: CLLocation? = CLLocation(latitude: 0, longitude: 0)
                var angle: Double = 0
                destination = CLLocation(latitude: picLat, longitude: picLong)
                angle = self.getBearingBetweenTwoPoints1(point1: location, point2: destination!)
                self.destinationAngle = angle
                let longDiff = abs(picLong - long)
                let latDiff = abs(picLat - lat)
                if longDiff > self.chalCloseCoordThreshold || latDiff > self.chalCloseCoordThreshold {
                    self.locationOutlet.textColor = UIColor.white
                    self.isAtChallengeLocation = false
                }
                else if longDiff < self.chalBestCoordThreshold && latDiff < self.chalBestCoordThreshold {
                    self.locationOutlet.textColor = UIColor.green
                    self.isAtChallengeLocation = true
                }
                else if longDiff <= self.chalCloseCoordThreshold && latDiff <= self.chalCloseCoordThreshold {
                    self.locationOutlet.textColor = UIColor.yellow
                    self.isAtChallengeLocation = true
                }
            }
            else {
                self.locationOutlet.textColor = UIColor.white
                self.isAtChallengeLocation = false
            }
        },onFail: { (error, last) in
            print(error)
        })
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        updateHorizontalDialValue(value: heading.magneticHeading)
        UIView.animate(withDuration: 0.25, animations: {
            self.arrowOutlet.transform = CGAffineTransform(rotationAngle: CGFloat((self.destinationAngle! - heading.magneticHeading) * Double.pi / 180))
        })
        
        
    }
    
    
    func setupOrientation() {
        
        if UIDevice.current.orientation == .portrait {
            self.videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        }
        else if UIDevice.current.orientation == .landscapeLeft {
            self.videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
        }
        else if UIDevice.current.orientation == .landscapeRight {
            self.videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
        }
        
        
        videoPreviewLayer!.frame = previewView.bounds
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup()
    }
    
    private func setup() {
        self.realm = try! Realm()
        let id = SyncUser.current?.identity
        self.userData = realm.object(ofType: UserData.self, forPrimaryKey: id)
        if self.userData != nil {
            // Got user data from realm database
            setupProfileImage()
            setupActiveChallenge()
            setupUserLocation()
            setupLocation()
        }
        else {
            print("Did not get user data")
        }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if self.videoPreviewLayer != nil {
                self.setupOrientation()
                if self.session?.inputs.count == 0 {
                    self.setupCamera(clear: false)
                }
                self.locationManager.startUpdatingHeading()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error == nil {
            
            let imageData = photo.fileDataRepresentation()
            
            var orientation: UIImageOrientation? = UIImageOrientation.right
            
            if UIDevice.current.orientation == .portrait {
                orientation = UIImageOrientation.right
            }
            else if UIDevice.current.orientation == .landscapeLeft {
                orientation = UIImageOrientation.up
            }
            else if UIDevice.current.orientation == .landscapeRight {
                orientation = UIImageOrientation.down
            }
            else if UIDevice.current.orientation == .portraitUpsideDown {
                orientation = UIImageOrientation.left
            }
            else if UIDevice.current.orientation == .faceDown {
                orientation = UIImageOrientation.down
            }
            else if UIDevice.current.orientation == .faceUp {
                orientation = UIImageOrientation.up
            }
            
            let newImage = UIImage(data: imageData!)!
            
            let orientedImage = UIImage(cgImage: newImage.cgImage!, scale: newImage.scale, orientation: orientation!)
            
            self.imageToPass = orientedImage
            
            self.performSegue(withIdentifier: "confirmPictureSegue", sender: self)
        }
        
        
        
    }
    
    //MARK: - Navigation Arrow Functionality
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {
        
        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansToDegrees(radians: radiansBearing)
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let segueID = segue.identifier
        
        if segueID == "confirmPictureSegue" {
            let vc = segue.destination as! ImageConfirmVC
            vc.isAtChallengeLocation = self.isAtChallengeLocation
            vc.image = self.imageToPass
            vc.latToPass = self.latToPass
            vc.longToPass = self.longToPass
            vc.bearingToPass = self.bearingToPass
            vc.locationToPass = self.locationToPass
            //vc.user = self.user
            vc.userData = self.userData
            vc.previousPic = self.activeChallengePicData
        }
        else if segueID == "toProfileSegue" {
            let vc = segue.destination as! ProfileMenuVC
            vc.image = self.profileOutlet.image
            //vc.user = self.user
            vc.userData = self.userData
        }
        else if segueID == "PhotoLibSegue" {
            let destination = segue.destination as! UINavigationController
            let photoLibVC = destination.topViewController as! PhotoLibChallengeVC
            //photoLibVC.user = self.user
            photoLibVC.userData = self.userData
            photoLibVC.mode = PhotoLibChallengeVC.FRIENDS_PHOTO_LIB_MODE
        }
        
    }
}



