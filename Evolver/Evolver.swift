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
    public static var choice: Choiceable = Elite()
    public static var crossing: Crossingable = OnePointCrossover()
    public static var mutation: Mutationable = Substitution()

    public enum EvolverError: Error {
        case encodeError
        case decodeError
        case individualSizeError
    }

    public class func run<T: Generable>(template: T.Type, generations: Int, individuals: Int, completion: (_ model: T, _ generation: Int, _ individual: Int) -> Int) -> Result<T> {
        guard let dictionary = try? Evolver.checkTemplate(template: template) else {
            return .failure(EvolverError.encodeError)
        }

        var genoms = Evolver.createInitialIndividuals(template, dictionary: dictionary, individuals: individuals)

        // MARK: Unnecessary Evaluate if genom has only one gene
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

            let onlyTwo = (genoms.prefix(genoms.count/2).compactMap { $0 }.count == 2)
            var childs = genoms.count/2

            // MARK: Choice
            genoms = choice.choose(genoms: genoms)

            // MARK: Crossing & Mutation
            while childs > 0 {
                let pairA = Int(arc4random_uniform(UInt32(genoms.count)))
                var pairB = Int(arc4random_uniform(UInt32(genoms.count)))
                while pairA == pairB {
                    pairB = Int(arc4random_uniform(UInt32(genoms.count)))
                }

                let child = Evolver.createChildFrom(genomA: genoms[pairA], genomB: genoms[pairB])
                if onlyTwo {
                    genoms = genoms.prefix(1).compactMap { $0 }
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

    private class func createChildFrom<T: Generable>(genomA: Genom<T>, genomB: Genom<T>) -> Genom<T> {
        // MARK: Crossover
        var chromosome = crossing.crossover(chromosomeA: genomA.chromosome, chromosomeB: genomB.chromosome)

        // MARK: Mutation
        chromosome = mutation.mutate(chromosome: chromosome)

        let child = Genom<T>(gene: genomA.gene, chromosome: chromosome)

        return child
    }

    private class func checkTemplate<T: Generable>(template: T.Type) throws -> [String: [[String: Int]]] {
        let geneTemplate = template.init()

        let encoder = JSONEncoder()
        let data = try! encoder.encode(geneTemplate)
        guard let parameters = ((try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }) else {
            throw EvolverError.encodeError
        }

        var dictionary = [String: [[String: Int]]]()
        for child in Mirror(reflecting: geneTemplate).children {
            var array = [[String: Int]]()

            guard
                let label = child.label,
            let geneTypeArray = parameters[label] as? [[String: Int]] else {
                    throw EvolverError.encodeError
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

        return dictionary
    }

    private class func createInitialIndividuals<T: Generable>(_ : T.Type, dictionary: [String: [[String: Int]]], individuals: Int) -> [Genom<T>] {
        var genoms: [Genom<T>] = []

        for _ in 0 ..< individuals {
            var model = Genom<T>(gene: dictionary)
            model.randomize()
            genoms.append(model)
        }

        return genoms
    }
}
