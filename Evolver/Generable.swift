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

public enum Genom<T: GeneBase>: Codable {
    case template(T.Type, geneSize: Int)
    case result(T.Type, geneSize: Int, value: Int)
}

extension Genom {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .template(_, let size):
            try container.encode(size, forKey: .geneType)
        case .result:
            throw DecodeError.noRecognizedContent
        }
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        guard let geneSize = try? values.decode(Int.self, forKey: .geneSize) else{
            throw DecodeError.noRecognizedContent
        }
        guard let value = try? values.decode(Int.self, forKey: .value) else {
            throw DecodeError.noRecognizedContent
        }
        self = Genom.result(T.self, geneSize: geneSize, value: value)
    }

    private enum CodingKeys: String, CodingKey {
        case geneType
        case geneSize
        case value
    }

    public var value: T {
        switch self {
        case .template(_,_):
            return T(rawValue: 1)!
        case .result(_,_, let value):
            return T(rawValue: value)!
        }
    }

    enum DecodeError: Error {
        case noRecognizedContent
    }
}
