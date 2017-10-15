//
//  Coutable.swift
//  Evolver
//
//  Created by AtsuyaSato on 2017/10/15.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

public protocol Countable {
    init?(rawValue: Int)
}

public protocol EnumCounter {
    var count: Int { get }
}

public class Counter <T: Countable>: EnumCounter {
    let target: T.Type
    public var count: Int {
        var i = 1
        while target.init(rawValue: i) != nil { i+=1 }
        return i
    }

    public init(_ target: T.Type) {
        self.target = target
    }
}
