//
//  File.swift
//  
//
//  Created by Moisés on 23/01/22.
//

import Fluent

struct CreateHealthRecords: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(HealthRecord.schema)
            .field("id", .uuid)
            .field("user_id", .uuid, .required)
            .field("date", .datetime, .required)
            .field("total", .double, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(HealthRecord.schema).delete()
    }
}
