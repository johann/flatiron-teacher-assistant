//
//  Blog.swift
//  flatiron-teacher-assistant
//
//  Created by Johann Kerr on 11/20/16.
//
//

import Vapor
import Foundation
import Fluent
import Foundation


final class Blog: Model{
    var id: Node?
    var exists: Bool = false
    var link: String
    var user: String
    
    
    init(link:String, user: String){
        self.id = nil
        self.link = link
        self.user = user
    }
    
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        link = try node.extract("link")
        user = try node.extract("user")
    }
    
    func makeNode(context: Context) throws -> Node {
        
        return try Node(node: [
            "id":id,
            "link": link,
            "user": user
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("blogs"){ books in
            books.id()
            books.string("link")
            books.string("user")
        }
    }
    
    static func revert(_ database: Database) throws{
        try database.delete("blogs")
    }
    
    
    
}
