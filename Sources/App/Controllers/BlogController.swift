//
//  BlogController.swift
//  flatiron-teacher-assistant
//
//  Created by Johann Kerr on 11/20/16.
//
//

import Foundation
import Vapor
import HTTP
//import SlackKit

final class BlogController{
    
    
    func addRoutes(drop: Droplet){
        drop.post("submitBlog", handler: submit)
    }

    func submit(request:Request) throws -> ResponseRepresentable{
        guard let user = request.formURLEncoded?["user_name"]?.string else {
            throw Abort.badRequest
        }
        guard let text = request.formURLEncoded?["text"]?.string else {
            throw Abort.badRequest
        }
        
        var blog = Blog(link: text, username: user)
        try blog.save()
        
        return try JSON(node: ["text": "Thanks mate", "attachments":["text":"woot"]])
    }
}
