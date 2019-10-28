//
//  TryMode.swift
//  Perceptron
//
//  Created by Martin Nasierowski on 15/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TryMode: UIViewController {
    
    // MARK: - Properties
        
    var buttonArray = [UIButton]()
    var hStackArray = [UIStackView]()
    var arraysOfData = [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var exampleNumber = -1
    var perceptrons = [Perceptron]()

    var currentButtonTag = 1
    var vStack: UIStackView!
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.font = UIFont.boldSystemFont(ofSize: 80)
        label.textAlignment = .center
        label.textColor = .red
        return label
    }()
    
    lazy var learnButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Learn", for: .normal)
        button.addTarget(self, action: #selector(learnHandle), for: .touchUpInside)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        return button
    }()
    
    lazy var checkResultButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Check", for: .normal)
        button.addTarget(self, action: #selector(checkResult), for: .touchUpInside)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 45)
        return button
    }()
    
    // MARK: - LIFECYCLE
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        createMainVStack()
        
        view.addSubview(learnButton)
        learnButton.anchor(top: nil, bottom: view.bottomAnchor, left: nil, right: view.rightAnchor, paddingTop: 0, paddingBottom: 50, paddingLeft: 0, paddingRight: 200, width: 150, height: 80)
        
        view.addSubview(checkResultButton)
               checkResultButton.anchor(top: nil, bottom: view.bottomAnchor, left: view.leftAnchor, right: nil, paddingTop: 0, paddingBottom: 50, paddingLeft: 200, paddingRight: 0, width: 150, height: 80)
        
        view.addSubview(resultLabel)
        resultLabel.anchor(top: vStack.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 100, paddingBottom: 0, paddingLeft: 350, paddingRight: 350, width: 0, height: 0)
        
        createPerceptron()
    }
    
    // MARK: - UI
    
    func createHStack() {
        
        createButtons()
        
        let hStack = UIStackView(arrangedSubviews: buttonArray)
        hStack.axis = .horizontal
        hStack.alignment = .fill
        hStack.distribution = .fillEqually
        hStack.spacing = 10
        hStackArray.append(hStack)
        buttonArray = []
    }
    
    func createMainVStack() {
        
        for _ in 0..<7 {
            createHStack()
        }
        
        vStack = UIStackView(arrangedSubviews: hStackArray)
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fillEqually
        vStack.spacing = 10
        view.addSubview(vStack)
        vStack.anchor(top: view.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 100, paddingBottom: 0, paddingLeft: 200, paddingRight: 200, width: 0, height: view.frame.size.height / 2)
    }
    
    func createButtons() {
        
        for _ in 1..<6 {
           let button = UIButton(type: .system)
           button.setTitle("", for: .normal)
           button.backgroundColor = .white
           button.tag = currentButtonTag
           button.addTarget(self, action:#selector(buttonAction), for: .touchUpInside)
           button.frame.size = CGSize(width: 20, height: 20)
           buttonArray.append(button)
           currentButtonTag += 1
         }
    }
    
    // MARK: - Handlers
    
    @objc func buttonAction(sender: UIButton!) {
        checkResult()
        if sender.backgroundColor == .white {
            sender.backgroundColor = .red
            arraysOfData[sender.tag] = 1
        } else {
            sender.backgroundColor = .white
            arraysOfData[sender.tag] = 0
        }
    }
            
    // MARK: - Machine Learing
    
    @objc func learnHandle() {
        perceptrons.forEach { (perceptron) in
            perceptron.learn()
        }
    }
    
    func createPerceptron() {
        for i in 0...9 {
            let perceptron = Perceptron.init(which: i)
            perceptrons.append(perceptron)
        }
    }
    
    @objc func checkResult() {
        resultLabel.text = ""
        var summary = -1
    
        perceptrons.forEach { (perceptron) in
            let result = perceptron.trashholdFunc(with: Example.init(with: exampleNumber, for: arraysOfData))
            
            if result == 1 {
                summary = perceptron.number!
                resultLabel.text = resultLabel.text! + " \(summary)"
            }
        }
    }
}
