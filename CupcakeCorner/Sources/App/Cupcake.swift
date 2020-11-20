//
//  Cupcake.swift
//  App
//
//  Created by Vlastimir on 30/04/2020.
//

import Vapor
import FluentSQLite
import Foundation

struct Cupcake: Content, SQLiteModel, Migration {
    
    typealias Database = SQLiteDatabase
    
    var id: Int?
    var name: String
    var description: String
    var price: Int
}
