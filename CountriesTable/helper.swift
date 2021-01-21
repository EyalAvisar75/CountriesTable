//
//  helper.swift
//  CountriesTable
//
//  Created by eyal avisar on 19/01/2021.
//

import Foundation

struct Country:CustomStringConvertible {
    var description:String {return "\(name), \(nativeName), \(area), \(borders)"}
    
    let name:String
    let nativeName:String
    let area:Double
    let borders:[String]
    var code: String
}
