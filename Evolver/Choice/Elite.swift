//
//  Elite.swift
//  Evolver
//
//  Created by AtsuyaSato on 2018/05/27.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Foundation

public struct Elite: Choiceable {
    public func choose<T: Generable>(genoms: [Genom<T>]) -> [Genom<T>] {
        var genoms = genoms
        genoms.sort { $1.score < $0.score }

        // MARK: Choice
        if genoms.count > 2 {
            genoms = genoms.prefix(genoms.count/2).compactMap { $0 }
        }

        return genoms
    }
}
