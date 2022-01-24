//
//  HealthRecordController.swift
//  
//
//  Created by Moisés on 23/01/22.
//

import Vapor
import Fluent

struct HealthRecordController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let healthRecordRoute = routes.grouped("records")
        healthRecordRoute.get("getAll", use: getAllRecords)
        healthRecordRoute.post("create", use: create)
        healthRecordRoute.post("createMultiple", use: createMultipleRecords)
        healthRecordRoute.post("getFor", use: getAllRecordsFor)
    }
    
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let healthRecordData = try req.content.decode(HealthRecordData.self)
        let healthRecord = try HealthRecord.create(from: healthRecordData)
        return UserController().checkIfUserExistsBy(id: healthRecordData.user_id, req: req).flatMap { exists in
            guard exists else {  return req.eventLoop.future(error: Abort(.notFound)) }
            return healthRecord.save(on: req.db).transform(to: HTTPResponseStatus.created)
        }
    }
    
    func createMultipleRecords(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let healthRecordData = try req.content.decode([HealthRecordData].self).map({ record -> HealthRecord in
            return try HealthRecord.create(from: record)
        })
        return healthRecordData.create(on: req.db).transform(to: HTTPStatus.created)
    }
    
    func getAllRecords(_ req: Request) throws -> EventLoopFuture<[HealthRecord]> {
        return HealthRecord.query(on: req.db).all()
    }
    
    func getAllRecordsFor(_ req: Request) throws -> EventLoopFuture<[HealthRecord]> {
        let userId = try req.content.decode(UserId.self).user_id
        let healthRecords = HealthRecord.query(on: req.db).all().map { records in
            records.filter({ $0.$user.id == userId })
        }
        
        return healthRecords
    }
}
