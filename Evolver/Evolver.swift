//
//  Evolver.swift
//  Evolver
//
//  Created by AtsuyaSato on 2017/10/15.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)
}

public class Evolver {
    public class func run<T: Generable>(template: T.Type, generations: Int, individuals: Int, completion: (_ model: T, _ generation: Int, _ individual: Int) -> Int) -> Result<T> {

        // MARK: Check template
        let geneTemplate = template.init()

        let encoder = JSONEncoder()
        let data = try! encoder.encode(geneTemplate)
        guard let parameters = ((try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }) else {
            return .failure(EvolverError.encodeError)
        }

        var dictionary = [String: Array<[String : Int]>]()
        for child in Mirror(reflecting: geneTemplate).children {
            var array = [Dictionary<String, Int>]()

            guard
                let label = child.label,
                let geneTypeArray = parameters[label] as? Array<Dictionary<String, Int>> else {
                    return .failure(EvolverError.encodeError)
            }
            let geneSize = GeneCodingKeys.geneSize.stringValue
            let value = GeneCodingKeys.value.stringValue

            for dictionary in geneTypeArray {
                array.append(
                    [
                        geneSize: dictionary[geneSize] ?? 0,
                        value: 0
                    ]
                )
            }
            dictionary[label] = array
        }

        var genoms: [Genom<T>] = []

        // MARK: Create initial individuals
        for _ in 0..<individuals {
            var model = Genom<T>(gene: dictionary)
            model.randomize()
            genoms.append(model)
        }

        if individuals == 1 {
            guard let gene = genoms[0].decode() else {
                return .failure(EvolverError.decodeError)
            }
            return .success(gene)
        }

        for generation in 0..<generations {
            // MARK: Evaluate
            for id in 0..<individuals {
                guard let gene = genoms[id].decode() else {
                    return .failure(EvolverError.decodeError)
                }
                genoms[id].score = completion(gene, generation, id)
            }
            // MARK: Sort
            genoms.sort { $1.score < $0.score }

            var onlyTwo = false
            var childs = genoms.count/2

            // MARK: Select
            if genoms.count > 2 {
                genoms = genoms.prefix(genoms.count/2).flatMap { $0 }
            } else if genoms.count == 2 {
                onlyTwo = true
            }

            // MARK: Crossover & Mutation
            while childs > 0 {
                let pairA = Int(arc4random_uniform(UInt32(genoms.count)))
                var pairB = Int(arc4random_uniform(UInt32(genoms.count)))
                while pairA == pairB {
                    pairB = Int(arc4random_uniform(UInt32(genoms.count)))
                }
                let child = Genom.crossover(genomA: genoms[pairA], genomB: genoms[pairB])
                if onlyTwo {
                    genoms = genoms.prefix(1).flatMap { $0 }
                }
                genoms.append(child)
                childs -= 1
            }
        }

        guard let gene = genoms[0].decode() else {
            return .failure(EvolverError.decodeError)
        }

        return .success(gene)
    }

    enum EvolverError: Error {
        case encodeError
        case decodeError
        case individualSizeError
    }
}
