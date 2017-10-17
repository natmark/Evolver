//
//  Generable.swift
//  Evolver
//
//  Created by AtsuyaSato on 2017/10/15.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation

public protocol Generable: Codable {
    init()
}

public protocol GeneBase: Codable, Countable {
}

public enum GeneType<T: GeneBase>: Codable {
    case geneType(T.Type, geneSize: Int)
}

extension GeneType {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .geneType(_, let size):
            try container.encode(size, forKey: .geneType)
        }
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? values.decode(Int.self, forKey: .geneType) {
            self = GeneType.geneType(T.self, geneSize: value)
            return
        }

        throw DecodeError.noRecognizedContent
    }

    private enum CodingKeys: String, CodingKey {
        case geneType
    }

    public var value: T {
        switch self {
        case .geneType(_, let size):
            return T(rawValue: size)!
        }
    }

    enum DecodeError: Error {
        case noRecognizedContent
    }
}
