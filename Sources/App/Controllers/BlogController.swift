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
    
    
    func addRoutes(drop:Droplet){
        drop.post("submitBlog", handler: submit)
    }

    func submit(request:Request) throws -> ResponseRepresentable{
        
        
        
        
//        guard let isbn = req.data["isbn"]?.string else{
//            throw Abort.badRequest
//        }
//        guard let
        return try JSON(node: ["hey": "there"])
    }
}
