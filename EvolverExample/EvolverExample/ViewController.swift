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

struct Player: Generable {
    var direction = GeneType<Direction>.geneType(Direction.self, geneSize: Counter(Direction.self).count)
    var distinct = GeneType<Direction>.geneType(Direction.self, geneSize: Counter(Direction.self).count)
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        _ = Evolver.run(geneType: Player.self, max: 10, per: 10, completion: { model, general in
            return 0
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
