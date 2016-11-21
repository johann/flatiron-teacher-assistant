//
//  Book.swift
//  flatiron-teacher-assistant
//
//  Created by Johann Kerr on 11/15/16.
//
//


import Vapor
import Foundation
import Fluent
import Foundation



final class Blog: Model{
    var id: Node?
    var exists: Bool = false
    
    
    
    var link:String
    var username:String
    
    init(link:String, username:String){
        self.id = nil
        self.link = link
        self.username = username
    }
    
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        link = try node.extract("link")
        username = try node.extract("username")
        
        //id = try node.extract("id")
        
        //imgUrl = try node.extract("imgUrl")
    }
    
    func makeNode(context: Context) throws -> Node {
        
        return try Node(node: [
            "id":id,
            "link": link,
            "username": username
        ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("blogs"){ blogs in
            blogs.id()
            blogs.string("link")
            blogs.string("username")
            
            
        }
    }
    
    static func revert(_ database: Database) throws{
        try database.delete("blogs")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
