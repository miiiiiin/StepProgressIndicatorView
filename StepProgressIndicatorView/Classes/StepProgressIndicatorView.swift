//
//  StepProgressIndicatorView.swift
//  StepIndicatorView
//
//  Created by Running Raccoon on 2021/01/18.
//  Copyright © 2021 miiiiiin. All rights reserved.
//  Copyright (c) 2016 Yonat Sharon. All rights reserved.
//  Copyright © 2017 Yun CHEN. All rights reserved.
//

import UIKit

public enum StepProgressIndicatorViewDirection: UInt {
    case leftToRight = 0, rightToLeft, topToBottom, bottomToTop
}

@IBDesignable
public class StepProgressIndicatorView: UIView {
    
    // MARK: - Variables -
    
    static let defaultColor = UIColor(red: 90.0 / 255.0, green: 164.0 / 255.0, blue: 222.0 / 255.0, alpha: 1.0)
    static let defaultTintColor = UIColor(red: 0.0/255.0, green: 180.0/255.0, blue: 124.0/255.0, alpha: 1.0)
    private var annularLayers = [AnnularLayer]()
    private var horizontalLineLayers = [LineLayer]()
    private let containerLayer = CALayer()
    
    // MARK: - Behavior -
    
    /// Titles of the step-by-step progression stages
    open var stepTitles: [String] = []
    
    /// Optional additional text description for each step, shown below the step title
    open var details: [Int: String] = [:]
    
    // MARK: - Apperance -
    @objc open dynamic var textFont = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
    @objc open dynamic var detailFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    
    @IBInspectable open dynamic var lineWidth: CGFloat = 1
    
    /// space between steps (0 => default based on textFont)
    @IBInspectable open dynamic var verticalPadding: CGFloat = 0
    
    /// space between shape and text (0 => default based on textFont)
    @IBInspectable open dynamic var horizontalPadding: CGFloat = 0
    
    
    // MARK: - Colors -
    
    @IBInspectable open dynamic var futureStepColor: UIColor = .lightGray { didSet { needsColor = true } }
    @IBInspectable open dynamic var pastStepColor: UIColor = .lightGray { didSet { needsColor = true } }
    
    /// nil => use the view's tintColor
    @IBInspectable open dynamic var currentStepColor: UIColor? { didSet { needsColor = true } }
    
    /// nil => use currentStepColor
    @IBInspectable open dynamic var currentDetailColor: UIColor? = .darkGray { didSet { needsColor = true } }
    
    @IBInspectable open dynamic var futureStepFillColor: UIColor = .clear { didSet { needsColor = true } }
    @IBInspectable open dynamic var pastStepFillColor: UIColor = .lightGray { didSet { needsColor = true } }
    @IBInspectable open dynamic var currentStepFillColor: UIColor = .clear { didSet { needsColor = true } }
    
    @IBInspectable open dynamic var futureTextColor: UIColor = .lightGray { didSet { needsColor = true } }
    @IBInspectable open dynamic var pastTextColor: UIColor = .lightGray { didSet { needsColor = true } }
    /// nil => use the view's tintColor
    @IBInspectable open dynamic var currentTextColor: UIColor? { didSet { needsColor = true } }
    
    
    // MARK: - Private -
    
    private var stepViews: [SingleStepView] = []
    
    private var needsColor: Bool = false {
        didSet {
            if needsColor && !oldValue {
                DispatchQueue.main.async { [weak self] in
                    if let strongSelf = self, strongSelf.needsColor {
                        strongSelf.setupStepViews()
                    }
                }
            }
        }
    }
    
