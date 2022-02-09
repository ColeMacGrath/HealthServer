//
//  UserController.swift
//  
//
//  Created by Moisés on 22/01/22.
//

import Vapor
import Fluent
import PostgresNIO
import Foundation

struct UserSignup: Content {
    let email: String
    let firstName: String
    let lastName: String?
    let password: String
}

struct NewSession: Content {
    let token: String
    let user: User.Public
}

struct UserBasicInfo: Content {
    let user_id: UUID
    let email: String?
    let first_name: String?
    let last_name: String?
    let biological_sex: String?
    let birth_date: String?
}

extension UserSignup: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: !.empty)
        validations.add("password", as: String.self, is: .count(6...))
    }
}

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("users")
        usersRoute.post("signup", use: create)
        
        let tokenProtected = usersRoute.grouped(Token.authenticator())
        tokenProtected.get("getUser", use: getMyOwnUser)
        
        let passwordProtected = usersRoute.grouped(User.authenticator())
        passwordProtected.post("login", use: login)
        
        usersRoute.patch("updateUser", use: updateUser)
    }
    
    fileprivate func create(req: Request) throws -> EventLoopFuture<NewSession> {
        try UserSignup.validate(content: req)
        let userSignup = try req.content.decode(UserSignup.self)
        let user = try User.create(from: userSignup)
        var token: Token!
        
        return checkIfUserExists(userSignup.email, req: req).flatMap { exists in
            guard !exists else {
                return req.eventLoop.future(error: UserError.emailTaken)
            }
            return user.save(on: req.db)
        }.flatMap {
            guard let newToken = try? user.createToken(source: .signup) else {
                return req.eventLoop.future(error: Abort(.internalServerError))
            }
            token = newToken
            return token.save(on: req.db)
        }.flatMapThrowing {
            NewSession(token: token.value, user: try user.asPublic())
        }
    }
    
    fileprivate func login(req: Request) throws -> EventLoopFuture<NewSession> {
        let user = try req.auth.require(User.self)
        let token = try user.createToken(source: .login)
        
        return token.save(on: req.db).flatMapThrowing {
            NewSession(token: token.value, user: try user.asPublic())
        }
    }
    
    func getMyOwnUser(req: Request) throws -> User.Public {
        try req.auth.require(User.self).asPublic()
    }
    
    private func checkIfUserExists(_ email: String, req: Request) -> EventLoopFuture<Bool> {
        User.query(on: req.db)
            .filter(\.$email == email)
            .first()
            .map { $0 != nil }
    }
    
    func checkIfUserExistsBy(id: UUID, req: Request) -> EventLoopFuture<Bool> {
        User.query(on: req.db)
            .filter(\.$id == id)
            .first()
            .map { $0 != nil }
    }
    
    func updateUser(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let userToUpdate = try req.content.decode(UserBasicInfo.self)
        
        
        return User.query(on: req.db)
            .filter(\.$id == userToUpdate.user_id)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                
                if let name = userToUpdate.first_name {
                    user.firstName = name
                }
                
                if let lastName = userToUpdate.last_name {
                    user.lastName = lastName
                }
                
                if let biologicalSex = userToUpdate.biological_sex {
                    user.biologicalSex = biologicalSex
                }
                
                if let email = userToUpdate.email {
                    user.email = email
                }
                
                if let birthDate = userToUpdate.birth_date {
                    let isoDateFormatter = ISO8601DateFormatter()
                    isoDateFormatter.timeZone = TimeZone(secondsFromGMT: .zero)
                    isoDateFormatter.formatOptions = [
                        .withFullDate,
                        .withFullTime,
                        .withDashSeparatorInDate]
                    
                    if let date = isoDateFormatter.date(from: birthDate) {
                        user.birthDate = date
                        user.updatedAt = Date()
                    } else {
                        return req.eventLoop.future(error: Abort(.badRequest))
                    }
                }
                
                return user.update(on: req.db).map { User.self }.transform(to: HTTPStatus.ok)
            }
    }
    
    
    
    //func addDoctor(_ req: Request) throws -> EventLoopFuture<Doctor> {
    //
    //}
    
}
