//
//  Genom.swift
//  Evolver
//
//  Created by AtsuyaSato on 2017/10/17.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation

public struct Genom<T: Generable> {
    private var geneSizes: [Int] = []
    private var geneSequence: [String] = []
    private var geneValues: [Int] = []
    var gene: [String: Array<[String: Int]>]
    var score: Int = 0
    var mutationRate: Float = 0.05

    var chromosome: String {
        get {
            return self.geneSequence.joined()
        }
    }

    init(gene: [String : Array<[String : Int]>]) {
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
            for (i, _) in array.enumerated() {
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

    private mutating func updateSequence() {
        self.geneSequence = []

        for i in 0..<self.geneValues.count {
            let value = self.geneValues[i]
            let geneSize = self.geneSizes[i]

            var binaryString = String(value, radix:2)
            var shortage = GenomEngine.binaryDigit(n: geneSize) - binaryString.count
            while shortage > 0 {
                shortage -= 1
                binaryString = "0" + binaryString
            }
            self.geneSequence.append(binaryString)
        }
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

    public static func crossover(genomA: Genom, genomB: Genom) -> Genom {
        var chromosome = GenomEngine.onePointCrossover(
            chromosomeA: genomA.chromosome,
            chromosomeB: genomB.chromosome,
            point: Int(arc4random_uniform(UInt32(genomA.chromosome.count)))
        )
        // MARK: Mutation
        chromosome = Genom.mutation(chromosome: chromosome, mutationRate: genomA.mutationRate)

        var child = Genom(gene: genomA.gene)

        for (index, size)  in child.geneSizes.enumerated() {
            let value = Int(chromosome[..<chromosome.index(chromosome.startIndex, offsetBy: GenomEngine.binaryDigit(n: size))], radix: 2)
            child.geneValues[index] = value ?? 0
            chromosome = String(chromosome.dropFirst(2))
        }
        child.setValue(child.geneValues)
        return child
    }

    public static func mutation(chromosome: String, mutationRate: Float) -> String {
        return GenomEngine.mutation(chromosome: chromosome, mutationRate: mutationRate)
    }
}

public class GenomEngine {
    public class func mutation(chromosome: String, mutationRate: Float) -> String {
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

    public class func onePointCrossover(chromosomeA: String, chromosomeB: String, point: Int) -> String {
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
