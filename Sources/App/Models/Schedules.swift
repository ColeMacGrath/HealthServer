//
//  Schedules.swift
//  
//
//  Created by Moisés on 23/01/22.
//

import Vapor
import Fluent

struct ScheduleData: Content {
    let doctor_id: UUID
    let day: Int
    let hours: [Int]
}

final class Schedule: Model {
    static let schema = "schedules"
    
    @ID(key: "id")
    var id: UUID?
    
    @Parent(key: "doctor_id")
    var doctor: Doctor
    
    @Field(key: "day")
    var day: Int
    
    @Field(key: "hours")
    var hours: [Int]
    
    init() {}
    
    init(id: UUID? = nil, doctorId: Doctor.IDValue, day: Int, hours: [Int]) {
        self.id = id
        self.$doctor.id = doctorId
        self.day = day
        self.hours = hours
    }
}

extension Schedule {
    static func create(from scheduleData: ScheduleData) throws -> Schedule {
        Schedule(doctorId: scheduleData.doctor_id, day: scheduleData.day, hours: scheduleData.hours)
    }
}
