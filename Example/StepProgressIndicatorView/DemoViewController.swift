//
//  ViewController.swift
//  StepProgressIndicatorView
//
//  Created by miiiiiin on 01/27/2021.
//  Copyright (c) 2021 miiiiiin. All rights reserved.
//

import UIKit
import StepProgressIndicatorView

class DemoViewController: UIViewController {
    
    let firstSteps = [
        "Morbi nam",
        "Mauris congue ligula sed arcu",
        "Nam proin",
        "Nunc venenatis erat vitae quam laoreet blandit.",
        "Curabitur eu urna in nisi molestie tincidunt.",
    ]
    
    let details = [
        0: "In vel risus eget mauris sagittis euismod.",
        1: "Maecenas a sollicitudin lacus. Ut condimentum, felis in volutpat dignissim.",
        2: "Ut dapibus urna et dui facilisis, quis consequat orci tristique.",
    ]
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = -1
        slider.maximumValue = Float(firstSteps.count)
        slider.value = -1
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        return slider
    }()
    
    lazy var stepIndicatorView: StepProgressIndicatorView = {
        let view = StepProgressIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.stepTitles = firstSteps
        view.details = details
        view.direction = .topToBottom
        view.currentStep = 0
        view.circleColor = .lightGray
        view.circleTintColor = .systemTeal
        view.currentTextColor = view.circleTintColor
        view.circleStrokeWidth = 3.0
        view.circleRadius = 10.0
        view.lineColor = view.circleColor
        view.lineTintColor = view.circleTintColor
        view.lineMargin = 4.0
        view.lineStrokeWidth = 2.0
        view.displayNumbers = false
        view.showFlag = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        [stepIndicatorView, slider].forEach(self.view.addSubview(_:))
        
        NSLayoutConstraint.activate([
            stepIndicatorView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            stepIndicatorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            stepIndicatorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            slider.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100),
            slider.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            slider.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            slider.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -32),
        ])
    }
    
    @objc func sliderChanged(_ sender: UISlider) {
        stepIndicatorView.currentStep = Int(sender.value)
    }
}
