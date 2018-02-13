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

class CameraContainerVC: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var logoText: UIImageView!
    
    @IBOutlet weak var previewView: UIView!
    
    var portraitShadow: EdgeShadowLayer? = nil
    var landscapeShadow: EdgeShadowLayer? = nil
    
    
    var session: AVCaptureSession?
    var stillImageOutput: AVCapturePhotoOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var photoSetting = AVCapturePhotoSettings()
    
    var captureDevice: AVCaptureDevice?
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        
        print("Test")
        stillImageOutput?.capturePhoto(with: photoSetting, delegate: self)
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupCamera()
        initializeShadow()
        configureButton()
        setupLocation()
        
        self.viewDidAppear(false)
        
        // Do any additional setup after loading the view.
    }
    
    
    public func setupCamera() {
        
        photoSetting = AVCapturePhotoSettings.init(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        photoSetting.isAutoStillImageStabilizationEnabled = true
        photoSetting.flashMode = .off
        
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSession.Preset.high
        
        
        
        let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        
        try! backCamera?.lockForConfiguration()
        backCamera?.focusMode = .continuousAutoFocus
        backCamera?.isSmoothAutoFocusEnabled = true
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
                    print("Portrait")
                    videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                }
                else if UIDevice.current.orientation == .landscapeLeft {
                    print("Landscape left")
                    videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
                }
                else if UIDevice.current.orientation == .landscapeRight {
                    print("Landscape right")
                    videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
                }
                
                
                
                previewView.layer.addSublayer(videoPreviewLayer!)
                session!.startRunning()
                
                
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
    
    
    func initializeShadow() {
        
        let shadowRadius = self.logoText.layer.frame.maxY + 8
        
        if UIDevice.current.orientation.isLandscape {
            self.landscapeShadow = EdgeShadowLayer(forView: view, edge: .Top, shadowRadius: shadowRadius, toColor: .clear, fromColor: .black)
            self.view.layer.insertSublayer(landscapeShadow!, at: 1)
        }
        else {
            self.portraitShadow = EdgeShadowLayer(forView: view, edge: .Top, shadowRadius: shadowRadius, toColor: .clear, fromColor: .black)
            self.view.layer.insertSublayer(portraitShadow!, at: 1)
            let otherShadow = EdgeShadowLayer(forView: view, edge: .Bottom, shadowRadius: self.locationOutlet.frame.minY - 8, toColor: .clear, fromColor: .black)
            self.view.layer.insertSublayer(otherShadow, at: 1)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        let when = DispatchTime.now() + 0.15 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            self.viewDidAppear(false)
            
            if UIDevice.current.orientation.isLandscape {
                if (self.view.layer.sublayers?.contains(self.portraitShadow!))! {
                    self.portraitShadow?.removeFromSuperlayer()
                }
                let shadowRadius = self.logoText.layer.frame.maxY + 8
                self.landscapeShadow = EdgeShadowLayer(forView: self.view, edge: .Top, shadowRadius: shadowRadius, toColor: .clear, fromColor: .black)
                self.view.layer.insertSublayer(self.landscapeShadow!, at: 1)
                
            }
            else {
                if (self.view.layer.sublayers?.contains(self.landscapeShadow!))! {
                    self.landscapeShadow?.removeFromSuperlayer()
                }
                let shadowRadius = self.logoText.layer.frame.maxY + 8
                self.portraitShadow = EdgeShadowLayer(forView: self.view, edge: .Top, shadowRadius: shadowRadius, toColor: .clear, fromColor: .black)
                self.view.layer.insertSublayer(self.portraitShadow!, at: 1)
                
                
            }
            
            if UIDevice.current.orientation == .portrait {
                print("Portrait")
                self.videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            }
            else if UIDevice.current.orientation == .landscapeLeft {
                print("Landscape left")
                self.videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
            }
            else if UIDevice.current.orientation == .landscapeRight {
                print("Landscape right")
                self.videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
            }
            

        }
        
    }
    
    
    func setupLocation() {
        
        Locator.requestAuthorizationIfNeeded(.always)
        
        Locator.subscribePosition(accuracy: .room,
                                    onUpdate: { location in

                                        let lat = location.coordinate.latitude.truncate(places: 6)
                                        var latString: String
                                        let long = location.coordinate.longitude.truncate(places: 6)
                                        var longString: String
                                        
                                        if lat > 0 {
                                            latString = "\(lat)°N"
                                        } else {
                                            latString = "\(lat)°S"
                                        }
                                        
                                        if long > 0 {
                                            longString = "\(long)°E"
                                        }
                                        else {
                                            longString = "\(long)°W"
                                        }
                                        
                                        
                                        self.locationOutlet.text = latString + " , " + longString
                                    
                                    },
                                    onFail: { (error, last) in
                                    
                                        print(error)
                                    }
        )
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoPreviewLayer!.frame = previewView.bounds
        
    }
    
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error == nil {
            let imageData = photo.fileDataRepresentation()
            print("Picture Taken!")
            
            let image = UIImage(data: imageData!)
        }
        
        session?.stopRunning()
        
        
    }
    
    

    
    
    
}


