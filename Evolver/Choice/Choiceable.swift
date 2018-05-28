//
//  Choice.swift
//  Evolver
//
//  Created by AtsuyaSato on 2018/05/27.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

public protocol Choiceable {
    func choose<T: Generable>(genoms: [Genom<T>]) -> [Genom<T>]
}
