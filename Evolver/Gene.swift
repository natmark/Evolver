//
//  Gene.swift
//  Evolver
//
//  Created by AtsuyaSato on 2017/10/17.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation

public protocol GeneBase: Codable, Countable {
}

public enum Gene<T: GeneBase>: Codable {
    case template(T.Type, geneSize: Int)
    case result(T.Type, geneSize: Int, value: Int)
}

public enum GeneCodingKeys: String, CodingKey {
    case geneSize
    case value
}

extension Gene {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: GeneCodingKeys.self)
        switch self {
        case .template(_, let size):
            try container.encode(size, forKey: .geneSize)
        case .result:
            throw DecodeError.noRecognizedContent
        }
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: GeneCodingKeys.self)
        guard let geneSize = try? values.decode(Int.self, forKey: .geneSize) else{
            throw DecodeError.noRecognizedContent
        }
        guard let value = try? values.decode(Int.self, forKey: .value) else {
            throw DecodeError.noRecognizedContent
        }
        self = Gene.result(T.self, geneSize: geneSize, value: value)
    }

    public var value: T {
        switch self {
        case .template(_,_):
            return T(rawValue: 1)!
        case .result(_,_, let value):
            return T(rawValue: value)!
        }
    }

    public enum DecodeError: Error {
        case noRecognizedContent
    }
}
