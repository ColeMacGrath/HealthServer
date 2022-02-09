//
//  BookedDoctorsController.swift
//  
//
//  Created by Moisés on 08/02/22.
//

import Vapor
import Fluent

struct BookedDoctorsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let bookedDoctorsRoute = routes.grouped("book")
        bookedDoctorsRoute.post("create", use: bookDoctor)
        bookedDoctorsRoute.post("get", use: getDoctors)
        bookedDoctorsRoute.delete("delete", use: deleteDoctor)
        
    }
    
    func bookDoctor(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let bookDoctorData = try req.content.decode(BookDoctor.self)
        let bookedDoctor = try BookedDoctor.create(from: bookDoctorData)
        
        return DoctorsController().checkIfDoctorExistsBy(id: bookDoctorData.doctor_id, req: req).flatMap { exists in
            guard exists else { return req.eventLoop.future(error: Abort(.notFound)) }
            
            return UserController().checkIfUserExistsBy(id: bookDoctorData.user_id, req: req).flatMap { exists in
                guard exists else { return req.eventLoop.future(error: Abort(.notFound)) }
                
                return self.checkIfRelationshipExists(userId: bookDoctorData.user_id, doctorId: bookDoctorData.doctor_id, req: req).flatMap { exists in
                    guard !exists else { return req.eventLoop.future(error: Abort(.conflict)) }
                    
                    return bookedDoctor.save(on: req.db).transform(to: HTTPResponseStatus.created)
                }
            }
        }
    }
    
    func getDoctors(_ req: Request) throws -> EventLoopFuture<[Doctor]> {
        let userId = try req.content.decode(UserId.self).user_id
        return Doctor.query(on: req.db)
            .join(BookedDoctor.self, on: \Doctor.$user.$id == \BookedDoctor.$doctor.$id)
            .filter(BookedDoctor.self, \.$user.$id == userId)
            .all()
    }
    
    func deleteDoctor(_ req: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
        let relationshipToDelete = try req.content.decode(DoctorId.self)
        guard let userId = relationshipToDelete.user_id else { return req.eventLoop.future(error: Abort(.badRequest)) }
        
        return BookedDoctor.query(on: req.db)
            .filter(BookedDoctor.self, \.$user.$id == userId)
            .filter(BookedDoctor.self, \.$doctor.$id == relationshipToDelete.doctor_id)
            .first()
            .unwrap(or: Abort(.notFound))
            .map({ $0.delete(on: req.db) }).transform(to: HTTPResponseStatus.ok)
    }
    
    private func checkIfRelationshipExists(userId: UUID, doctorId: UUID, req: Request) -> EventLoopFuture<Bool> {
        return BookedDoctor.query(on: req.db)
            .filter(\.$doctor.$id == doctorId)
            .filter(\.$user.$id == userId)
            .first()
            .map{ $0 != nil }
    }
    
}
