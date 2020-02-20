//
//  CreateCodable.swift
//  assignment
//
//  Created by YR on 2/20/20.
//  Copyright © 2020 Fretello. All rights reserved.
//


struct PagedCharacters: Codable {
    let info: Info
    let results: [Results]
}

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String
    let prev: String
}

struct Results: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let origin: [String: String]
    
    let type: String
    let location: [String: String]
    
    let image: String
}
