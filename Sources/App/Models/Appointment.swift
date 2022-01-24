//
//  Appointment.swift
//  
//
//  Created by Moisés on 24/01/22.
//

import Vapor
import Fluent

struct AppointmentData: Content {
    let doctor_id: UUID
    let user_id: UUID
    let doctor_notes: String
    let patient_notes: String
    let date: Date
}

final class Appointment: Model, Content {
    static let schema = "appointments"
    
    @ID(key: "id")
    var id: UUID?
    
    @Parent(key: "doctor_id")
    var doctor: Doctor
    
    @Parent(key: "user_id")
    var user: User
    
    @Field(key: "doctor_notes")
    var doctorNotes: String
    
    @Field(key: "patient_notes")
    var patientNotes: String
    
    @Field(key: "date")
    var date: Date
    
    init() {}
    
    init(id: UUID? = nil, userId: UUID, doctorId: UUID, doctorNotes: String, patientNotes: String, date: Date) {
        self.id = id
        self.$doctor.id = doctorId
        self.$user.id = userId
        self.doctorNotes = doctorNotes
        self.patientNotes = patientNotes
        self.date = date
    }
}

extension Appointment {
    static func create(from appointmentData: AppointmentData) throws -> Appointment {
        Appointment(userId: appointmentData.user_id, doctorId: appointmentData.doctor_id, doctorNotes: appointmentData.doctor_notes, patientNotes: appointmentData.patient_notes, date: appointmentData.date)
    }
}
