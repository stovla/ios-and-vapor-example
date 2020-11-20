//
//  Order.swift
//  App
//
//  Created by Vlastimir on 01/05/2020.
//

import Foundation
import FluentSQLite
import Vapor

struct Order: Content, SQLiteModel, Migration {
    
    typealias Database = SQLiteDatabase
    
    var id: Int?
    var cakeName: String
    var buyerName: String
    var date: Date?
}