    private func setupStepViews() {
        needsColor = false
        
        let n = stepViews.count
        if currentStep < n {
            // color future steps
            stepViews[currentStep + 1 ..< n].forEach {
                $0.color(text: futureTextColor, detail: futureTextColor, stroke: futureStepColor, fill: futureStepFillColor, line: futureStepColor)
            }
            
            // color current step
            if currentStep >= 0 {
                let textColor: UIColor = currentTextColor ?? tintColor
                let detailColor = currentDetailColor ?? textColor
                stepViews[currentStep].color(
                    text: textColor,
                    detail: detailColor,
                    stroke: textColor,
                    fill: currentStepFillColor,
                    line: futureStepColor
                )
            }
        }
        
        // color past steps
        if currentStep > 0 {
            stepViews[0 ..< min(currentStep, n)].forEach {
                $0.color(text: pastTextColor, detail: pastTextColor, stroke: pastStepColor, fill: pastStepFillColor, line: pastStepColor)
            }
        }
    }
    
    // MARK: - Overrided Properties and methods -
    override public var frame: CGRect {
        didSet {
            self.updateSubLayers()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.updateSubLayers()
    }
    
    override open func tintColorDidChange() {
        if nil == currentStepColor || nil == currentTextColor {
            needsColor = true
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        if stepViews.isEmpty { return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric) }
        let stepSizes = stepViews.map { $0.intrinsicContentSize }
        return CGSize(
            width: stepSizes.map { $0.width }.max() ?? 0,
            height: stepSizes.map { $0.height }.reduce(0, +)
        )
    }
    
    // MARK: - Custom Properties -
    
    @IBInspectable public var currentStep: Int = -1 {
        didSet {
            needsColor = true
            
            if self.annularLayers.count <= 0 {
                return
            }
            
            if oldValue != self.currentStep {
                self.setCurrentStep(step: self.currentStep)
            }
        }
    }
    
    @IBInspectable public var displayNumbers: Bool = false {
        didSet {
            self.updateSubLayers()
        }
    }
    
    @IBInspectable public var circleRadius: CGFloat = 10.0 {
        didSet {
            self.updateSubLayers()
        }
    }
    
    @IBInspectable public var circleColor:UIColor = defaultColor {
        didSet {
            self.updateSubLayers()
        }
    }
    
    @IBInspectable public var circleTintColor: UIColor = defaultTintColor {
        didSet {
            self.updateSubLayers()
        }
    }
    
    @IBInspectable public var circleStrokeWidth: CGFloat = 3.0 {
        didSet {
            self.updateSubLayers()
        }
    }
    
    @IBInspectable public var lineColor: UIColor = defaultColor {
        didSet {
            self.updateSubLayers()
        }
    }
    
    @IBInspectable public var lineTintColor: UIColor = defaultTintColor {
        didSet {
            self.updateSubLayers()
        }
    }
    
    @IBInspectable public var lineMargin: CGFloat = 4.0 {
        didSet {
            self.updateSubLayers()
        }
    }
    
    @IBInspectable public var lineStrokeWidth: CGFloat = 2.0 {
        didSet {
            self.updateSubLayers()
        }
    }
    
    public var direction: StepProgressIndicatorViewDirection = .topToBottom {
        didSet {
            self.createSteps()
            self.updateSubLayers()
        }
    }
    
    @IBInspectable var directionRaw: UInt {
        get {
            return self.direction.rawValue
        }
        
        set {
            let value = newValue > 3 ? 0 : newValue
            self.direction = StepProgressIndicatorViewDirection(rawValue: value)!
        }
    }
    
    open var showFlag: Bool = true {
        didSet {
            self.updateSubLayers()
        }
    }
    
    // MARK: - Functions -
    
    private func createSteps() {
        stepViews.forEach { $0.removeFromSuperview() }
        stepViews.removeAll(keepingCapacity: true)
        
        let shapeSize = details.isEmpty ? textFont.pointSize * 1.2 : textFont.pointSize * 1.0
        if horizontalPadding.isZero { horizontalPadding = shapeSize / 2}
        if verticalPadding.isZero { verticalPadding = shapeSize }
        
        if let layers = self.layer.sublayers {
            for layer in layers {
                layer.removeFromSuperlayer()
            }
        }
        
        self.annularLayers.removeAll()
        self.horizontalLineLayers.removeAll()
        
        if self.stepTitles.count <= 0 {
            return
        }
        
        for i in 0..<self.stepTitles.count {
            
            let annularLayer = AnnularLayer()
            self.containerLayer.addSublayer(annularLayer)
            self.annularLayers.append(annularLayer)
            
            if (i < self.stepTitles.count - 1) {
                let lineLayer = LineLayer()
                self.containerLayer.addSublayer(lineLayer)
                self.horizontalLineLayers.append(lineLayer)
            }
        }
        
        if direction == .topToBottom || direction == .bottomToTop {
            var prevView: UIView = self
            var prevAttribute: NSLayoutConstraint.Attribute = .top
            
            for i in 0..<stepTitles.count {
                let stepView = SingleStepView(text: stepTitles[i], detail: details[i], font: textFont, detailFont: detailFont, shapeSize: shapeSize, lineWidth: lineWidth, hPadding: horizontalPadding, vPadding: verticalPadding)
                
                stepViews.append(stepView)
                
                // layout step view
                addConstrainedSubview(stepView, constrain: .leading, .trailing)
                constrain(stepView, at: .top, to: prevView, at: prevAttribute)
                prevView = stepView
                prevAttribute = .bottom
            }
        }
        
        self.layer.addSublayer(self.containerLayer)
        self.setupStepViews()
        self.updateSubLayers()
        self.setCurrentStep(step: self.currentStep)
    }
    
    private func updateSubLayers() {
        self.containerLayer.frame = self.layer.bounds
        if self.direction == .leftToRight || self.direction == .rightToLeft {
            self.layoutHorizontal()
        } else {
            self.layoutVertical()
        }
        self.applyDirection()
    }
    
    private func layoutHorizontal() {
        let diameter = self.circleRadius * 2
        let stepWidth = self.stepTitles.count == 1 ? 0 : (self.containerLayer.frame.width - self.lineMargin * 2 - diameter) / CGFloat(self.stepTitles.count - 1)
        let y = self.containerLayer.frame.height / 2.0
        
        for i in 0..<self.annularLayers.count {
            let annularLayer = self.annularLayers[i]
            let x = self.stepTitles.count == 1 ? self.containerLayer.frame.width / 2.0 - self.circleRadius : self.lineMargin + CGFloat(i) * stepWidth
            
            annularLayer.frame = CGRect(x: x, y: y, width: diameter, height: diameter)
            self.applyAnnularStyle(annularLayer: annularLayer)
            annularLayer.step = i + 1
            annularLayer.updateStatus()
            
            if (i < self.stepTitles.count - 1) {
                let lineLayer = self.horizontalLineLayers[i]
                lineLayer.frame = CGRect(x: CGFloat(i) * stepWidth + diameter + self.lineMargin * 2, y: y + (2 * 4), width: stepWidth - diameter - self.lineMargin * 2, height: 3)
                self.applyLineStyle(lineLayer: lineLayer)
                lineLayer.updateStatus()
            }
        }
    }
    
    private func layoutVertical() {
        let diameter = self.circleRadius * 2
        let stepWidth = self.stepTitles.count == 1 ? 0 : (self.containerLayer.frame.height - self.lineMargin * 2 - diameter) / CGFloat(self.stepTitles.count - 1)
        
        for i in 0..<self.annularLayers.count {
            let annularLayer = self.annularLayers[i]
            let y = self.stepTitles.count == 1 ? self.containerLayer.frame.height / 2.0 - self.circleRadius : self.lineMargin + CGFloat(i) * stepWidth
            
            annularLayer.frame = CGRect(
                origin: CGPoint(x: floor(annularLayer.lineWidth / 2), y: y),
                size: CGSize(width: diameter, height: diameter)
            )
            
            self.applyAnnularStyle(annularLayer: annularLayer)
            annularLayer.step = i + 1
            annularLayer.updateStatus()
            
            if (i < self.stepTitles.count - 1) {
                let lineLayer = self.horizontalLineLayers[i]
                lineLayer.frame = CGRect(x: floor(annularLayer.lineWidth / 2) + 9, y: CGFloat(i) * stepWidth + diameter + self.lineMargin * 2, width: 3, height: stepWidth - diameter - self.lineMargin * 2)
                
                lineLayer.isHorizontal = false
                self.applyLineStyle(lineLayer: lineLayer)
                lineLayer.updateStatus()
            }
        }
    }
    
    private func applyAnnularStyle(annularLayer: AnnularLayer) {
        annularLayer.annularDefaultColor = self.circleColor
        annularLayer.tintColor = self.circleTintColor
        annularLayer.lineWidth = self.circleStrokeWidth
        annularLayer.displayNumber = self.displayNumbers
        annularLayer.showFlag = self.showFlag
    }
    
    private func applyLineStyle(lineLayer: LineLayer) {
        lineLayer.strokeColor = self.lineColor.cgColor
        lineLayer.tintColor = self.lineTintColor
        lineLayer.lineWidth = self.lineStrokeWidth
    }
    
    private func applyDirection() {
        switch self.direction {
        case .rightToLeft:
            let rotation180 = CATransform3DMakeRotation(CGFloat.pi, 0.0, 1.0, 0.0)
            self.containerLayer.transform = rotation180
            for annularLayer in self.annularLayers {
                annularLayer.transform = rotation180
            }
        case .bottomToTop:
            let rotation180 = CATransform3DMakeRotation(CGFloat.pi, 1.0, 0.0, 0.0)
            self.containerLayer.transform = rotation180
            for annularLayer in self.annularLayers {
                annularLayer.transform = rotation180
            }
        default:
            self.containerLayer.transform = CATransform3DIdentity
            for annularLayer in self.annularLayers {
                annularLayer.transform = CATransform3DIdentity
            }
        }
    }
    
    private func setCurrentStep(step: Int) {
        for i in 0..<self.stepTitles.count {
            if i < step {
                if !self.annularLayers[i].isFinished {
                    self.annularLayers[i].isFinished = true
                }
            } else if i == step {
                self.annularLayers[i].isFinished = false
                self.annularLayers[i].isCurrent = true
                
                self.setLineFinished(isFinished: true, index: i - 1)
            } else {
                self.annularLayers[i].isFinished = false
                self.annularLayers[i].isCurrent = false
                
                self.setLineFinished(isFinished: false, index: i - 1)
            }
        }
    }
    
    private func setLineFinished(isFinished: Bool, index: Int) {
        if index >= 0 {
            if self.horizontalLineLayers[index].isFinished != isFinished {
                self.horizontalLineLayers[index].isFinished = isFinished
            }
        }
    }
}

private class SingleStepView: UIView {
    var textLabel = UILabel()
    var detailLabel = UILabel()
    
