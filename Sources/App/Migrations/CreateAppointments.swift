//
//  CreateAppointments.swift
//  
//
//  Created by Moisés on 24/01/22.
//

import Fluent

struct CreateAppointments: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Appointment.schema)
            .field("id", .uuid)
            .field("doctor_id", .uuid)
            .field("user_id", .uuid)
            .field("doctor_notes", .string)
            .field("patient_notes", .string)
            .field("date", .date)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Schedule.schema).delete()
    }
}
