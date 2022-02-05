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
    let initial_date: Date
    let finish_date: Date
    let total: Double
    let identifier: String
    let description: String?
}

struct UserId: Content {
    let user_id: UUID
}

final class HealthRecord: Model, Content {
    static let schema = "healthRecord"
    
    @ID(key: "id")
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Field(key: "initial_date")
    var initialDate: Date
    
    @Field(key: "finish_date")
    var finishDate: Date
    
    @Field(key: "description")
    var description: String?
    
    @Field(key: "identifier")
    var identifier: String
    
    @Field(key: "total")
    var total: Double
    
    init() {}
    
    init(id: UUID? = nil, userId: User.IDValue, initialDate: Date, finishDate: Date, total: Double, identifier: String, description: String?) {
        self.id = id
        self.$user.id = userId
        self.initialDate = initialDate
        self.finishDate = finishDate
        self.description = description
        self.identifier = identifier
        self.total = total
    }
}

extension HealthRecord {
    static func create(from recordData: HealthRecordData) throws -> HealthRecord {
        HealthRecord(userId: recordData.user_id, initialDate: recordData.initial_date, finishDate: recordData.finish_date, total: recordData.total, identifier: recordData.identifier, description: recordData.description)
    }
}
