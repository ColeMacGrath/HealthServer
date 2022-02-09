//
//  CreateBookedDoctors.swift
//  
//
//  Created by Moisés on 08/02/22.
//

import Fluent

struct CreateBookedDoctors: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(BookedDoctor.schema)
            .field("id", .uuid)
            .field("user_id", .uuid, .required)
            .field("doctor_id", .uuid, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(BookedDoctor.schema).delete()
    }
}
