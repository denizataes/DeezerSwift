//
//  Utils.swift
//  Homework2
//
//  Created by Deniz Ata Eş on 30.12.2022.
//

import Foundation

class Utils{
    static let shared = Utils()
    
    ///Convert string to datetime. format: Month Year
    func convertDate(dateString: String?) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-DD"
        let date = dateFormatter.date(from: dateString!)
        dateFormatter.dateFormat = "yyyy"
        let monthAndYear = dateFormatter.string(from: date!)
        return monthAndYear
        
    }
}


