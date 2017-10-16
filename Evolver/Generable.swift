//
//  Generable.swift
//  Evolver
//
//  Created by AtsuyaSato on 2017/10/15.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation

public protocol Generable: Decodable {
    init()
}

public protocol GeneBase: Decodable, Countable {
}

public enum GeneType<T: GeneBase>: Decodable {
    case geneType(T.Type, geneSize: Int)
    case gene(geneSize: Int)

    private enum CodingKeys: String, CodingKey {
        case geneType
        case gene
    }

    enum PostTypeCodingError: Error {
        case decoding(String)
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? values.decode(Int.self, forKey: .gene) {
            self = .gene(geneSize: value)
            return
        }

        if let value = try? values.decode(Int.self, forKey: .geneType) {
            self = GeneType.geneType(T.self, geneSize: value)
            return
        }

        throw DecodeError.noRecognizedContent
    }

    enum DecodeError: Error {
        case noRecognizedContent
    }
}

