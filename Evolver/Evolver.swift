//
//  Evolver.swift
//  Evolver
//
//  Created by AtsuyaSato on 2017/10/15.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation

public class Evolver {
    public class func run<T: Generable>(geneType: T.Type, max generation: Int, per size: Int, completion: (_ model: T,_ generation: Int) -> Int) -> T? {

        print(geneType.init())

        let decoder = JSONDecoder()
        let jsonString =
"""
{
    \"direction\": {
        \"geneType\" : 12
    },
    \"distinct\": {
        \"gene\" : 80
    }
}
"""

        let jsonData = jsonString.data(using: .utf8)!
        let gene = try! decoder.decode(T.self, from: jsonData)
        let mirror = Mirror(reflecting: gene)
        for child in mirror.children {
            print(child.label!)
            print(child.value)
            // print(Counter(type(of: child.value)))
        }

//        do {
//            obj = try decoder.decode(T.self, from: jsonData)
//        } catch {
//            print("json convert failed in JSONDecoder", error.localizedDescription)
//        }
//        seed.setValue(3, forKey: child.label!)
//        seed.value(forKey: "direction")

        return gene
    }
}
