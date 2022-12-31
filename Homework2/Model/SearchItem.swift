//
//  SearchItem.swift
//  Homework2
//
//  Created by Deniz Ata Eş on 31.12.2022.
//

import Foundation

struct SearchItems: Codable{
    let data: [SearchItem]?
    let total: Int?
    let next: String?
}


struct SearchItem: Codable{
    let id: Int
    let title: String
    let cover_xl: String
}
