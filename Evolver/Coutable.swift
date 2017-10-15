//
//  Coutable.swift
//  Evolver
//
//  Created by AtsuyaSato on 2017/10/15.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

protocol Countable {
    init?(rawValue: Int)
}

protocol EnumCounter {
    var count: Int { get }
}

class Counter <T: Countable>: EnumCounter {
    let target: T.Type
    var count: Int {
        var i = 1
        while target.init(rawValue: i) != nil { i+=1 }
        return i
    }

    init(_ target: T.Type) {
        self.target = target
    }
}
