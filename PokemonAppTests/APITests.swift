//
//  APITests.swift
//  PokemonAppTests
//
//  Created by Vladan Randjelovic on 10.5.24..
//

import XCTest
@testable import PokemonApp

final class APITests: XCTestCase {
    
    var apiService: PokemonAPIService!
    
    override func setUp() {
        super.setUp()
        apiService = PokemonAPIService()
    }
    
    override func tearDown() {
        apiService = nil
        super.tearDown()
    }
    
    func testGetPokemons() {
        
    }
}
