//
//  ViewController.swift
//  SwiftyOnboardExample
//
//  Created by Jay on 3/27/17.
//  Copyright © 2017 Juan Pablo Fernandez. All rights reserved.
//

import UIKit
import SwiftyOnboard

class TutorialContainerVC: UIViewController, SwiftyOnboardDelegate, SwiftyOnboardDataSource {
    
    var window: UIWindow?
    
    var swiftyOnboard: SwiftyOnboard!
    let colors:[UIColor] = [#colorLiteral(red: 0.9980840087, green: 0.3723873496, blue: 0.4952875376, alpha: 1),#colorLiteral(red: 0.2666860223, green: 0.5116362572, blue: 1, alpha: 1),#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)]
    var pageCount: Int = 9
    var titleArray: [String] = ["Welcome!",
                                "Erosion",
                                "Plant Growth",
                                "City Growth",
                                "Capture Anything",
                                "Crowd Sourcing",
                                "Social",
                                "Navigation",
                                "Let's Begin!"
    ]
    
    var subTitleArray: [String] = ["reCapp is the best place to come together and crowd-source our efforts to document the changes in our world.",
                                   "With reCapp you can monitor erosion.",
                                   "With reCapp you can monitor plant growth.",
                                   "With reCapp you can document city growth!",
                                   "With reCapp you can document anything you want! (If you can get there)",
                                   "Using reCapp for crowd sourcing lets us study our world better than ever before.",
                                   "Follow your fellow researchers and compete against others to contribute the most!",
                                   "See where people are contributing and get turn by turn navigation directions to any challenge you want!",
                                   "see how our world is changing right before our eyes."
    ]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    var gradiant: CAGradientLayer = {
        //Gradiant for the background view
        let blue = UIColor(red: 69/255, green: 127/255, blue: 202/255, alpha: 1.0).cgColor
        let purple = UIColor(red: 166/255, green: 172/255, blue: 236/255, alpha: 1.0).cgColor
        let gradiant = CAGradientLayer()
        gradiant.colors = [purple, blue]
        gradiant.startPoint = CGPoint(x: 0.5, y: 0.18)
        return gradiant
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageCount = titleArray.count
        gradient()
        UIApplication.shared.statusBarStyle = .lightContent
        
        swiftyOnboard = SwiftyOnboard(frame: view.frame, style: .light)
        view.addSubview(swiftyOnboard)
        swiftyOnboard.dataSource = self
        swiftyOnboard.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    
    func gradient() {
        //Add the gradiant to the view:
        self.gradiant.frame = view.bounds
        view.layer.addSublayer(gradiant)
    }
    
    @objc func handleSkip() {
        swiftyOnboard?.goToPage(index: pageCount - 1, animated: true)
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        if index == pageCount - 1 {
            
            let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
            if launchedBefore  {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                print("Sending to Sign In")
                UserDefaults.standard.set(true, forKey: "launchedBefore")
//                let signInStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
//
//                self.window?.rootViewController = signInStoryboard.instantiateInitialViewController()
                
                let storyboard = UIStoryboard(name: "SignIn", bundle: nil)
                let controller = storyboard.instantiateInitialViewController()
                self.present(controller!, animated: true, completion: nil)
            }
            
            
            
        }
        swiftyOnboard?.goToPage(index: index + 1, animated: true)
    }
    
    
    
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        //Number of pages in the onboarding:
        return pageCount
    }
    
    
    func swiftyOnboardViewForBackground(_ swiftyOnboard: SwiftyOnboard) -> UIView? {
        var gradientLayer: CAGradientLayer!
        
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = swiftyOnboard.frame
        
        let bottomColor = UIColor(displayP3Red: 99/255, green: 207/255, blue: 155/255, alpha: 1).cgColor
        let topColor = UIColor(displayP3Red: 9/255, green: 85/255, blue: 95/255, alpha: 1).cgColor
        
        gradientLayer.colors = [topColor, bottomColor]
        
        let view = UIView(frame: swiftyOnboard.frame)
        view.layer.insertSublayer(gradientLayer, at: 0)
        return view
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = CustomPage.instanceFromNib() as? CustomPage
        
        //Set the image on the page:
        view?.image.image = UIImage(named: "onboard\(index)")
        view?.image.hero.id = "logoID"
        
        //Set the text in the page:
        view?.titleLabel.text = titleArray[index]
        view?.subTitleLabel.text = subTitleArray[index]
        
        view?.image.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        view?.image.transform = .identity
            }, completion: nil)
        
        
        //Return the page for the given index:
        return view
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {

        let overlay = CustomOverlay.instanceFromNib() as? CustomOverlay
        overlay?.skip.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay?.buttonContinue.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        overlay?.contentControl.numberOfPages = pageCount
        overlay?.image.image = #imageLiteral(resourceName: "Logo Text Wide")
        
        //Return the overlay view:
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        
        let overlay = overlay as? CustomOverlay
        let currentPage = round(position)
        overlay?.contentControl.currentPage = Int(currentPage)
        overlay?.buttonContinue.tag = Int(position)
        
        let doublePageCount = Double(pageCount - 1)
        
        if currentPage != doublePageCount {
            overlay?.buttonContinue.setTitle("Continue", for: .normal)
            overlay?.skip.setTitle("Skip", for: .normal)
            overlay?.skip.isHidden = false
        } else {
            overlay?.buttonContinue.setTitle("Get Started!", for: .normal)
            overlay?.skip.isHidden = true
        }
    }
    
    func swiftyOnboard(_ swiftyOnboard: SwiftyOnboard, tapped index: Int) {
        
        let view = CustomPage.instanceFromNib() as? CustomPage
        
        print("tapped")

        UIView.animate(withDuration: 2.0, animations: {
                view?.image.alpha = 0.2
                view?.image.transform = CGAffineTransform(scaleX: 200, y: 200)
        })

        
    }
}



