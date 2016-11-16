import Vapor
import VaporPostgreSQL



let drop = Droplet(
//    preparations: [Book.self]
//    
)
drop.preparations.append(Book.self)
try drop.addProvider(VaporPostgreSQL.Provider.self)



drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.get("version") { req in
    if let db = drop.database?.driver as? PostgreSQLDriver{
        let version = try db.raw("SELECT version()")
        return try JSON(node: version)
    }else{
        return "no db connection"
    }
    
}

drop.get("johann"){ req in
    return try JSON(node:[
        "hey":"hey"
        ])
    
}

drop.get("books"){ req in
    
    var book = Book(title: "hey", isbn: "there", imgUrl: "vapor")
    try book.save()
    return try JSON(node: Book.all().makeNode())
    
}

drop.get("first"){ req in
    
    return try JSON(node: Book.query().first()?.makeNode())
}

drop.get("book"){ req in
    guard let isbn = req.data["isbn"]?.string else{
        throw Abort.badRequest
    }
    return try JSON(node: Book.query().filter("isbn", isbn).all().makeNode())
    
}

drop.post("newBook"){ req in
    
    var book = try Book(node: req.json)
    try book.save()
    return book
}

drop.resource("posts", PostController())

drop.run()
