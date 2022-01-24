//
//  CreateSchedules.swift
//  
//
//  Created by Moisés on 24/01/22.
//

import Fluent

struct CreateSchedules: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Schedule.schema)
            .field("id", .uuid)
            .field("doctor_id", .uuid)
            .field("day", .int)
            .field("hours", .array(of: .int))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Schedule.schema).delete()
    }
}
