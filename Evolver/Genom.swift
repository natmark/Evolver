//
//  Genom.swift
//  Evolver
//
//  Created by AtsuyaSato on 2017/10/17.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation

public struct Genom<T: Generable> {
    var gene: [String: Array<[String: Int]>]
    var score: Int = 0

    init(gene:  [String : Array<[String : Int]>]) {
        self.gene = gene
    }

    public func serialization() -> Data? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self.gene, options: []) else {
            return nil
        }
        return jsonData
    }

    public mutating func randomize() {
        for (key, array) in gene {
            let geneSize = GeneCodingKeys.geneSize.stringValue
            let value = GeneCodingKeys.value.stringValue
            for (i, dictionary) in array.enumerated() {
                gene[key]?[i][value] = Int(arc4random_uniform(UInt32(dictionary[geneSize] ?? 0)))
            }
        }
        print(gene)
    }

    public func decode() -> T? {
        let decoder = JSONDecoder()
        guard let jsonData = self.serialization() else {
            return nil
        }

        guard let gene = try? decoder.decode(T.self, from: jsonData) else {
            return nil
        }
        return gene
    }
}

public class GenomEngine {
    public class func binaryDigit(n: Int) -> Int {
        if n <= 1 { return n }

        var n = Double(n - 1)
        var digit = 0

        while ( n >= 1 ) {
            n = n / 2
            digit += 1
        }
        return digit
    }
}
