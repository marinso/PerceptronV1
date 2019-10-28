//
//  perceptron.swift
//  Perceptron
//
//  Created by Martin Nasierowski on 15/10/2019.
//  Copyright © 2019 Martin Nasierowski. All rights reserved.

import Foundation
import FirebaseDatabase

class Perceptron {
        
    var wages = [Float]()
    
    var number: Int?
    var N:Float = 0.1
    var examples = [Example]()
    var ref: DatabaseReference!
    
    struct Pocket {
        var wages = [Float]()
        var lifeTime = 0
    }
    
    init(which number: Int) {
        self.number = number
        randomWages()
        fetchExamples()
    }
    
    func learn() {
        
        var pocketRecord = Pocket()
        pocketRecord.wages = wages
        var lifeTime = 0
        
        for _ in 0...10000 {
           
           let example = examples[Int.random(in:0..<examples.count)]
                        
           let correct_answer = example.number == self.number ? 1 : -1
        
           let ERR = correct_answer - trashholdFunc(with: example)
           
           if ERR == 0 {
                lifeTime += 1
            if lifeTime > pocketRecord.lifeTime {
                pocketRecord.lifeTime = lifeTime
                pocketRecord.wages = self.wages
            }
            continue
           } else {
                for i in 0...35 {
                    let Eji = example.table[i]
                    wages[i] += N * Float(ERR * Eji)
                }
              lifeTime = 0
            }
        }
        
        self.wages = pocketRecord.wages
        
        var errors: Int = 0
        
        for i in 0..<examples.count {
            let example = examples[i]
                            
            let correct_answer = example.number == self.number ? 1 : -1
            
            let ERR = correct_answer - trashholdFunc(with: example)
            
            if ERR != 0 {
                errors += 1
            }
        }
        
        print(errors)
    }
    
    
    func trashholdFunc(with example:Example) -> Int {
        var summary:Float = 0;
        var Ej = -1
        
        for j in 0...35 {
          Ej = example.table[j]
          summary += self.wages[j] * Float(Ej)
        }
        
        return (summary < 0 ? -1 : 1)
    }
    
    private func randomWages() {
        for _ in 0...35 {
            wages.append(Float.random(in: -1..<1))
        }
    }
    
    private func fetchExamples() {
        ref = Database.database().reference()
        ref.child("examples").observe(.childAdded) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String,AnyObject> else { return }
            let example = Example.init(with: dictionary["number"] as! Int, for: dictionary["table"] as! [Int])
            self.examples.append(example)
        }
    }
    
}
