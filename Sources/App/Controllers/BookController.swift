//
//  BookController.swift
//  flatiron-teacher-assistant
//
//  Created by Johann Kerr on 11/16/16.
//
//

import Foundation
import Vapor
import HTTP

final class BookController:ResourceRepresentable{
    

    func index(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: Book.all().makeNode())
    }
    
    func makeResource() -> Resource<Book> {
        return Resource(
            index: index
        )
    }

}

extension Request {
    func book() throws -> Book {
        guard let json = json else { throw Abort.badRequest }
        return try Book(node: json)
    }
}
