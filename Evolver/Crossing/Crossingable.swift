//
//  Crossingable.swift
//  Evolver
//
//  Created by AtsuyaSato on 2018/05/27.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

public protocol Crossingable {
    func crossover(chromosomeA: String, chromosomeB: String) -> String
}
