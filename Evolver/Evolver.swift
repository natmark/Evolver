//
//  Evolver.swift
//  Evolver
//
//  Created by AtsuyaSato on 2017/10/15.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation

public class Evolver {
    public class func run<T: Generable>(geneType: T.Type, max generation: Int, per size: Int, completion: (_ model: T,_ generation: Int) -> Int) -> T {
        let obj = geneType.init()
//        print(completion(obj, 1))

        let mirror = Mirror(reflecting: obj)
        for child in mirror.children {
            print(child.label!)
            print(child.value)
        }

        return obj
    }
}
