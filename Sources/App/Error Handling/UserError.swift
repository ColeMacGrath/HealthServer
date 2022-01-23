//
//  UserError.swift
//  
//
//  Created by Moisés on 23/01/22.
//


import Vapor

enum UserError {
  case emailTaken
}

extension UserError: AbortError {
  var description: String {
    reason
  }

  var status: HTTPResponseStatus {
    switch self {
    case .emailTaken: return .conflict
    }
  }

  var reason: String {
    switch self {
    case .emailTaken: return "Email already taken"
    }
  }
}

