//
//  Substitution.swift
//  Evolver
//
//  Created by AtsuyaSato on 2018/05/28.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Foundation

public struct Substitution: Mutationable {
    public var mutationRate: Float = 0.05

    public func mutate(chromosome: String) -> String {
        var result = ""

        for i in 0..<chromosome.count {
            let startIndex = chromosome.index(chromosome.startIndex, offsetBy: i)
            let endIndex = chromosome.index(startIndex, offsetBy: 1)

            if Int(max(0.0, min(1.0, mutationRate)) * 100) < Int(arc4random_uniform(100)) {
                if chromosome[startIndex..<endIndex] == "0" {
                    result += "1"
                } else {
                    result += "0"
                }
            } else {
                result += chromosome[startIndex..<endIndex]
            }
        }
        return result
    }
}
