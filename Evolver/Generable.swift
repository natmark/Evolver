//
//  Generable.swift
//  Evolver
//
//  Created by AtsuyaSato on 2017/10/15.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation

public protocol Generable {
    init()
}

public enum GeneType <T: Countable>{
    case gene(Int)
    case array(Int, Int)
    case enums(T.Type, Int)
}

open class GenomObject: NSObject {
    public required override init(){

    }
}
