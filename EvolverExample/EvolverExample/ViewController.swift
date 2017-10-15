//
//  ViewController.swift
//  EvolverExample
//
//  Created by AtsuyaSato on 2017/10/15.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import Evolver

enum Direction: Int, Countable {
    case left
    case right
    case up
    case down
}

struct Player: Generable {
    let direction: Direction = .up
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(Counter(Direction.self).count)
        _ = Evolver.run(geneType: Player.self, max: 10, per: 10, completion: { model, general in
            return 0
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

