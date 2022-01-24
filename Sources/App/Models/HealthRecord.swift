//
//  HealthRecord.swift
//  
//
//  Created by Moisés on 23/01/22.
//

import Vapor
import Fluent

struct HealthRecordData: Content {
    let user_id: UUID
    let date: Date
    let total: Double
}

struct UserId: Content {
    let user_id: UUID
}

final class HealthRecord: Model, Content {
    static let schema = "HealthRecord"
    
    @ID(key: "id")
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Field(key: "date")
    var date: Date
    
    @Field(key: "total")
    var total: Double
    
    init() {}
    
    init(id: UUID? = nil, userId: User.IDValue, date: Date, total: Double) {
        self.id = id
        self.$user.id = userId
        self.date = date
        self.total = total
    }
}

extension HealthRecord {
    static func create(from recordData: HealthRecordData) throws -> HealthRecord {
        HealthRecord(userId: recordData.user_id, date: recordData.date, total: recordData.total)
    }
}
