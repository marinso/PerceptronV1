//
//  TrainMode.swift
//  Perceptron
//
//  Created by Martin Nasierowski on 15/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TrainMode: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Properties
   var ref: DatabaseReference!

   var buttonArray = [UIButton]()
   var hStackArray = [UIStackView]()
   var arraysOfData = [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
   var exampleNumber = -1
   
   var currentButtonTag = 1
   var vStack: UIStackView!
   
   
   lazy var clearButton: UIButton = {
       let button = UIButton(type: .system)
       button.setTitle("Clear", for: .normal)
       button.addTarget(self, action: #selector(clear), for: .touchUpInside)
       button.backgroundColor = .white
       button.titleLabel?.font = UIFont.systemFont(ofSize: 35)
       return button
   }()
   
   lazy var addToExamplesButton: UIButton = {
       let button = UIButton(type: .system)
       button.setTitle("Add Exaple", for: .normal)
       button.addTarget(self, action: #selector(addExample), for: .touchUpInside)
       button.backgroundColor = .white
       button.titleLabel?.font = UIFont.systemFont(ofSize: 35)
       return button
   }()
   
   override func viewDidLoad() {
       super.viewDidLoad()
       view.backgroundColor = .lightGray
       
       createMainVStack()
       
       view.addSubview(clearButton)
       clearButton.anchor(top: vStack.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingBottom: 0, paddingLeft: 350, paddingRight: 350, width: 100, height: 50)
       setPicker()
       
       view.addSubview(addToExamplesButton)
       addToExamplesButton.anchor(top: nil, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 50, paddingLeft: 350, paddingRight: 350, width: 100, height: 50)
    
       ref = Database.database().reference()
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
       if sender.backgroundColor == .white {
           sender.backgroundColor = .red
           arraysOfData[sender.tag] = 1
       } else {
           sender.backgroundColor = .white
           arraysOfData[sender.tag] = 0
       }
   }
   
   @objc func clear() {
       arraysOfData = [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
       
       for i in 1..<36 {
           let button = self.view.viewWithTag(i) as? UIButton
           button?.backgroundColor = .white
       }
   }
   
   // MARK: - PickerView
   
   func setPicker() {
       let picker = UIPickerView()
       picker.dataSource = self
       picker.delegate = self
       
       view.addSubview(picker)
       picker.anchor(top: clearButton.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingBottom: 0, paddingLeft: 200, paddingRight: 200, width: view.frame.width, height: 200)
   }
   
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
   }
   
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return 11
   }
   
   func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
       return 70
   }
   
   func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
       
       var pickerLabel: UILabel? = (view as? UILabel)
       if pickerLabel == nil {
           pickerLabel = UILabel()
           pickerLabel?.font = UIFont.systemFont(ofSize: 50)
           pickerLabel?.textAlignment = .center
       }
       pickerLabel?.text = "\(row)"
       
       return pickerLabel!
   }
   
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       exampleNumber = row
   }
   
   // MARK: - REALM
   @objc func addExample() {
     let example = Example.init(with: exampleNumber, for: arraysOfData)
     pushToDatabase(with: example)
   }
    
    func  pushToDatabase(with example:Example) {
        let uuid = NSUUID().uuidString
        self.ref.child("examples").child(uuid).setValue(["number": example.number, "table": example.table])
    }

}
