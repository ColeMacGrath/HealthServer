//
//  Doctors.swift
//  
//
//  Created by Moisés on 23/01/22.
//

import Vapor
import Fluent

struct DoctorData: Content {
    let user_id: UUID
    let specialization: String?
    let about: String?
    let address: String?
    let coordinates: String?
}

struct DoctorId: Content {
    let doctor_id: UUID
}

final class Doctor: Model, Content {
    static let schema = "doctors"
    
    @ID(key: "id")
    var id: UUID?
    
    @Parent(key: "user_id")
    var user: User
    
    @Field(key: "specialization")
    var specialization: String?
    
    @Field(key: "about")
    var about: String?

    @Field(key: "address")
    var address: String?

    @Field(key: "coordinates")
    var coordinates: String?
    
    init() {}
    
    init(id: UUID? = nil, userId: UUID, specialization: String? = nil, about: String? = nil, address: String? = nil, coordinates: String? = nil) {
        self.id = id
        self.$user.id = userId
        self.specialization = specialization
        self.about = about
        self.address = address
        self.coordinates = coordinates
    }
    
}

extension Doctor {
    static func create(from doctorData: DoctorData) throws -> Doctor {
        Doctor(userId: doctorData.user_id, specialization: doctorData.specialization, about: doctorData.about, address: doctorData.address, coordinates: doctorData.coordinates)
    }
}
