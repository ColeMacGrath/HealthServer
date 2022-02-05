//
//  CreateUsers.swift
//  
//
//  Created by Moisés on 22/01/22.
//

import Fluent

struct CreateUsers: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema)
            .field("id", .uuid)
            .field("email", .string, .required)
            .unique(on: "email")
            .field("first_name", .string, .required)
            .field("last_name", .string)
            .field("gender", .string)
            .field("biological_sex", .string)
            .field("birth_date", .string)
            .field("password_hash", .string, .required)
            .field("created_at", .datetime, .required)
            .field("updated_at", .datetime, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema).delete()
    }
}
