//
//  ChooseModeVC.swift
//  Perceptron
//
//  Created by Martin Nasierowski on 12/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import RealmSwift

class ChooseModeVC: UIViewController {
    
    lazy var trainModeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Train Mode", for: .normal)
        button.addTarget(self, action: #selector(handleTrainMode), for: .touchUpInside)
        button.backgroundColor = .white
        button.frame.size = CGSize(width: 350, height: 100)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        return button
    }()
    
    lazy var tryModeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Try Mode", for: .normal)
        button.addTarget(self, action: #selector(handleTryMode), for: .touchUpInside)
        button.backgroundColor = .white
        button.frame.size = CGSize(width: 350, height: 100)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(trainModeButton)
        trainModeButton.translatesAutoresizingMaskIntoConstraints = false
        trainModeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        trainModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -200).isActive = true
        
        view.addSubview(tryModeButton)
        tryModeButton.translatesAutoresizingMaskIntoConstraints = false
        tryModeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tryModeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 200).isActive = true
        
        
        
        
        var a = [1, 2, 3]
        var b = a
        b[0] = 7
        print(a)
    }
    
    @objc func handleTrainMode() {
        navigationController?.pushViewController(TrainMode(), animated: true)
    }
    
    @objc func handleTryMode() {
        navigationController?.pushViewController(TryMode(), animated: true)
    }
    
}
