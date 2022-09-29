//
//  BusinessSearch.swift
//  City Sights
//
//  Created by Semih Cetin on 29.09.2022.
//

import Foundation


struct BusinessSearch: Decodable {
    
    var businesses = [Business]()
    var total = 0
    var region = Region()
    
    
}

struct Region: Decodable {
    
    var center = Coordinate()
    
}
