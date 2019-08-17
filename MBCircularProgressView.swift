//
//  MBCircularProgressView.swift
//  
//
//  Created by Manish Bhande on 17/08/19.
//

import Foundation

open class MBCircularProgressView: UIView {
    
    
    
    /// 0.0 .. 1.0, default is 0.0
    public var progress: Float {
        get { return Float(progressLayer.strokeEnd) }
        set { progressLayer.strokeEnd = CGFloat(newValue) }
    }
    
    open var progressTintColor: UIColor? = UIColor.red {
        didSet { progressLayer.strokeColor = progressTintColor?.cgColor }
    }
    
    open var trackTintColor: UIColor? = UIColor.lightGray {
        didSet { trackLayer.strokeColor = trackTintColor?.cgColor }
    }
    
    public var trackWidth: CGFloat = 5 { didSet { updateLayout() } }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    open func setProgress(_ progress: Float, animated: Bool) {
         guard animated else {
             self.progress = progress
             return
         }
         animate(to: progress)
     }
    
    
    private lazy var trackLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = trackTintColor?.cgColor
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()
    
    private lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = progressTintColor?.cgColor
        layer.lineCap = .round
        layer.strokeEnd = 0
        self.layer.insertSublayer(layer, at: 1)
        return layer
    }()
    
    private func updateLayout() {
        let radius = min(bounds.width, bounds.height)/2 - trackWidth/2
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: -0.5 * .pi, endAngle: .pi * 1.5, clockwise: true).cgPath
        trackLayer.path = path
        trackLayer.lineWidth = trackWidth
        progressLayer.path = path
        progressLayer.lineWidth = trackWidth
    }
    
    private func animate(to: Float) {
        let from = progress
        progress = to
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = CFTimeInterval(from>to ? from-to : to-from)
        animation.fromValue = from
        animation.toValue = to
        progressLayer.add(animation, forKey: "strokeAnimation")
    }
}
