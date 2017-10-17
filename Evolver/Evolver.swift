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
    public class func run<T: Generable>(geneType: T.Type, max generation: Int, per size: Int, completion: (_ model: T,_ generation: Int) -> Int) -> Result<T> {

        // MARK: check template
        let geneTemplate = geneType.init()

        let encoder = JSONEncoder()
        let data = try! encoder.encode(geneTemplate)
        guard let parameters = ((try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }) else {
            return .failure(EvolverError.encodeError)
        }

        for child in Mirror(reflecting: geneTemplate).children {
            guard
                let label = child.label,
                let geneTypeArray = parameters[label] as? Array<Dictionary<String, Int>> else {
                    return .failure(EvolverError.encodeError)
            }
            let count = geneTypeArray.count

            print(label, count)
            for dictionary in geneTypeArray {
                print(dictionary["geneType"]!)
            }
        }

        // MARK: generate model
        let decoder = JSONDecoder()

        var dict = [String: Any]()
        var array = [Dictionary<String, Int>]()
        array.append(["geneType": 2])
        dict["direction"] = array

        let jsonString =
"""
{
    \"direction\": [
        {
        \"geneType\" : \(1)
        }
    ],
    \"compass\": [
        {
        \"geneType\" : \(2)
        },
        {
        \"geneType\" : \(1)
        },
        {
        \"geneType\" : \(1)
        },
        {
        \"geneType\" : \(1)
        },
        {
        \"geneType\" : \(1)
        }
    ]
}
"""

        let jsonData = jsonString.data(using: .utf8)!
        let gene = try! decoder.decode(T.self, from: jsonData)
        let mirror = Mirror(reflecting: gene)
        for child in mirror.children {
            print(child.label!)
            print(child.value)
        }

//        do {
//            obj = try decoder.decode(T.self, from: jsonData)
//        } catch {
//            print("json convert failed in JSONDecoder", error.localizedDescription)
//        }
//        seed.setValue(3, forKey: child.label!)
//        seed.value(forKey: "direction")
        return .success(gene)
    }

    enum EvolverError: Error {
        case encodeError
    }
}
