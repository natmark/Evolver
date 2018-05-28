//
//  Genom.swift
//  Evolver
//
//  Created by AtsuyaSato on 2017/10/17.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation

public struct Genom<T: Generable> {
    public var gene: [String: [[String: Int]]]
    public var score: Int = 0
    public var mutationRate: Float = 0.05

    public var chromosome: String {
        return self.geneSequence.joined()
    }
    private var geneSizes: [Int] = []
    private var geneSequence: [String] = []
    private var geneValues: [Int] = []

    init(gene: [String: [[String: Int]]]) {
        self.gene = gene
        for (key, array) in gene {
            let geneSizeString = GeneCodingKeys.geneSize.stringValue
            let valueString = GeneCodingKeys.value.stringValue
            for (i, dictionary) in array.enumerated() {
                let geneSize = dictionary[geneSizeString] ?? 0
                let value = gene[key]?[i][valueString] ?? 0
                self.geneSizes.append(geneSize)
                self.geneValues.append(value)
            }
        }
        self.setValue(geneValues)
        self.updateSequence()
    }

    init(gene: [String: [[String: Int]]], chromosome: String) {
        self.init(gene: gene)

        var chromosome = chromosome
        for (index, size) in self.geneSizes.enumerated() {
            let value = Int(chromosome[..<chromosome.index(chromosome.startIndex, offsetBy: binaryDigit(n: size))], radix: 2)
            self.geneValues[index] = value ?? 0
            chromosome = String(chromosome.dropFirst(2))
        }
        self.setValue(self.geneValues)
    }

    public func serialization() -> Data? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self.gene, options: []) else {
            return nil
        }
        return jsonData
    }

    public mutating func setValue(_ value: [Int]) {
        var index = 0
        for (key, array) in self.gene {
            let valueString = GeneCodingKeys.value.stringValue
            for (i) in array.indices {
                self.gene[key]?[i][valueString] = value[index]
                index += 1
            }
        }
    }

    public mutating func randomize() {
        self.geneSequence.removeAll()
        for (_, array) in self.gene {
            let geneSizeString = GeneCodingKeys.geneSize.stringValue
            for (i, dictionary) in array.enumerated() {
                let rand = Int(arc4random_uniform(UInt32(dictionary[geneSizeString] ?? 0)))
                self.geneValues[i] = rand
            }
        }
        self.setValue(geneValues)
        self.updateSequence()
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

    private mutating func updateSequence() {
        self.geneSequence = []

        for i in 0..<self.geneValues.count {
            let value = self.geneValues[i]
            let geneSize = self.geneSizes[i]

            var binaryString = String(value, radix: 2)
            var shortage = binaryDigit(n: geneSize) - binaryString.count
            while shortage > 0 {
                shortage -= 1
                binaryString = "0" + binaryString
            }
            self.geneSequence.append(binaryString)
        }
    }

    private func binaryDigit(n: Int) -> Int {
        if n <= 1 { return n }

        var n = Double(n - 1)
        var digit = 0

        //swiftlint:disable control_statement
        while (n >= 1) {
            n /= 2
            digit += 1
        }
        return digit
    }
}
