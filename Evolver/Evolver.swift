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
    public class func run<T: Generable>(template: T.Type, generations: Int, individuals: Int, completion: (_ model: T,_ generation: Int) -> Int) -> Result<T> {

        // MARK: check template
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

        var model = Genom<T>(gene: dictionary)
        model.randomize()

        guard let gene = model.decode() else {
            return .failure(EvolverError.decodeError)
        }

        return .success(gene)
    }

    enum EvolverError: Error {
        case encodeError
        case decodeError
    }
}
