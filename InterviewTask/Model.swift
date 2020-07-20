//
//  Model.swift
//  InterviewTask
//
//  Created by Admin on 18/07/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation


struct FactsResponse: Codable{
    let title: String?
    let rows: [Rows]
    
}

struct Rows: Codable {
    let title: String?
    let description: String?
    let imageHref: String?
    
}


