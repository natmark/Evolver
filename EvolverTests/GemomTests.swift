//
//  GemomTests.swift
//  EvolverTests
//
//  Created by AtsuyaSato on 2017/10/17.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import XCTest
@testable import Evolver

class GemomTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBinaryDigit() {
        XCTAssertEqual(GenomEngine.binaryDigit(n: 0), 0)
        XCTAssertEqual(GenomEngine.binaryDigit(n: 1), 1)
        XCTAssertEqual(GenomEngine.binaryDigit(n: 2), 1)
        XCTAssertEqual(GenomEngine.binaryDigit(n: 3), 2)
        XCTAssertEqual(GenomEngine.binaryDigit(n: 4), 2)
        XCTAssertEqual(GenomEngine.binaryDigit(n: 5), 3)
        XCTAssertEqual(GenomEngine.binaryDigit(n: 16), 4)
        XCTAssertEqual(GenomEngine.binaryDigit(n: 17), 5)
        XCTAssertEqual(GenomEngine.binaryDigit(n: 32), 5)
        XCTAssertEqual(GenomEngine.binaryDigit(n: 33), 6)
        XCTAssertEqual(GenomEngine.binaryDigit(n: 64), 6)
        XCTAssertEqual(GenomEngine.binaryDigit(n: 65), 7)
    }

    func testOnePointCrossover() {
        XCTAssertEqual(
            GenomEngine.onePointCrossover(
                chromosomeA: "01110",
                chromosomeB: "11001",
                point: 3
            ),
            "01101"
        )
        XCTAssertEqual(
            GenomEngine.onePointCrossover(
                chromosomeA: "01110101",
                chromosomeB: "11001010",
                point: 0
            ),
            "11001010"
        )
        XCTAssertEqual(
            GenomEngine.onePointCrossover(
                chromosomeA: "01",
                chromosomeB: "11",
                point: 2
            ),
            "01"
        )
    }
}
