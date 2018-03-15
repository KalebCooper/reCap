//
//  LayerView.swift
//  Exported from Kite Compositor for Mac 1.8
//
//  Created on 2/24/18, 11:45 PM.
//


import UIKit

class LayerView: UIView
{

    // MARK: - Initialization

    init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 375, height: 812))
        self.setupLayers()
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.setupLayers()
    }

    // MARK: - Setup Layers

    private func setupLayers()
    {
        // Images
        //
        guard let houseEpsImage = UIImage(named: "099-house-23") else {
            fatalError("Warning: Unable to locate image named '099-house-23.eps'")
        }

        guard let houseEpsImage1 = UIImage(named: "015-house-36") else {
            fatalError("Warning: Unable to locate image named '015-house-36.eps'")
        }

        guard let sunEpsImage = UIImage(named: "050-sun") else {
            fatalError("Warning: Unable to locate image named '050-sun.eps'")
        }

        guard let schoolEpsImage = UIImage(named: "006-school-9") else {
            fatalError("Warning: Unable to locate image named '006-school-9.eps'")
        }

        guard let millEpsImage = UIImage(named: "190-mill") else {
            fatalError("Warning: Unable to locate image named '190-mill.eps'")
        }

        guard let houseEpsImage2 = UIImage(named: "074-house-28") else {
            fatalError("Warning: Unable to locate image named '074-house-28.eps'")
        }

        guard let flowerEpsImage = UIImage(named: "007-flower-3") else {
            fatalError("Warning: Unable to locate image named '007-flower-3.eps'")
        }

        guard let plantEpsImage = UIImage(named: "040-plant") else {
            fatalError("Warning: Unable to locate image named '040-plant.eps'")
        }

        guard let grassEpsImage = UIImage(named: "015-grass") else {
            fatalError("Warning: Unable to locate image named '015-grass.eps'")
        }

        guard let flowerEpsImage1 = UIImage(named: "008-flower-2") else {
            fatalError("Warning: Unable to locate image named '008-flower-2.eps'")
        }

        // Colors
        //
        let backgroundColor = UIColor(red: 0.64, green: 0.553, blue: 0.0832, alpha: 0)
        let borderColor = UIColor(red: 0.84, green: 0.725812, blue: 0.1092, alpha: 0)

        // Paths
        //
        let positionAnimationPath = CGMutablePath()
        positionAnimationPath.move(to: CGPoint(x: 420, y: 235))
        positionAnimationPath.addLine(to: CGPoint(x: 389, y: 178))
        positionAnimationPath.addLine(to: CGPoint(x: 343, y: 126))
        positionAnimationPath.addLine(to: CGPoint(x: 289, y: 91))
        positionAnimationPath.addLine(to: CGPoint(x: 225, y: 62))
        positionAnimationPath.addLine(to: CGPoint(x: 159, y: 56))
        positionAnimationPath.addLine(to: CGPoint(x: 107, y: 82))
        positionAnimationPath.addLine(to: CGPoint(x: 74, y: 120))

        // Layer
        //
        let layerLayer = CALayer()
        layerLayer.name = "Layer"
        layerLayer.bounds = CGRect(x: 0, y: 0, width: 375, height: 311)
        layerLayer.position = CGPoint(x: -2, y: 426)
        layerLayer.anchorPoint = CGPoint(x: 0, y: 0)
        layerLayer.contentsGravity = kCAGravityCenter
        layerLayer.backgroundColor = backgroundColor.cgColor
        layerLayer.borderColor = borderColor.cgColor
        layerLayer.shadowOffset = CGSize(width: 0, height: 1)
        layerLayer.fillMode = kCAFillModeForwards

            // Layer Sublayers
            //

            // 099-house-23
            //
            let houseLayer = CALayer()
            houseLayer.name = "099-house-23"
            houseLayer.bounds = CGRect(x: 0, y: 0, width: 58, height: 56)
            houseLayer.position = CGPoint(x: 257, y: 229)
            houseLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
            houseLayer.contents = houseEpsImage.cgImage
            houseLayer.contentsGravity = kCAGravityResizeAspect
            houseLayer.contentsScale = 2
            houseLayer.shadowOffset = CGSize(width: 0, height: 1)
            houseLayer.fillMode = kCAFillModeForwards

                // 099-house-23 Animations
                //

                // transform.scale.y
                //
                let transformScaleYAnimation = CASpringAnimation()
                transformScaleYAnimation.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.176075
                transformScaleYAnimation.duration = 0.99321
                transformScaleYAnimation.fillMode = kCAFillModeForwards
                transformScaleYAnimation.isRemovedOnCompletion = false
                transformScaleYAnimation.keyPath = "transform.scale.y"
                transformScaleYAnimation.toValue = 1
                transformScaleYAnimation.fromValue = 0
                transformScaleYAnimation.stiffness = 200
                transformScaleYAnimation.damping = 10
                transformScaleYAnimation.mass = 0.7
                transformScaleYAnimation.initialVelocity = 4

                houseLayer.add(transformScaleYAnimation, forKey: "transformScaleYAnimation")

                // hidden
                //
                let hiddenAnimation = CABasicAnimation()
                hiddenAnimation.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + -0.018311
                hiddenAnimation.duration = 0.194386
                hiddenAnimation.fillMode = kCAFillModeForwards
                hiddenAnimation.isRemovedOnCompletion = false
                hiddenAnimation.keyPath = "hidden"
                hiddenAnimation.toValue = 1
                hiddenAnimation.fromValue = 1

                houseLayer.add(hiddenAnimation, forKey: "hiddenAnimation")

                // hidden
                //
                let hiddenAnimation1 = CABasicAnimation()
                hiddenAnimation1.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.176075
                hiddenAnimation1.duration = 1.275772
                hiddenAnimation1.fillMode = kCAFillModeForwards
                hiddenAnimation1.isRemovedOnCompletion = false
                hiddenAnimation1.keyPath = "hidden"
                hiddenAnimation1.toValue = 0
                hiddenAnimation1.fromValue = 0

                houseLayer.add(hiddenAnimation1, forKey: "hiddenAnimation1")

            layerLayer.addSublayer(houseLayer)

            // 015-house-36
            //
            let houseLayer1 = CALayer()
            houseLayer1.name = "015-house-36"
            houseLayer1.bounds = CGRect(x: 0, y: 0, width: 49, height: 49)
            houseLayer1.position = CGPoint(x: 116.5, y: 229)
            houseLayer1.anchorPoint = CGPoint(x: 0.5, y: 1)
            houseLayer1.contents = houseEpsImage1.cgImage
            houseLayer1.contentsGravity = kCAGravityResizeAspect
            houseLayer1.contentsScale = 2
            houseLayer1.shadowOffset = CGSize(width: 0, height: 1)
            houseLayer1.fillMode = kCAFillModeForwards

                // 015-house-36 Animations
                //

                // transform.scale.y
                //
                let transformScaleYAnimation1 = CASpringAnimation()
                transformScaleYAnimation1.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.000001
                transformScaleYAnimation1.duration = 0.99321
                transformScaleYAnimation1.fillMode = kCAFillModeForwards
                transformScaleYAnimation1.isRemovedOnCompletion = false
                transformScaleYAnimation1.keyPath = "transform.scale.y"
                transformScaleYAnimation1.toValue = 1
                transformScaleYAnimation1.fromValue = 0
                transformScaleYAnimation1.stiffness = 200
                transformScaleYAnimation1.damping = 10
                transformScaleYAnimation1.mass = 0.7
                transformScaleYAnimation1.initialVelocity = 4

                houseLayer1.add(transformScaleYAnimation1, forKey: "transformScaleYAnimation1")

            layerLayer.addSublayer(houseLayer1)

            // 050-sun
            //
            let sunLayer = CALayer()
            sunLayer.name = "050-sun"
            sunLayer.bounds = CGRect(x: 0, y: 0, width: 74, height: 74)
            sunLayer.position = CGPoint(x: 439.78, y: 173.046204)
            sunLayer.anchorPoint = CGPoint(x: 0.47, y: 0.5)
            sunLayer.contents = sunEpsImage.cgImage
            sunLayer.contentsGravity = kCAGravityResizeAspect
            sunLayer.contentsScale = 2
            sunLayer.shadowOffset = CGSize(width: 0, height: 1)
            sunLayer.fillMode = kCAFillModeForwards

                // 050-sun Animations
                //

                // position
                //
                let positionAnimation = CAKeyframeAnimation()
                positionAnimation.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.000001
                positionAnimation.duration = 4.589781
                positionAnimation.fillMode = kCAFillModeForwards
                positionAnimation.isRemovedOnCompletion = false
                positionAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                positionAnimation.keyPath = "position"
                positionAnimation.values = [ CGPoint(x: 0, y: 0), CGPoint(x: 400, y: 400) ]
                positionAnimation.path = positionAnimationPath
                positionAnimation.calculationMode = kCAAnimationLinear

                sunLayer.add(positionAnimation, forKey: "positionAnimation")

                // transform.scale.x
                //
                let transformScaleXAnimation = CASpringAnimation()
                transformScaleXAnimation.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 4.589782
                transformScaleXAnimation.duration = 0.99321
                transformScaleXAnimation.fillMode = kCAFillModeForwards
                transformScaleXAnimation.isRemovedOnCompletion = false
                transformScaleXAnimation.keyPath = "transform.scale.x"
                transformScaleXAnimation.toValue = 1.15
                transformScaleXAnimation.fromValue = 1
                transformScaleXAnimation.stiffness = 200
                transformScaleXAnimation.damping = 10
                transformScaleXAnimation.mass = 0.7
                transformScaleXAnimation.initialVelocity = 4

                sunLayer.add(transformScaleXAnimation, forKey: "transformScaleXAnimation")

                // transform.scale.y
                //
                let transformScaleYAnimation2 = CASpringAnimation()
                transformScaleYAnimation2.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 4.589782
                transformScaleYAnimation2.duration = 0.99321
                transformScaleYAnimation2.fillMode = kCAFillModeForwards
                transformScaleYAnimation2.isRemovedOnCompletion = false
                transformScaleYAnimation2.keyPath = "transform.scale.y"
                transformScaleYAnimation2.toValue = 1.15
                transformScaleYAnimation2.fromValue = 1
                transformScaleYAnimation2.stiffness = 200
                transformScaleYAnimation2.damping = 10
                transformScaleYAnimation2.mass = 0.7
                transformScaleYAnimation2.initialVelocity = 4

                sunLayer.add(transformScaleYAnimation2, forKey: "transformScaleYAnimation2")

                // transform.scale.z
                //
                let transformScaleZAnimation = CASpringAnimation()
                transformScaleZAnimation.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 4.589782
                transformScaleZAnimation.duration = 0.99321
                transformScaleZAnimation.fillMode = kCAFillModeForwards
                transformScaleZAnimation.isRemovedOnCompletion = false
                transformScaleZAnimation.keyPath = "transform.scale.z"
                transformScaleZAnimation.toValue = 1.15
                transformScaleZAnimation.fromValue = 1
                transformScaleZAnimation.stiffness = 200
                transformScaleZAnimation.damping = 10
                transformScaleZAnimation.mass = 0.7
                transformScaleZAnimation.initialVelocity = 4

                sunLayer.add(transformScaleZAnimation, forKey: "transformScaleZAnimation")

                // transform.rotation.z
                //
                let transformRotationZAnimation = CASpringAnimation()
                transformRotationZAnimation.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 4.589782
                transformRotationZAnimation.duration = 1.017514
                transformRotationZAnimation.fillMode = kCAFillModeForwards
                transformRotationZAnimation.isRemovedOnCompletion = false
                transformRotationZAnimation.keyPath = "transform.rotation.z"
                transformRotationZAnimation.toValue = 3
                transformRotationZAnimation.fromValue = 1
                transformRotationZAnimation.stiffness = 200
                transformRotationZAnimation.damping = 10
                transformRotationZAnimation.mass = 0.7
                transformRotationZAnimation.initialVelocity = 0.5

                sunLayer.add(transformRotationZAnimation, forKey: "transformRotationZAnimation")

            layerLayer.addSublayer(sunLayer)

            // 006-school-9
            //
            let schoolLayer = CALayer()
            schoolLayer.name = "006-school-9"
            schoolLayer.bounds = CGRect(x: 0, y: 0, width: 114, height: 134)
            schoolLayer.position = CGPoint(x: 188, y: 238)
            schoolLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
            schoolLayer.contents = schoolEpsImage.cgImage
            schoolLayer.contentsGravity = kCAGravityResizeAspect
            schoolLayer.contentsScale = 2
            schoolLayer.shadowOffset = CGSize(width: 0, height: 1)
            schoolLayer.fillMode = kCAFillModeForwards

                // 006-school-9 Animations
                //

                // transform.scale.y
                //
                let transformScaleYAnimation3 = CASpringAnimation()
                transformScaleYAnimation3.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.383186
                transformScaleYAnimation3.duration = 0.99321
                transformScaleYAnimation3.fillMode = kCAFillModeForwards
                transformScaleYAnimation3.isRemovedOnCompletion = false
                transformScaleYAnimation3.keyPath = "transform.scale.y"
                transformScaleYAnimation3.toValue = 1
                transformScaleYAnimation3.fromValue = 0
                transformScaleYAnimation3.stiffness = 200
                transformScaleYAnimation3.damping = 10
                transformScaleYAnimation3.mass = 0.7
                transformScaleYAnimation3.initialVelocity = 4

                schoolLayer.add(transformScaleYAnimation3, forKey: "transformScaleYAnimation3")

                // hidden
                //
                let hiddenAnimation2 = CABasicAnimation()
                hiddenAnimation2.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + -0.017812
                hiddenAnimation2.duration = 0.400998
                hiddenAnimation2.fillMode = kCAFillModeForwards
                hiddenAnimation2.isRemovedOnCompletion = false
                hiddenAnimation2.keyPath = "hidden"
                hiddenAnimation2.toValue = 1
                hiddenAnimation2.fromValue = 1

                schoolLayer.add(hiddenAnimation2, forKey: "hiddenAnimation2")

                // hidden
                //
                let hiddenAnimation3 = CABasicAnimation()
                hiddenAnimation3.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.383186
                hiddenAnimation3.duration = 0.99321
                hiddenAnimation3.fillMode = kCAFillModeForwards
                hiddenAnimation3.isRemovedOnCompletion = false
                hiddenAnimation3.keyPath = "hidden"
                hiddenAnimation3.toValue = 0
                hiddenAnimation3.fromValue = 0

                schoolLayer.add(hiddenAnimation3, forKey: "hiddenAnimation3")

            layerLayer.addSublayer(schoolLayer)

            // 190-mill
            //
            let millLayer = CALayer()
            millLayer.name = "190-mill"
            millLayer.bounds = CGRect(x: 0, y: 0, width: 134, height: 164)
            millLayer.position = CGPoint(x: 295, y: 252)
            millLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
            millLayer.contents = millEpsImage.cgImage
            millLayer.contentsGravity = kCAGravityResizeAspect
            millLayer.contentsScale = 2
            millLayer.shadowOffset = CGSize(width: 0, height: 1)
            millLayer.fillMode = kCAFillModeForwards

                // 190-mill Animations
                //

                // transform.scale.y
                //
                let transformScaleYAnimation4 = CASpringAnimation()
                transformScaleYAnimation4.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 1.139161
                transformScaleYAnimation4.duration = 0.99321
                transformScaleYAnimation4.fillMode = kCAFillModeForwards
                transformScaleYAnimation4.isRemovedOnCompletion = false
                transformScaleYAnimation4.keyPath = "transform.scale.y"
                transformScaleYAnimation4.toValue = 1
                transformScaleYAnimation4.fromValue = 0
                transformScaleYAnimation4.stiffness = 200
                transformScaleYAnimation4.damping = 10
                transformScaleYAnimation4.mass = 0.7
                transformScaleYAnimation4.initialVelocity = 4

                millLayer.add(transformScaleYAnimation4, forKey: "transformScaleYAnimation4")

                // hidden
                //
                let hiddenAnimation4 = CABasicAnimation()
                hiddenAnimation4.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + -0.017603
                hiddenAnimation4.duration = 1.156765
                hiddenAnimation4.fillMode = kCAFillModeForwards
                hiddenAnimation4.isRemovedOnCompletion = false
                hiddenAnimation4.keyPath = "hidden"
                hiddenAnimation4.toValue = 1
                hiddenAnimation4.fromValue = 1

                millLayer.add(hiddenAnimation4, forKey: "hiddenAnimation4")

                // hidden
                //
                let hiddenAnimation5 = CABasicAnimation()
                hiddenAnimation5.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 1.139161
                hiddenAnimation5.duration = 0.99321
                hiddenAnimation5.fillMode = kCAFillModeForwards
                hiddenAnimation5.isRemovedOnCompletion = false
                hiddenAnimation5.keyPath = "hidden"
                hiddenAnimation5.toValue = 0
                hiddenAnimation5.fromValue = 0

                millLayer.add(hiddenAnimation5, forKey: "hiddenAnimation5")

            layerLayer.addSublayer(millLayer)

            // 074-house-28
            //
            let houseLayer2 = CALayer()
            houseLayer2.name = "074-house-28"
            houseLayer2.bounds = CGRect(x: 0, y: 0, width: 68, height: 74)
            houseLayer2.position = CGPoint(x: 69, y: 248)
            houseLayer2.anchorPoint = CGPoint(x: 0.5, y: 1)
            houseLayer2.contents = houseEpsImage2.cgImage
            houseLayer2.contentsGravity = kCAGravityResizeAspect
            houseLayer2.contentsScale = 2
            houseLayer2.shadowOffset = CGSize(width: 0, height: 1)
            houseLayer2.fillMode = kCAFillModeForwards

                // 074-house-28 Animations
                //

                // transform.scale.y
                //
                let transformScaleYAnimation5 = CASpringAnimation()
                transformScaleYAnimation5.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.725924
                transformScaleYAnimation5.duration = 0.99321
                transformScaleYAnimation5.fillMode = kCAFillModeForwards
                transformScaleYAnimation5.isRemovedOnCompletion = false
                transformScaleYAnimation5.keyPath = "transform.scale.y"
                transformScaleYAnimation5.toValue = 1
                transformScaleYAnimation5.fromValue = 0
                transformScaleYAnimation5.stiffness = 200
                transformScaleYAnimation5.damping = 10
                transformScaleYAnimation5.mass = 0.7
                transformScaleYAnimation5.initialVelocity = 4

                houseLayer2.add(transformScaleYAnimation5, forKey: "transformScaleYAnimation5")

                // hidden
                //
                let hiddenAnimation6 = CABasicAnimation()
                hiddenAnimation6.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + -0.015798
                hiddenAnimation6.duration = 0.741723
                hiddenAnimation6.fillMode = kCAFillModeForwards
                hiddenAnimation6.isRemovedOnCompletion = false
                hiddenAnimation6.keyPath = "hidden"
                hiddenAnimation6.toValue = 1
                hiddenAnimation6.fromValue = 1

                houseLayer2.add(hiddenAnimation6, forKey: "hiddenAnimation6")

                // hidden
                //
                let hiddenAnimation7 = CABasicAnimation()
                hiddenAnimation7.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.725924
                hiddenAnimation7.duration = 0.725923
                hiddenAnimation7.fillMode = kCAFillModeForwards
                hiddenAnimation7.isRemovedOnCompletion = false
                hiddenAnimation7.keyPath = "hidden"
                hiddenAnimation7.toValue = 0
                hiddenAnimation7.fromValue = 0

                houseLayer2.add(hiddenAnimation7, forKey: "hiddenAnimation7")

            layerLayer.addSublayer(houseLayer2)

            // 007-flower-3
            //
            let flowerLayer = CALayer()
            flowerLayer.name = "007-flower-3"
            flowerLayer.bounds = CGRect(x: 0, y: 0, width: 6, height: 17)
            flowerLayer.position = CGPoint(x: 71, y: 251)
            flowerLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
            flowerLayer.contents = flowerEpsImage.cgImage
            flowerLayer.contentsGravity = kCAGravityResizeAspect
            flowerLayer.contentsScale = 2
            flowerLayer.shadowOffset = CGSize(width: 0, height: 1)
            flowerLayer.fillMode = kCAFillModeForwards

                // 007-flower-3 Animations
                //

                // transform.scale.y
                //
                let transformScaleYAnimation6 = CASpringAnimation()
                transformScaleYAnimation6.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 1.301681
                transformScaleYAnimation6.duration = 0.99321
                transformScaleYAnimation6.fillMode = kCAFillModeForwards
                transformScaleYAnimation6.isRemovedOnCompletion = false
                transformScaleYAnimation6.keyPath = "transform.scale.y"
                transformScaleYAnimation6.toValue = 1
                transformScaleYAnimation6.fromValue = 0
                transformScaleYAnimation6.stiffness = 200
                transformScaleYAnimation6.damping = 10
                transformScaleYAnimation6.mass = 0.7
                transformScaleYAnimation6.initialVelocity = 4

                flowerLayer.add(transformScaleYAnimation6, forKey: "transformScaleYAnimation6")

                // hidden
                //
                let hiddenAnimation8 = CABasicAnimation()
                hiddenAnimation8.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + -0.054349
                hiddenAnimation8.duration = 1.35603
                hiddenAnimation8.fillMode = kCAFillModeForwards
                hiddenAnimation8.isRemovedOnCompletion = false
                hiddenAnimation8.keyPath = "hidden"
                hiddenAnimation8.toValue = 1
                hiddenAnimation8.fromValue = 1

                flowerLayer.add(hiddenAnimation8, forKey: "hiddenAnimation8")

                // hidden
                //
                let hiddenAnimation9 = CABasicAnimation()
                hiddenAnimation9.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 1.301681
                hiddenAnimation9.duration = 0.725923
                hiddenAnimation9.fillMode = kCAFillModeForwards
                hiddenAnimation9.isRemovedOnCompletion = false
                hiddenAnimation9.keyPath = "hidden"
                hiddenAnimation9.toValue = 0
                hiddenAnimation9.fromValue = 0

                flowerLayer.add(hiddenAnimation9, forKey: "hiddenAnimation9")

            layerLayer.addSublayer(flowerLayer)

            // 040-plant
            //
            let plantLayer = CALayer()
            plantLayer.name = "040-plant"
            plantLayer.bounds = CGRect(x: 0, y: 0, width: 34, height: 32)
            plantLayer.position = CGPoint(x: 187, y: 301)
            plantLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
            plantLayer.contents = plantEpsImage.cgImage
            plantLayer.contentsGravity = kCAGravityResizeAspect
            plantLayer.contentsScale = 2
            plantLayer.shadowOffset = CGSize(width: 0, height: 1)
            plantLayer.fillMode = kCAFillModeForwards

                // 040-plant Animations
                //

                // transform.scale.y
                //
                let transformScaleYAnimation7 = CASpringAnimation()
                transformScaleYAnimation7.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 2.233188
                transformScaleYAnimation7.duration = 0.99321
                transformScaleYAnimation7.fillMode = kCAFillModeForwards
                transformScaleYAnimation7.isRemovedOnCompletion = false
                transformScaleYAnimation7.keyPath = "transform.scale.y"
                transformScaleYAnimation7.toValue = 1
                transformScaleYAnimation7.fromValue = 0
                transformScaleYAnimation7.stiffness = 200
                transformScaleYAnimation7.damping = 10
                transformScaleYAnimation7.mass = 0.7
                transformScaleYAnimation7.initialVelocity = 4

                plantLayer.add(transformScaleYAnimation7, forKey: "transformScaleYAnimation7")

                // hidden
                //
                let hiddenAnimation10 = CABasicAnimation()
                hiddenAnimation10.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + -0.015646
                hiddenAnimation10.duration = 2.248833
                hiddenAnimation10.fillMode = kCAFillModeForwards
                hiddenAnimation10.isRemovedOnCompletion = false
                hiddenAnimation10.keyPath = "hidden"
                hiddenAnimation10.toValue = 1
                hiddenAnimation10.fromValue = 1

                plantLayer.add(hiddenAnimation10, forKey: "hiddenAnimation10")

                // hidden
                //
                let hiddenAnimation11 = CABasicAnimation()
                hiddenAnimation11.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 2.233188
                hiddenAnimation11.duration = 0.99321
                hiddenAnimation11.fillMode = kCAFillModeForwards
                hiddenAnimation11.isRemovedOnCompletion = false
                hiddenAnimation11.keyPath = "hidden"
                hiddenAnimation11.toValue = 0
                hiddenAnimation11.fromValue = 0

                plantLayer.add(hiddenAnimation11, forKey: "hiddenAnimation11")

            layerLayer.addSublayer(plantLayer)

            // 015-grass
            //
            let grassLayer = CALayer()
            grassLayer.name = "015-grass"
            grassLayer.bounds = CGRect(x: 0, y: 0, width: 32, height: 27)
            grassLayer.position = CGPoint(x: 223, y: 246)
            grassLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
            grassLayer.contents = grassEpsImage.cgImage
            grassLayer.contentsGravity = kCAGravityResizeAspect
            grassLayer.contentsScale = 2
            grassLayer.shadowOffset = CGSize(width: 0, height: 1)
            grassLayer.fillMode = kCAFillModeForwards

                // 015-grass Animations
                //

                // transform.scale.y
                //
                let transformScaleYAnimation8 = CASpringAnimation()
                transformScaleYAnimation8.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.769071
                transformScaleYAnimation8.duration = 0.99321
                transformScaleYAnimation8.fillMode = kCAFillModeForwards
                transformScaleYAnimation8.isRemovedOnCompletion = false
                transformScaleYAnimation8.keyPath = "transform.scale.y"
                transformScaleYAnimation8.toValue = 1
                transformScaleYAnimation8.fromValue = 0
                transformScaleYAnimation8.stiffness = 200
                transformScaleYAnimation8.damping = 10
                transformScaleYAnimation8.mass = 0.7
                transformScaleYAnimation8.initialVelocity = 4

                grassLayer.add(transformScaleYAnimation8, forKey: "transformScaleYAnimation8")

                // hidden
                //
                let hiddenAnimation12 = CABasicAnimation()
                hiddenAnimation12.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + -0.022794
                hiddenAnimation12.duration = 0.791865
                hiddenAnimation12.fillMode = kCAFillModeForwards
                hiddenAnimation12.isRemovedOnCompletion = false
                hiddenAnimation12.keyPath = "hidden"
                hiddenAnimation12.toValue = 1
                hiddenAnimation12.fromValue = 1

                grassLayer.add(hiddenAnimation12, forKey: "hiddenAnimation12")

                // hidden
                //
                let hiddenAnimation13 = CABasicAnimation()
                hiddenAnimation13.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.769071
                hiddenAnimation13.duration = 0.99321
                hiddenAnimation13.fillMode = kCAFillModeForwards
                hiddenAnimation13.isRemovedOnCompletion = false
                hiddenAnimation13.keyPath = "hidden"
                hiddenAnimation13.toValue = 0
                hiddenAnimation13.fromValue = 0

                grassLayer.add(hiddenAnimation13, forKey: "hiddenAnimation13")

            layerLayer.addSublayer(grassLayer)

            // 015-grass
            //
            let grassLayer1 = CALayer()
            grassLayer1.name = "015-grass"
            grassLayer1.bounds = CGRect(x: 0, y: 0, width: 25, height: 20)
            grassLayer1.position = CGPoint(x: 314, y: 255)
            grassLayer1.anchorPoint = CGPoint(x: 0.5, y: 1)
            grassLayer1.contents = grassEpsImage.cgImage
            grassLayer1.contentsGravity = kCAGravityResizeAspect
            grassLayer1.contentsScale = 2
            grassLayer1.shadowOffset = CGSize(width: 0, height: 1)
            grassLayer1.fillMode = kCAFillModeForwards

                // 015-grass Animations
                //

                // transform.scale.y
                //
                let transformScaleYAnimation9 = CASpringAnimation()
                transformScaleYAnimation9.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 1.635766
                transformScaleYAnimation9.duration = 0.99321
                transformScaleYAnimation9.fillMode = kCAFillModeForwards
                transformScaleYAnimation9.isRemovedOnCompletion = false
                transformScaleYAnimation9.keyPath = "transform.scale.y"
                transformScaleYAnimation9.toValue = 1
                transformScaleYAnimation9.fromValue = 0
                transformScaleYAnimation9.stiffness = 200
                transformScaleYAnimation9.damping = 10
                transformScaleYAnimation9.mass = 0.7
                transformScaleYAnimation9.initialVelocity = 4

                grassLayer1.add(transformScaleYAnimation9, forKey: "transformScaleYAnimation9")

                // hidden
                //
                let hiddenAnimation14 = CABasicAnimation()
                hiddenAnimation14.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + -0.053719
                hiddenAnimation14.duration = 1.689485
                hiddenAnimation14.fillMode = kCAFillModeForwards
                hiddenAnimation14.isRemovedOnCompletion = false
                hiddenAnimation14.keyPath = "hidden"
                hiddenAnimation14.toValue = 1
                hiddenAnimation14.fromValue = 1

                grassLayer1.add(hiddenAnimation14, forKey: "hiddenAnimation14")

                // hidden
                //
                let hiddenAnimation15 = CABasicAnimation()
                hiddenAnimation15.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 1.635766
                hiddenAnimation15.duration = 0.99321
                hiddenAnimation15.fillMode = kCAFillModeForwards
                hiddenAnimation15.isRemovedOnCompletion = false
                hiddenAnimation15.keyPath = "hidden"
                hiddenAnimation15.toValue = 0
                hiddenAnimation15.fromValue = 0

                grassLayer1.add(hiddenAnimation15, forKey: "hiddenAnimation15")

            layerLayer.addSublayer(grassLayer1)

            // 015-grass
            //
            let grassLayer2 = CALayer()
            grassLayer2.name = "015-grass"
            grassLayer2.bounds = CGRect(x: 0, y: 0, width: 32, height: 27)
            grassLayer2.position = CGPoint(x: 53, y: 251)
            grassLayer2.anchorPoint = CGPoint(x: 0.5, y: 1)
            grassLayer2.contents = grassEpsImage.cgImage
            grassLayer2.contentsGravity = kCAGravityResizeAspect
            grassLayer2.contentsScale = 2
            grassLayer2.shadowOffset = CGSize(width: 0, height: 1)
            grassLayer2.fillMode = kCAFillModeForwards

                // 015-grass Animations
                //

                // transform.scale.y
                //
                let transformScaleYAnimation10 = CASpringAnimation()
                transformScaleYAnimation10.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.821599
                transformScaleYAnimation10.duration = 0.99321
                transformScaleYAnimation10.fillMode = kCAFillModeForwards
                transformScaleYAnimation10.isRemovedOnCompletion = false
                transformScaleYAnimation10.keyPath = "transform.scale.y"
                transformScaleYAnimation10.toValue = 1
                transformScaleYAnimation10.fromValue = 0
                transformScaleYAnimation10.stiffness = 200
                transformScaleYAnimation10.damping = 10
                transformScaleYAnimation10.mass = 0.7
                transformScaleYAnimation10.initialVelocity = 4

                grassLayer2.add(transformScaleYAnimation10, forKey: "transformScaleYAnimation10")

                // hidden
                //
                let hiddenAnimation16 = CABasicAnimation()
                hiddenAnimation16.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + -0.023303
                hiddenAnimation16.duration = 0.844903
                hiddenAnimation16.fillMode = kCAFillModeForwards
                hiddenAnimation16.isRemovedOnCompletion = false
                hiddenAnimation16.keyPath = "hidden"
                hiddenAnimation16.toValue = 1
                hiddenAnimation16.fromValue = 1

                grassLayer2.add(hiddenAnimation16, forKey: "hiddenAnimation16")

                // hidden
                //
                let hiddenAnimation17 = CABasicAnimation()
                hiddenAnimation17.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.821599
                hiddenAnimation17.duration = 0.725923
                hiddenAnimation17.fillMode = kCAFillModeForwards
                hiddenAnimation17.isRemovedOnCompletion = false
                hiddenAnimation17.keyPath = "hidden"
                hiddenAnimation17.toValue = 0
                hiddenAnimation17.fromValue = 0

                grassLayer2.add(hiddenAnimation17, forKey: "hiddenAnimation17")

            layerLayer.addSublayer(grassLayer2)

            // 008-flower-2
            //
            let flowerLayer1 = CALayer()
            flowerLayer1.name = "008-flower-2"
            flowerLayer1.bounds = CGRect(x: 0, y: 0, width: 11, height: 18)
            flowerLayer1.position = CGPoint(x: 62.5, y: 256)
            flowerLayer1.anchorPoint = CGPoint(x: 0.5, y: 1)
            flowerLayer1.contents = flowerEpsImage1.cgImage
            flowerLayer1.contentsGravity = kCAGravityResizeAspect
            flowerLayer1.contentsScale = 2
            flowerLayer1.shadowOffset = CGSize(width: 0, height: 1)
            flowerLayer1.fillMode = kCAFillModeForwards

                // 008-flower-2 Animations
                //

                // transform.scale.y
                //
                let transformScaleYAnimation11 = CASpringAnimation()
                transformScaleYAnimation11.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.955242
                transformScaleYAnimation11.duration = 0.99321
                transformScaleYAnimation11.fillMode = kCAFillModeForwards
                transformScaleYAnimation11.isRemovedOnCompletion = false
                transformScaleYAnimation11.keyPath = "transform.scale.y"
                transformScaleYAnimation11.toValue = 1
                transformScaleYAnimation11.fromValue = 0
                transformScaleYAnimation11.stiffness = 200
                transformScaleYAnimation11.damping = 10
                transformScaleYAnimation11.mass = 0.7
                transformScaleYAnimation11.initialVelocity = 4

                flowerLayer1.add(transformScaleYAnimation11, forKey: "transformScaleYAnimation11")

                // hidden
                //
                let hiddenAnimation18 = CABasicAnimation()
                hiddenAnimation18.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + -0.063094
                hiddenAnimation18.duration = 1.018338
                hiddenAnimation18.fillMode = kCAFillModeForwards
                hiddenAnimation18.isRemovedOnCompletion = false
                hiddenAnimation18.keyPath = "hidden"
                hiddenAnimation18.toValue = 1
                hiddenAnimation18.fromValue = 1

                flowerLayer1.add(hiddenAnimation18, forKey: "hiddenAnimation18")

                // hidden
                //
                let hiddenAnimation19 = CABasicAnimation()
                hiddenAnimation19.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.955242
                hiddenAnimation19.duration = 0.725923
                hiddenAnimation19.fillMode = kCAFillModeForwards
                hiddenAnimation19.isRemovedOnCompletion = false
                hiddenAnimation19.keyPath = "hidden"
                hiddenAnimation19.toValue = 0
                hiddenAnimation19.fromValue = 0

                flowerLayer1.add(hiddenAnimation19, forKey: "hiddenAnimation19")

            layerLayer.addSublayer(flowerLayer1)

            // 007-flower-3
            //
            let flowerLayer2 = CALayer()
            flowerLayer2.name = "007-flower-3"
            flowerLayer2.bounds = CGRect(x: 0, y: 0, width: 6, height: 17)
            flowerLayer2.position = CGPoint(x: 219, y: 249)
            flowerLayer2.anchorPoint = CGPoint(x: 0.5, y: 1)
            flowerLayer2.contents = flowerEpsImage.cgImage
            flowerLayer2.contentsGravity = kCAGravityResizeAspect
            flowerLayer2.contentsScale = 2
            flowerLayer2.shadowOffset = CGSize(width: 0, height: 1)
            flowerLayer2.fillMode = kCAFillModeForwards

                // 007-flower-3 Animations
                //

                // transform.scale.y
                //
                let transformScaleYAnimation12 = CASpringAnimation()
                transformScaleYAnimation12.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.970776
                transformScaleYAnimation12.duration = 0.99321
                transformScaleYAnimation12.fillMode = kCAFillModeForwards
                transformScaleYAnimation12.isRemovedOnCompletion = false
                transformScaleYAnimation12.keyPath = "transform.scale.y"
                transformScaleYAnimation12.toValue = 1
                transformScaleYAnimation12.fromValue = 0
                transformScaleYAnimation12.stiffness = 200
                transformScaleYAnimation12.damping = 10
                transformScaleYAnimation12.mass = 0.7
                transformScaleYAnimation12.initialVelocity = 4

                flowerLayer2.add(transformScaleYAnimation12, forKey: "transformScaleYAnimation12")

                // hidden
                //
                let hiddenAnimation20 = CABasicAnimation()
                hiddenAnimation20.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + -0.086593
                hiddenAnimation20.duration = 1.057368
                hiddenAnimation20.fillMode = kCAFillModeForwards
                hiddenAnimation20.isRemovedOnCompletion = false
                hiddenAnimation20.keyPath = "hidden"
                hiddenAnimation20.toValue = 1
                hiddenAnimation20.fromValue = 1

                flowerLayer2.add(hiddenAnimation20, forKey: "hiddenAnimation20")

                // hidden
                //
                let hiddenAnimation21 = CABasicAnimation()
                hiddenAnimation21.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.970776
                hiddenAnimation21.duration = 0.99321
                hiddenAnimation21.fillMode = kCAFillModeForwards
                hiddenAnimation21.isRemovedOnCompletion = false
                hiddenAnimation21.keyPath = "hidden"
                hiddenAnimation21.toValue = 0
                hiddenAnimation21.fromValue = 0

                flowerLayer2.add(hiddenAnimation21, forKey: "hiddenAnimation21")

            layerLayer.addSublayer(flowerLayer2)

            // 007-flower-3
            //
            let flowerLayer3 = CALayer()
            flowerLayer3.name = "007-flower-3"
            flowerLayer3.bounds = CGRect(x: 0, y: 0, width: 6, height: 17)
            flowerLayer3.position = CGPoint(x: 282, y: 254)
            flowerLayer3.anchorPoint = CGPoint(x: 0.5, y: 1)
            flowerLayer3.contents = flowerEpsImage.cgImage
            flowerLayer3.contentsGravity = kCAGravityResizeAspect
            flowerLayer3.contentsScale = 2
            flowerLayer3.shadowOffset = CGSize(width: 0, height: 1)
            flowerLayer3.fillMode = kCAFillModeForwards

                // 007-flower-3 Animations
                //

                // transform.scale.y
                //
                let transformScaleYAnimation13 = CASpringAnimation()
                transformScaleYAnimation13.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 1.372
                transformScaleYAnimation13.duration = 0.99321
                transformScaleYAnimation13.fillMode = kCAFillModeForwards
                transformScaleYAnimation13.isRemovedOnCompletion = false
                transformScaleYAnimation13.keyPath = "transform.scale.y"
                transformScaleYAnimation13.toValue = 1
                transformScaleYAnimation13.fromValue = 0
                transformScaleYAnimation13.stiffness = 200
                transformScaleYAnimation13.damping = 10
                transformScaleYAnimation13.mass = 0.7
                transformScaleYAnimation13.initialVelocity = 4

                flowerLayer3.add(transformScaleYAnimation13, forKey: "transformScaleYAnimation13")

                // hidden
                //
                let hiddenAnimation22 = CABasicAnimation()
                hiddenAnimation22.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + -0.063606
                hiddenAnimation22.duration = 1.435606
                hiddenAnimation22.fillMode = kCAFillModeForwards
                hiddenAnimation22.isRemovedOnCompletion = false
                hiddenAnimation22.keyPath = "hidden"
                hiddenAnimation22.toValue = 1
                hiddenAnimation22.fromValue = 1

                flowerLayer3.add(hiddenAnimation22, forKey: "hiddenAnimation22")

                // hidden
                //
                let hiddenAnimation23 = CABasicAnimation()
                hiddenAnimation23.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 1.372
                hiddenAnimation23.duration = 0.99321
                hiddenAnimation23.fillMode = kCAFillModeForwards
                hiddenAnimation23.isRemovedOnCompletion = false
                hiddenAnimation23.keyPath = "hidden"
                hiddenAnimation23.toValue = 0
                hiddenAnimation23.fromValue = 0

                flowerLayer3.add(hiddenAnimation23, forKey: "hiddenAnimation23")

            layerLayer.addSublayer(flowerLayer3)

            // 007-flower-3
            //
            let flowerLayer4 = CALayer()
            flowerLayer4.name = "007-flower-3"
            flowerLayer4.bounds = CGRect(x: 0, y: 0, width: 4, height: 7)
            flowerLayer4.position = CGPoint(x: 126, y: 226)
            flowerLayer4.anchorPoint = CGPoint(x: 0.5, y: 1)
            flowerLayer4.contents = flowerEpsImage.cgImage
            flowerLayer4.contentsGravity = kCAGravityResizeAspect
            flowerLayer4.contentsScale = 2
            flowerLayer4.shadowOffset = CGSize(width: 0, height: 1)
            flowerLayer4.fillMode = kCAFillModeForwards

                // 007-flower-3 Animations
                //

                // transform.scale.y
                //
                let transformScaleYAnimation14 = CASpringAnimation()
                transformScaleYAnimation14.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.166567
                transformScaleYAnimation14.duration = 0.99321
                transformScaleYAnimation14.fillMode = kCAFillModeForwards
                transformScaleYAnimation14.isRemovedOnCompletion = false
                transformScaleYAnimation14.keyPath = "transform.scale.y"
                transformScaleYAnimation14.toValue = 1
                transformScaleYAnimation14.fromValue = 0
                transformScaleYAnimation14.stiffness = 200
                transformScaleYAnimation14.damping = 10
                transformScaleYAnimation14.mass = 0.7
                transformScaleYAnimation14.initialVelocity = 4

                flowerLayer4.add(transformScaleYAnimation14, forKey: "transformScaleYAnimation14")

                // hidden
                //
                let hiddenAnimation24 = CABasicAnimation()
                hiddenAnimation24.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + -0.031437
                hiddenAnimation24.duration = 0.203902
                hiddenAnimation24.fillMode = kCAFillModeForwards
                hiddenAnimation24.isRemovedOnCompletion = false
                hiddenAnimation24.keyPath = "hidden"
                hiddenAnimation24.toValue = 1
                hiddenAnimation24.fromValue = 1

                flowerLayer4.add(hiddenAnimation24, forKey: "hiddenAnimation24")

            layerLayer.addSublayer(flowerLayer4)

            // 008-flower-2
            //
            let flowerLayer5 = CALayer()
            flowerLayer5.name = "008-flower-2"
            flowerLayer5.bounds = CGRect(x: 0, y: 0, width: 10, height: 14)
            flowerLayer5.position = CGPoint(x: 47, y: 254)
            flowerLayer5.anchorPoint = CGPoint(x: 0.5, y: 1)
            flowerLayer5.contents = flowerEpsImage1.cgImage
            flowerLayer5.contentsGravity = kCAGravityResizeAspect
            flowerLayer5.contentsScale = 2
            flowerLayer5.shadowOffset = CGSize(width: 0, height: 1)
            flowerLayer5.fillMode = kCAFillModeForwards

                // 008-flower-2 Animations
                //

                // transform.scale.y
                //
                let transformScaleYAnimation15 = CASpringAnimation()
                transformScaleYAnimation15.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 1.451848
                transformScaleYAnimation15.duration = 0.99321
                transformScaleYAnimation15.fillMode = kCAFillModeForwards
                transformScaleYAnimation15.isRemovedOnCompletion = false
                transformScaleYAnimation15.keyPath = "transform.scale.y"
                transformScaleYAnimation15.toValue = 1
                transformScaleYAnimation15.fromValue = 0
                transformScaleYAnimation15.stiffness = 200
                transformScaleYAnimation15.damping = 10
                transformScaleYAnimation15.mass = 0.7
                transformScaleYAnimation15.initialVelocity = 4

                flowerLayer5.add(transformScaleYAnimation15, forKey: "transformScaleYAnimation15")

                // hidden
                //
                let hiddenAnimation25 = CABasicAnimation()
                hiddenAnimation25.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + -0.031437
                hiddenAnimation25.duration = 1.483285
                hiddenAnimation25.fillMode = kCAFillModeForwards
                hiddenAnimation25.isRemovedOnCompletion = false
                hiddenAnimation25.keyPath = "hidden"
                hiddenAnimation25.toValue = 1
                hiddenAnimation25.fromValue = 1

                flowerLayer5.add(hiddenAnimation25, forKey: "hiddenAnimation25")

                // hidden
                //
                let hiddenAnimation26 = CABasicAnimation()
                hiddenAnimation26.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 1.451848
                hiddenAnimation26.duration = 0.725923
                hiddenAnimation26.fillMode = kCAFillModeForwards
                hiddenAnimation26.isRemovedOnCompletion = false
                hiddenAnimation26.keyPath = "hidden"
                hiddenAnimation26.toValue = 0
                hiddenAnimation26.fromValue = 0

                flowerLayer5.add(hiddenAnimation26, forKey: "hiddenAnimation26")

            layerLayer.addSublayer(flowerLayer5)

            // 008-flower-2
            //
            let flowerLayer6 = CALayer()
            flowerLayer6.name = "008-flower-2"
            flowerLayer6.bounds = CGRect(x: 0, y: 0, width: 11, height: 18)
            flowerLayer6.position = CGPoint(x: 165.5, y: 245)
            flowerLayer6.anchorPoint = CGPoint(x: 0.5, y: 1)
            flowerLayer6.contents = flowerEpsImage1.cgImage
            flowerLayer6.contentsGravity = kCAGravityResizeAspect
            flowerLayer6.contentsScale = 2
            flowerLayer6.shadowOffset = CGSize(width: 0, height: 1)
            flowerLayer6.fillMode = kCAFillModeForwards

                // 008-flower-2 Animations
                //

                // transform.scale.y
                //
                let transformScaleYAnimation16 = CASpringAnimation()
                transformScaleYAnimation16.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.569762
                transformScaleYAnimation16.duration = 0.99321
                transformScaleYAnimation16.fillMode = kCAFillModeForwards
                transformScaleYAnimation16.isRemovedOnCompletion = false
                transformScaleYAnimation16.keyPath = "transform.scale.y"
                transformScaleYAnimation16.toValue = 1
                transformScaleYAnimation16.fromValue = 0
                transformScaleYAnimation16.stiffness = 200
                transformScaleYAnimation16.damping = 10
                transformScaleYAnimation16.mass = 0.7
                transformScaleYAnimation16.initialVelocity = 4

                flowerLayer6.add(transformScaleYAnimation16, forKey: "transformScaleYAnimation16")

                // hidden
                //
                let hiddenAnimation27 = CABasicAnimation()
                hiddenAnimation27.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + -0.018193
                hiddenAnimation27.duration = 0.587955
                hiddenAnimation27.fillMode = kCAFillModeForwards
                hiddenAnimation27.isRemovedOnCompletion = false
                hiddenAnimation27.keyPath = "hidden"
                hiddenAnimation27.toValue = 1
                hiddenAnimation27.fromValue = 1

                flowerLayer6.add(hiddenAnimation27, forKey: "hiddenAnimation27")

                // hidden
                //
                let hiddenAnimation28 = CABasicAnimation()
                hiddenAnimation28.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.569762
                hiddenAnimation28.duration = 0.99321
                hiddenAnimation28.fillMode = kCAFillModeForwards
                hiddenAnimation28.isRemovedOnCompletion = false
                hiddenAnimation28.keyPath = "hidden"
                hiddenAnimation28.toValue = 0
                hiddenAnimation28.fromValue = 0

                flowerLayer6.add(hiddenAnimation28, forKey: "hiddenAnimation28")

            layerLayer.addSublayer(flowerLayer6)

            // 008-flower-2
            //
            let flowerLayer7 = CALayer()
            flowerLayer7.name = "008-flower-2"
            flowerLayer7.bounds = CGRect(x: 0, y: 0, width: 11, height: 18)
            flowerLayer7.position = CGPoint(x: 288.5, y: 259)
            flowerLayer7.anchorPoint = CGPoint(x: 0.5, y: 1)
            flowerLayer7.contents = flowerEpsImage1.cgImage
            flowerLayer7.contentsGravity = kCAGravityResizeAspect
            flowerLayer7.contentsScale = 2
            flowerLayer7.shadowOffset = CGSize(width: 0, height: 1)
            flowerLayer7.fillMode = kCAFillModeForwards

                // 008-flower-2 Animations
                //

                // transform.scale.y
                //
                let transformScaleYAnimation17 = CASpringAnimation()
                transformScaleYAnimation17.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 1.451848
                transformScaleYAnimation17.duration = 0.99321
                transformScaleYAnimation17.fillMode = kCAFillModeForwards
                transformScaleYAnimation17.isRemovedOnCompletion = false
                transformScaleYAnimation17.keyPath = "transform.scale.y"
                transformScaleYAnimation17.toValue = 1
                transformScaleYAnimation17.fromValue = 0
                transformScaleYAnimation17.stiffness = 200
                transformScaleYAnimation17.damping = 10
                transformScaleYAnimation17.mass = 0.7
                transformScaleYAnimation17.initialVelocity = 4

                flowerLayer7.add(transformScaleYAnimation17, forKey: "transformScaleYAnimation17")

                // hidden
                //
                let hiddenAnimation29 = CABasicAnimation()
                hiddenAnimation29.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + -0.022295
                hiddenAnimation29.duration = 1.474143
                hiddenAnimation29.fillMode = kCAFillModeForwards
                hiddenAnimation29.isRemovedOnCompletion = false
                hiddenAnimation29.keyPath = "hidden"
                hiddenAnimation29.toValue = 1
                hiddenAnimation29.fromValue = 1

                flowerLayer7.add(hiddenAnimation29, forKey: "hiddenAnimation29")

                // hidden
                //
                let hiddenAnimation30 = CABasicAnimation()
                hiddenAnimation30.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 1.451848
                hiddenAnimation30.duration = 0.99321
                hiddenAnimation30.fillMode = kCAFillModeForwards
                hiddenAnimation30.isRemovedOnCompletion = false
                hiddenAnimation30.keyPath = "hidden"
                hiddenAnimation30.toValue = 0
                hiddenAnimation30.fromValue = 0

                flowerLayer7.add(hiddenAnimation30, forKey: "hiddenAnimation30")

            layerLayer.addSublayer(flowerLayer7)

            // 008-flower-2
            //
            let flowerLayer8 = CALayer()
            flowerLayer8.name = "008-flower-2"
            flowerLayer8.bounds = CGRect(x: 0, y: 0, width: 9, height: 16)
            flowerLayer8.position = CGPoint(x: 271.5, y: 255)
            flowerLayer8.anchorPoint = CGPoint(x: 0.5, y: 1)
            flowerLayer8.contents = flowerEpsImage1.cgImage
            flowerLayer8.contentsGravity = kCAGravityResizeAspect
            flowerLayer8.contentsScale = 2
            flowerLayer8.shadowOffset = CGSize(width: 0, height: 1)
            flowerLayer8.fillMode = kCAFillModeForwards

                // 008-flower-2 Animations
                //

                // transform.scale.y
                //
                let transformScaleYAnimation18 = CASpringAnimation()
                transformScaleYAnimation18.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 1.227529
                transformScaleYAnimation18.duration = 0.99321
                transformScaleYAnimation18.fillMode = kCAFillModeForwards
                transformScaleYAnimation18.isRemovedOnCompletion = false
                transformScaleYAnimation18.keyPath = "transform.scale.y"
                transformScaleYAnimation18.toValue = 1
                transformScaleYAnimation18.fromValue = 0
                transformScaleYAnimation18.stiffness = 200
                transformScaleYAnimation18.damping = 10
                transformScaleYAnimation18.mass = 0.7
                transformScaleYAnimation18.initialVelocity = 4

                flowerLayer8.add(transformScaleYAnimation18, forKey: "transformScaleYAnimation18")

                // hidden
                //
                let hiddenAnimation31 = CABasicAnimation()
                hiddenAnimation31.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + -0.020003
                hiddenAnimation31.duration = 1.247532
                hiddenAnimation31.fillMode = kCAFillModeForwards
                hiddenAnimation31.isRemovedOnCompletion = false
                hiddenAnimation31.keyPath = "hidden"
                hiddenAnimation31.toValue = 1
                hiddenAnimation31.fromValue = 1

                flowerLayer8.add(hiddenAnimation31, forKey: "hiddenAnimation31")

                // hidden
                //
                let hiddenAnimation32 = CABasicAnimation()
                hiddenAnimation32.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 1.227529
                hiddenAnimation32.duration = 0.99321
                hiddenAnimation32.fillMode = kCAFillModeForwards
                hiddenAnimation32.isRemovedOnCompletion = false
                hiddenAnimation32.keyPath = "hidden"
                hiddenAnimation32.toValue = 0
                hiddenAnimation32.fromValue = 0

                flowerLayer8.add(hiddenAnimation32, forKey: "hiddenAnimation32")

            layerLayer.addSublayer(flowerLayer8)

            // 008-flower-2
            //
            let flowerLayer9 = CALayer()
            flowerLayer9.name = "008-flower-2"
            flowerLayer9.bounds = CGRect(x: 0, y: 0, width: 6, height: 12)
            flowerLayer9.position = CGPoint(x: 255, y: 230)
            flowerLayer9.anchorPoint = CGPoint(x: 0.5, y: 1)
            flowerLayer9.contents = flowerEpsImage1.cgImage
            flowerLayer9.contentsGravity = kCAGravityResizeAspect
            flowerLayer9.contentsScale = 2
            flowerLayer9.shadowOffset = CGSize(width: 0, height: 1)
            flowerLayer9.fillMode = kCAFillModeForwards

                // 008-flower-2 Animations
                //

                // transform.scale.y
                //
                let transformScaleYAnimation19 = CASpringAnimation()
                transformScaleYAnimation19.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.390989
                transformScaleYAnimation19.duration = 0.99321
                transformScaleYAnimation19.fillMode = kCAFillModeForwards
                transformScaleYAnimation19.isRemovedOnCompletion = false
                transformScaleYAnimation19.keyPath = "transform.scale.y"
                transformScaleYAnimation19.toValue = 1
                transformScaleYAnimation19.fromValue = 0
                transformScaleYAnimation19.stiffness = 200
                transformScaleYAnimation19.damping = 10
                transformScaleYAnimation19.mass = 0.7
                transformScaleYAnimation19.initialVelocity = 4

                flowerLayer9.add(transformScaleYAnimation19, forKey: "transformScaleYAnimation19")

                // hidden
                //
                let hiddenAnimation33 = CABasicAnimation()
                hiddenAnimation33.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + -0.016965
                hiddenAnimation33.duration = 0.407955
                hiddenAnimation33.fillMode = kCAFillModeForwards
                hiddenAnimation33.isRemovedOnCompletion = false
                hiddenAnimation33.keyPath = "hidden"
                hiddenAnimation33.toValue = 1
                hiddenAnimation33.fromValue = 1

                flowerLayer9.add(hiddenAnimation33, forKey: "hiddenAnimation33")

                // hidden
                //
                let hiddenAnimation34 = CABasicAnimation()
                hiddenAnimation34.beginTime = self.layer.convertTime(CACurrentMediaTime(), from: nil) + 0.390989
                hiddenAnimation34.duration = 1.275772
                hiddenAnimation34.fillMode = kCAFillModeForwards
                hiddenAnimation34.isRemovedOnCompletion = false
                hiddenAnimation34.keyPath = "hidden"
                hiddenAnimation34.toValue = 0
                hiddenAnimation34.fromValue = 0

                flowerLayer9.add(hiddenAnimation34, forKey: "hiddenAnimation34")

            layerLayer.addSublayer(flowerLayer9)

        self.layer.addSublayer(layerLayer)

    }

    // MARK: - Responder

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let location = touches.first?.location(in: self.superview),
              let hitLayer = self.layer.presentation()?.hitTest(location) else { return }

        print("Layer \(hitLayer.name ?? String(describing: hitLayer)) was tapped.")
    }
}
