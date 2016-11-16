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

final class Book: Model{
    var id: Node?
    var exists: Bool = false
    var title:String
    var isbn:String
    var imgUrl:String
    
    init(title:String, isbn:String,imgUrl:String){
        ///self.id = UUID().uuidString.makeNode()
//        do{
//            self.id =  try Int(arc4random_uniform(3000)).makeNode()
//        }catch{
//            print("erro")
//        }
        
       // self.id = .number(.int(Int(arc4random_uniform(3000))))
        self.id = nil
        self.title = title
        self.isbn = isbn
        self.imgUrl = imgUrl
    }
    
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        title = try node.extract("title")
        isbn = try node.extract("isbn")
        imgUrl = try node.extract("imgurl")
        id = try node.extract("id")
        
        //imgUrl = try node.extract("imgUrl")
    }
    
    func makeNode(context: Context) throws -> Node {
    
        return try Node(node: [
            "id":id,
            "title": title,
            "isbn": isbn,
            "imgUrl": imgUrl
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("books"){ books in
            books.id()
            books.string("title")
            books.string("isbn")
            books.string("imgUrl")
            
        }
    }
    
    static func revert(_ database: Database) throws{
        try database.delete("books")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
