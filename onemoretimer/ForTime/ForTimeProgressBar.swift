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

        let lineWidth = radius*0.100 // 프로그레스바 두께 높을수록 두꺼워짐

        let circularPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: radius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)

        //TrackLayer
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.white.cgColor // background color
        trackLayer.strokeColor = UIColor.clear.cgColor
        trackLayer.opacity = 0.5 // 투명도
        trackLayer.lineWidth = lineWidth
        trackLayer.lineCap = CAShapeLayerLineCap.round

        //BarLayer
        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.orange.cgColor // 프로그래스바 색
        shapeLayer.opacity = 0.8 // 투명도

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

    
    
    // fromValue = 프로그래스바 시작지점 0 이 시작점, 1이 끝나는점
    // duration = 프로그래스바가 0 에서 1 로 갈때의 시간 (단위:초)
    // nowTime = 카운트업
    // speed = 0 이면 프로그래스바가 움직이지 않음
    // strokeEnd = 끝나는지점값 (얘가 1임)
    // nowTime / Double(ForTimeTimerViewController.timeOut) = 현재 프로그래스바 진행상태
    
    //처음 시작 프로그래스바 (기본)
    func loadProgress(percentage: CGFloat) {

        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = 0
        basicAnimation.duration = CFTimeInterval(ForTimeTimerViewController.timeOut) // 끝나는점(timeOut)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.strokeColor = UIColor.orange.cgColor // 프로그래스바 색
        shapeLayer.strokeEnd = percentage
        shapeLayer.add(basicAnimation, forKey: "basicStroke")

    }


    // 프로그래스바 일시정지
    func loadProgressPause(percentage: CGFloat, nowTime: Double) {

        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = nowTime / Double(ForTimeTimerViewController.timeOut)
        basicAnimation.duration = Double(ForTimeTimerViewController.timeOut) // 프로그래스바 일시정지하면 멈춰진 시간에 정지
        
        shapeLayer.strokeColor = UIColor.gray.cgColor// 프로그래스바 색
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
