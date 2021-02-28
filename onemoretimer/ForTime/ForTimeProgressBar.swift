//
//  ForTimeProgressBar.swift
//  onemoretimer
//
//  Created by 정정이 on 2021/02/20.
//

import UIKit

class ForTimeProgressBar: UIView {

    let shapeLayer = CAShapeLayer()
    let trackLayer = CAShapeLayer()

    override init(frame: CGRect) {
    super.init(frame: frame)
        addProgressBar(radius: 5, progress: 0)
    }

    required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
        addProgressBar(radius: 5, progress: 0)
    }

    func addProgressBar(radius: CGFloat, progress: CGFloat) {

        let lineWidth = radius*0.100 // progressBar thickness
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: radius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)

        //TrackLayer
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.white.cgColor
        // background color
        trackLayer.strokeColor = UIColor.clear.cgColor
        trackLayer.opacity = 0.5
        // transparency
        trackLayer.lineWidth = lineWidth
        trackLayer.lineCap = CAShapeLayerLineCap.round

        //BarLayer
        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.orange.cgColor // progressBar color
        shapeLayer.opacity = 0.8 // transparency

        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = CAShapeLayerLineCap.round



        //Rotate Shape Layer
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)



        //Animation
        loadProgress(percentage: progress)

        //LoadLayers
        layer.addSublayer(trackLayer)
        layer.addSublayer(shapeLayer)

    }

    
    
    // fromValue = progress bar start point 0 starts, 1 ends
    // duration = Time when progress bar goes from 0 to 1 (unit: second)
    // nowTime = count up
    // speed = if 0, the progress bar does not move.
    // strokeEnd = end point value (this is 1)
    // nowTime / Double(TabataTimerViewController.timeOut) = current progress
    
    // first start progress bar (default)
    func loadProgress(percentage: CGFloat) {

        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = 0
        basicAnimation.duration = CFTimeInterval(ForTimeTimerViewController.timeOut)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.strokeColor = UIColor.orange.cgColor
        shapeLayer.strokeEnd = percentage
        shapeLayer.add(basicAnimation, forKey: "basicStroke")

    }
    // restart progress bar
    func loadProgressPause(percentage: CGFloat, nowTime: Double) {

        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = nowTime / Double(ForTimeTimerViewController.timeOut)
        basicAnimation.duration = Double(ForTimeTimerViewController.timeOut)
        shapeLayer.strokeColor = UIColor.gray.cgColor
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.speed = 0

        shapeLayer.strokeEnd = percentage
        shapeLayer.add(basicAnimation, forKey: "basicStroke")

    }


    // 프로그래스바 재시작
    func loadProgressRestart(percentage: CGFloat,nowTime: Double) {

        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = nowTime / Double(ForTimeTimerViewController.timeOut)
        basicAnimation.duration = Double(ForTimeTimerViewController.timeOut) - nowTime // restart하면 현재 시간부터 프로그래스바 실행
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.strokeColor = UIColor.orange.cgColor // 프로그래스바 색
        shapeLayer.strokeEnd = percentage
        shapeLayer.add(basicAnimation, forKey: "basicStroke")

    }


}
