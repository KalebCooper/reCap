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

class CameraContainerVC: UIViewController, AVCapturePhotoCaptureDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var logoText: UIImageView!
    @IBOutlet weak var profileOutlet: UIImageView!
    @IBOutlet weak var albumOutlet: UIButton!
    @IBOutlet weak var previousOutlet: UIButton!
    @IBOutlet weak var arrowOutlet: UIImageView!
    
    @IBOutlet weak var previewView: UIView!
    
    
    var imageToPass: UIImage?
    var latToPass: Double?
    var longToPass: Double?
    var locationToPass: String?
    private var isAtChallengeLocation: Bool!
    let locationManager = CLLocationManager()
    var destinationAngle: Double? = 0
    
    var profileImage: UIImage?
    
    
    var session: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var photoSetting = AVCapturePhotoSettings()
    
    var captureDevice: AVCaptureDevice?
    
    var previousImageView: UIImageView?
    var previousImageContentMode: UIViewContentMode?
    
    
    let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    var user: User!
    private var activeChallengePicData: PictureData!
    //private let Threshold = 0.000017
    private let chalBestCoordThreshold = 0.0001
    private let chalCloseCoordThreshold = 0.005
//    private let chalBestCoordThreshold = 1.0
//    private let chalCloseCoordThreshold = 1.0
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        
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
        /*if user != nil {
            setupProfileImage()
            setupUserLocation()
            setupHero()
            setupCamera(clear: false)
            configureButton()
            setupGestures()
            print("Finished setting up camera container")
        }*/
        setupHero()
        setupCamera(clear: false)
        configureButton()
        setupGestures()
    }
    

    
    func userUpdated() {
        self.setupActiveChallengeData()
        self.setupPreviousPicture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("The users active challenge is \(self.user.activeChallengeID)")
    }
    
    func setupProfileImage() {
        
        FBDatabase.getProfilePicture(for_user: user!, with_progress: { (progress, total)  in
            
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
        self.setupActiveChallengeData()
    }
    
    
    func setupUserLocation() {
        
        Locator.requestAuthorizationIfNeeded(.always)
        
        let locator = Locator

        let request = locator.subscribePosition(accuracy: .room, onUpdate: { location in
            
                                    
            let lat = location.coordinate.latitude.truncate(places: 6)
            let long = location.coordinate.longitude.truncate(places: 6)
        
            let location = CLLocation(latitude: lat, longitude: long)
            
            let geocoder = CLGeocoder()
            
            
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                
                print("Getting geocoder")
                
                if error == nil {
                    self.user.state = placemarks?.last?.administrativeArea
                    self.user.country = placemarks?.last?.country
                }
                else {
                    self.user.state = ""
                    self.user.country = ""
                }
                
                let when = DispatchTime.now() + 5 // change 2 to desired number of seconds
                DispatchQueue.main.asyncAfter(deadline: when) {
                    FBDatabase.addUpdateUser(user: self.user, with_completion: { (error) in
                    })
                    
                    geocoder.cancelGeocode()
                }
                
            }
        
        
        
        }, onFail: { (error, last) in
            print(error)
            
        })
        
        Locator.stopRequest(request)

    }
    
    /*
     Gets the GPS coordinates of the active
     picture challenges. Used to change the color
     of the gps coordinates when on the exact location
     */
    private func setupActiveChallengeData() {
        let id = self.user.activeChallengeID
        if id != "" {
            
            // If there is an actual id and not just the place holder
            let ref = Database.database().reference()
            FBDatabase.getPictureData(id: id!, ref: ref, with_completion: {(pictureData) in
                
                if pictureData != nil {
                    if let activePictureData = pictureData {
                        self.activeChallengePicData = activePictureData
                        print("Got challenge pic data in Camera Container VC")
                    }
                    else {
                        print("Did not get challenge pic data in camera container VC")
                    }
                    
                }
                
            })
        }
        else {
            // There is not an active challenge, make sure the active challenge is set to nil
            print("There is not an active challenge in camera container VC")
            self.activeChallengePicData = nil
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
        
        print("Setting up camera")
        
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
        
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.previousImageView?.alpha = 0.0
        })
        
        
        if self.previousImageContentMode == .scaleToFill {
            
            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
                
                print("Setting to scaleAspectFit")
                self.previousImageView?.frame = self.previewView.frame
                self.previousImageView?.contentMode = .center
                self.previousOutlet.isEnabled = false
                
            }
            else {
                print("Setting to scaleToFill")
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
        
        
        Locator.subscribePosition(accuracy: .room,
                                  onUpdate: { location in
                                    
                                    let lat = location.coordinate.latitude.truncate(places: 6)
                                    let long = location.coordinate.longitude.truncate(places: 6)
                                
                                    
                                    
                                    if self.user.activeChallengeID != "" {
                                        let activeChallengeID = String(self.user.activeChallengeID)
                                        var destination: CLLocation? = CLLocation(latitude: 0, longitude: 0)
                                        var angle: Double = 0
                                        
                                        let ref = Database.database().reference()
                                        FBDatabase.getPictureData(id: activeChallengeID, ref: ref, with_completion: { (pictureData) in
                                            
                                            if pictureData != nil {
                                                
                                                let destinationArray = pictureData?.gpsCoordinates
                                                destination = CLLocation(latitude: destinationArray![0], longitude: destinationArray![1])
                                                angle = self.getBearingBetweenTwoPoints1(point1: location, point2: destination!)
                                                
                                                self.previousOutlet.isEnabled = true
                                                self.arrowOutlet.isHidden = false
                                                self.destinationAngle = angle
                                                
                                            }

                                        })
                                        
                                        
                                    }
                                    else {
                                        self.previousOutlet.isEnabled = false
                                        self.arrowOutlet.isHidden = true
                                    }
                                    
                                    
                                    
                                    let gpsString = String.convertGPSCoordinatesToOutput(coordinates: [lat, long])
                                    
                                    self.locationOutlet.text = gpsString
                                    
                                    self.latToPass = lat
                                    self.longToPass = long
                                    self.locationToPass = gpsString
                                    if self.activeChallengePicData != nil {
                                        // There is a active challenge
                                        let picLong = self.activeChallengePicData.gpsCoordinates[PictureData.LONGITUDE_INDEX]
                                        let picLat = self.activeChallengePicData.gpsCoordinates[PictureData.LATTITUDE_INDEX]
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
                                    
        },
                                  onFail: { (error, last) in
                                    
                                    print(error)
        }
        )
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
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
    
    func setupPreviousPicture() {
        let challengeID = self.user.activeChallengeID
        let ref = Database.database().reference()
        if challengeID != "" {
            FBDatabase.getPictureData(id: challengeID!, ref: ref) { (pictureData) in
                if pictureData != nil {
                    FBDatabase.getPicture(pictureData: pictureData!, with_progress: { (progress, total) in
                        
                    }, with_completion: { (image) in
                        
                        self.previousImageView = UIImageView(frame: self.view.frame)
                        self.previousImageView?.image = image
                        self.previousImageView?.alpha = 0.0
                        
                        if image?.imageOrientation == .left || image?.imageOrientation == .right {
                            self.previousImageView?.contentMode = .scaleToFill
                            self.previousImageContentMode = .scaleToFill
                        }
                        else {
                            self.previousImageView?.contentMode = .scaleAspectFill
                            self.previousImageContentMode = .scaleAspectFill
                        }
                        
                        self.previewView.addSubview(self.previousImageView!)
                        
                    }
                    )
                }
                else {
                    
                    self.previousOutlet.isEnabled = false
                    self.previousOutlet.isHidden = true
                    
                }
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let ref = Database.database().reference()
        let id = FBDatabase.getSignedInUserID()!
        FBDatabase.getUserOnce(with_id: id, ref: ref, with_completion: {(user) in
            if let activeUser = user {
                self.user = activeUser
                self.setupProfileImage()
                self.setupUserLocation()
                self.setupPreviousPicture()
                self.setupLocation()
                print("Got user in camera container vc")
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    if self.videoPreviewLayer != nil {
                        self.setupOrientation()
                        if self.session?.inputs.count == 0 {
                            print("TESTING CAMERA")
                            self.setupCamera(clear: false)
                        }
                        self.locationManager.startUpdatingHeading()
                        print("Camera Session Resuming")
                    }
                }
            }
            else {
                print("Did not get active user in Camera container")
            }
        })
        
        /*if self.user != nil {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                if self.videoPreviewLayer != nil {
                    self.setupOrientation()
                    if self.session?.inputs.count == 0 {
                        print("TESTING CAMERA")
                        self.setupCamera(clear: false)
                    }
                    self.locationManager.startUpdatingHeading()
                    print("Camera Session Resuming")
                }
            }
        }*/
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
                print("Picture taken in Portrait")
                orientation = UIImageOrientation.right
            }
            else if UIDevice.current.orientation == .landscapeLeft {
                print("Picture taken in left")
                orientation = UIImageOrientation.up
            }
            else if UIDevice.current.orientation == .landscapeRight {
                print("Picture taken in right")
                orientation = UIImageOrientation.down
            }
            else if UIDevice.current.orientation == .portraitUpsideDown {
                print("Picture taken in down")
                orientation = UIImageOrientation.left
            }
            else if UIDevice.current.orientation == .faceDown {
                print("Picture taken in down")
                orientation = UIImageOrientation.down
            }
            else if UIDevice.current.orientation == .faceUp {
                print("Picture taken in down")
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
            vc.locationToPass = self.locationToPass
            vc.user = self.user
            vc.previousPic = self.activeChallengePicData
        }
        else if segueID == "toProfileSegue" {
            let vc = segue.destination as! ProfileMenuVC
            vc.image = self.profileOutlet.image
            vc.user = self.user
        }
        else if segueID == "PhotoLibSegue" {
            let destination = segue.destination as! UINavigationController
            let photoLibVC = destination.topViewController as! PhotoLibChallengeVC
            photoLibVC.user = self.user
            photoLibVC.mode = PhotoLibChallengeVC.PHOTO_LIB_MODE
        }
        
    }
}



