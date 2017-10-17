//
//  ViewController.swift
//  EvolverExample
//
//  Created by AtsuyaSato on 2017/10/15.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import Evolver

enum Direction: Int, GeneBase {
    case left
    case right
    case up
    case down
}

enum Compass: Int, GeneBase {
    case north
    case south
    case east
    case west
}

struct Player: Generable {
    var direction = Array(
        repeating: Genom.template(Direction.self, geneSize: Counter(Direction.self).count),
        count: 1
    )
    var compass = Array(
        repeating: Genom.template(Compass.self, geneSize: Counter(Compass.self).count),
        count: 5
    )
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let result = Evolver.run(template: Player.self, max: 10, per: 10, completion: { model, general in
            return 0
        })
        switch result {
            case .success(let model):
                for compass in model.compass {
                    print(compass.value)
                }
            case .failure(let error):
                print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
