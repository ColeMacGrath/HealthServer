//
//  CreateDoctors.swift
//  
//
//  Created by Moisés on 24/01/22.
//

import Fluent

struct CreateDoctors: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Doctor.schema)
            .field("id", .uuid)
            .field("user_id", .uuid, .required)
            .field("specialization", .string)
            .field("about", .string)
            .field("address", .string)
            .field("coordinates", .string)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Doctor.schema).delete()
    }
}
