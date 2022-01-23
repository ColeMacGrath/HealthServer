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
      .field("id", .uuid, .identifier(auto: true))
      .field("email", .string, .required)
      .unique(on: "email")
      .field("firstName", .string, .required)
      .field("lastName", .string)
      .field("gender", .string)
      .field("age", .string)
      .field("password_hash", .string, .required)
      .field("created_at", .datetime, .required)
      .field("updated_at", .datetime, .required)
      .create()
  }

  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(User.schema).delete()
  }
}
