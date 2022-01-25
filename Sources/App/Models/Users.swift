//
//  Users.swift
//  
//
//  Created by Moisés on 22/01/22.
//

import Fluent
import Vapor

final class User: Model {
    struct Public: Content {
        let id: UUID
        let email: String
        let firstName: String
        let biologicalSex: String?
        let birtdDate: Date?
        let lastName: String?
        let age: Int?
        let createdAt: Date?
        let updatedAt: Date?
    }
    
    static let schema = "users"
    
    @ID(key: "id")
    var id: UUID?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "first_name")
    var firstName: String
    
    @Field(key: "last_name")
    var lastName: String?
    
    @Field(key: "age")
    var age: Int?
    
    @Field(key: "password_hash")
    var passwordHash: String
    
    @Field(key: "biological_sex")
    var biologicalSex: String?
    
    @Field(key: "birth_date")
    var birthDate: Date?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(id: UUID? = nil, email: String, firstName: String, lastName: String? = nil, biologicalSex: String? = nil, birthDate: Date? = nil, age: Int? = nil, passwordHash: String) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.passwordHash = passwordHash
        self.biologicalSex = biologicalSex
        self.birthDate = birthDate
    }
}

extension User {
    static func create(from userSignup: UserSignup) throws -> User {
        User(email: userSignup.email, firstName: userSignup.firstName, lastName: userSignup.lastName, passwordHash: try Bcrypt.hash(userSignup.password))
    }
    
    func createToken(source: SessionSource) throws -> Token {
        let calendar = Calendar(identifier: .gregorian)
        let expiryDate = calendar.date(byAdding: .year, value: 1, to: Date())
        return try Token(userId: requireID(),
                         token: [UInt8].random(count: 16).base64, source: source, expiresAt: expiryDate)
    }
    
    func asPublic() throws -> Public {
        Public(id: try requireID(), email: email, firstName: firstName, biologicalSex: biologicalSex, birtdDate: birthDate, lastName: lastName, age: age, createdAt: createdAt, updatedAt: updatedAt)
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$passwordHash
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}