    var leadingSpace: CGFloat = 0
    var bottomSpace: CGFloat = 0
    
    convenience init(text: String, detail: String?, font: UIFont, detailFont: UIFont, shapeSize: CGFloat, lineWidth: CGFloat, hPadding: CGFloat, vPadding: CGFloat) {
        self.init()
        
        leadingSpace = hPadding + shapeSize + lineWidth
        bottomSpace = vPadding
        
        // text
        textLabel.font = font
        textLabel.text = text
        textLabel.numberOfLines = 0
        addConstrainedSubview(textLabel, constrain: .top, .trailing)
        constrain(textLabel, at: .leading, diff: leadingSpace)
        
        // detail
        detailLabel.font = detailFont
        detailLabel.text = detail
        detailLabel.numberOfLines = 0
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(detailLabel)
        constrain(detailLabel, at: .top, to: textLabel, at: .bottom)
        constrain(detailLabel, at: .trailing, to: textLabel)
        constrain(detailLabel, at: .leading, to: textLabel)
        constrain(detailLabel, at: .bottom, diff: -vPadding)
    }
    
    func color(text: UIColor, detail: UIColor, stroke: UIColor, fill: UIColor, line: UIColor) {
        textLabel.textColor = text
        detailLabel.textColor = detail
    }
    
    override var intrinsicContentSize: CGSize {
        var size = textLabel.intrinsicContentSize
        size.width += leadingSpace
        size.height += detailLabel.intrinsicContentSize.height + bottomSpace
        return size
    }
}
