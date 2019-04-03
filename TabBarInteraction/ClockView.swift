//
//  ClockView.swift
//  TabBarInteraction
//
//  Created by potato04 on 2019/3/31.
//  Copyright © 2019 potato04. All rights reserved.
//

import UIKit

class ClockIconView: UIView {
    
    var hour: Int = 9 {
        didSet {
            hour = min(24, max(0, hour))
            updateHourHandLayerPath()
        }
    }
    
    var minute: Int = 0 {
        didSet {
            minute = min(60, max(0, minute))
            updateMinuteHandLayerPath()
        }
    }
    
    private let hourHandLayer = CAShapeLayer()
    private let minuteHandLayer = CAShapeLayer()
    
    var hourHandLength: CGFloat = 8 {
        didSet {
            updateHourHandLayerPath()
        }
    }
    var minuteHandLength: CGFloat = 10 {
        didSet {
            updateMinuteHandLayerPath()
        }
    }
    
    var lineWidth: CGFloat {
        get {
            return hourHandLayer.lineWidth
        }
        set {
            hourHandLayer.lineWidth = newValue
            minuteHandLayer.lineWidth = newValue
            updateHourHandLayerPath()
            updateMinuteHandLayerPath()
        }
    }
    
    override var tintColor: UIColor! {
        get {
            return UIColor(cgColor: hourHandLayer.strokeColor!)
        }
        set {
            hourHandLayer.strokeColor = newValue.cgColor
            minuteHandLayer.strokeColor = newValue.cgColor
            updateHourHandLayerPath()
            updateMinuteHandLayerPath()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        //updateBounds(bounds)
        
        hourHandLayer.lineCap = .round
        minuteHandLayer.lineCap = .round
        layer.addSublayer(hourHandLayer)
        layer.addSublayer(minuteHandLayer)
    }
    
    
    override func layoutSubviews() {
        updateBounds(bounds)
    }
    
    private func updateBounds(_ bounds: CGRect) {
        [hourHandLayer, minuteHandLayer].forEach {
            $0.bounds = bounds
            $0.position = CGPoint(x: bounds.midX, y: bounds.midY)
        }
        updateHourHandLayerPath()
        updateMinuteHandLayerPath()
    }
    
    private func updateHourHandLayerPath() {
        let hourHandLayerPath = UIBezierPath()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        hourHandLayerPath.move(to: center)
        hourHandLayerPath.addLine(to: CGPoint(x: center.x, y: center.y - hourHandLength))
        hourHandLayer.path = hourHandLayerPath.cgPath
        
        ///需要考虑分钟引起的时针偏移
        var radian = (2 * CGFloat.pi * CGFloat(hour)) / 12
        radian += (CGFloat(minute) / 60) * (2 * CGFloat.pi) / 12
        hourHandLayer.transform = CATransform3DMakeRotation(radian, 0, 0, 1)
    }
    
    private func updateMinuteHandLayerPath() {
        let minuteHandLayerPath = UIBezierPath()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        //minuteHandLayerPath.move(to: center.applying(CGAffineTransform(translationX: 0, y: lineWidth / 2)))
        minuteHandLayerPath.move(to: center)
        minuteHandLayerPath.addLine(to: CGPoint(x: center.x, y: center.y - minuteHandLength))
        minuteHandLayer.path = minuteHandLayerPath.cgPath
        minuteHandLayer.transform = CATransform3DMakeRotation((2 * CGFloat.pi * CGFloat(minute)) / 60 , 0, 0, 1)
    }
}
