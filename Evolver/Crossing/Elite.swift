//
//  Elite.swift
//  Evolver
//
//  Created by AtsuyaSato on 2018/05/27.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Foundation

struct Elite: Crossingable {
    func crossing<T>(genoms: inout [Genom<T>]) where T: Generable {
        // MARK: Sort
        genoms.sort { $1.score < $0.score }

        // MARK: Choice
        if genoms.count > 2 {
            genoms = genoms.prefix(genoms.count/2).compactMap { $0 }
        }
    }
}
