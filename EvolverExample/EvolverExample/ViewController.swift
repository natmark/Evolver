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
    var direction = Array(
        repeating: Gene.template(Direction.self, geneSize: Direction.count()),
        count: 20
    )
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.global(qos: .userInitiated).async {
            let result = Evolver.run(template: Player.self, generations: 20, individuals: 10, completion: { model, generation, individual in
                print(generation, individual)
                return self.evaluate(model: model)
            })
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    print(self.evaluate(model: model))
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func evaluate(model: Player) -> Int {
        enum tableElement: Int {
            case free
            case player
            case obstacle
            case goal
        }

        let tableSize = 5
        var table = [
            [1,0,0,0,0],
            [0,2,0,2,0],
            [0,2,0,2,0],
            [0,2,2,0,3],
            [0,0,0,0,0]
        ]

        var player = (i: 0, j: 0)
        let goal = (i: 3, j: 4)

        for direction in model.direction {
            table[player.i][player.j] = 0
            switch direction.value {
            case .up:
                if player.i - 1 < 0 { continue }
                if table[player.i - 1][player.j] == tableElement.free.rawValue ||
                    table[player.i - 1][player.j] == tableElement.goal.rawValue {
                    player = (i: player.i - 1, j: player.j)
                }
            case .down:
                if player.i + 1 >= tableSize { continue }
                if table[player.i + 1][player.j] == tableElement.free.rawValue ||
                    table[player.i + 1][player.j] == tableElement.goal.rawValue {
                    player = (i: player.i + 1, j: player.j)
                }
            case .left:
                if player.j - 1 < 0 { continue }
                if table[player.i][player.j - 1] == tableElement.free.rawValue ||
                    table[player.i][player.j - 1] == tableElement.goal.rawValue {
                    player = (i: player.i , j: player.j - 1)
                }
            case .right:
                if player.j + 1 >= tableSize { continue }
                if table[player.i][player.j + 1] == tableElement.free.rawValue ||
                    table[player.i][player.j + 1] == tableElement.goal.rawValue {
                    player = (i: player.i , j: player.j + 1)
                }
            }
            table[player.i][player.j] = 1
        }

        for i in 0..<tableSize {
            for j in 0..<tableSize {
                print(table[i][j], terminator: "")
            }
            print("\n")
        }

        return tableSize - Int(sqrt(pow(Double(player.i - goal.i), 2) + pow(Double(player.j - goal.j), 2)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
