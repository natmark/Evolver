//
//  OnePointCrossover.swift
//  Evolver
//
//  Created by AtsuyaSato on 2018/05/28.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Foundation

public struct OnePointCrossover: Crossingable {
    public func crossover(chromosomeA: String, chromosomeB: String) -> String {
        let point = Int(arc4random_uniform(UInt32(chromosomeA.count)))
        guard chromosomeA.count == chromosomeB.count,
            point >= 0,
            point <= chromosomeA.count else {
                return ""
        }
        let prefix = String(chromosomeA[..<chromosomeA.index(chromosomeA.startIndex, offsetBy: point)])
        let surfix = String(chromosomeB[chromosomeB.index(chromosomeB.startIndex, offsetBy: point)...])
        return prefix + surfix
    }
}
