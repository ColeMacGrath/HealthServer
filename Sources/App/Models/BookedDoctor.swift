//
//  BookedDoctor.swift
//  
//
//  Created by Moisés on 08/02/22.
//

import Vapor
import Fluent

struct BookDoctor: Content {
    let user_id: UUID
    let doctor_id: UUID
}

final class BookedDoctor: Model, Content {
    static let schema = "booked_doctors"
    
    @ID(key: "id")
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "doctor_id")
    var doctor: Doctor
    
    init() {}
    
    init(id: UUID? = nil, userId: UUID, doctorId: UUID) {
        self.id = id
        self.$user.id = userId
        self.$doctor.id = doctorId
    }
}

extension BookedDoctor {
    static func create(from bookDoctor: BookDoctor) throws -> BookedDoctor {
        BookedDoctor(userId: bookDoctor.user_id, doctorId: bookDoctor.doctor_id)
    }
}
