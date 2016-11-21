import Vapor
import VaporPostgreSQL
import Auth
import HTTP
import Cookies
import Turnstile
import TurnstileCrypto
import TurnstileWeb
import Fluent
import Foundation
import SwiftyBeaverVapor
import SwiftyBeaver

import SlackKit


//let drop = Droplet()

let auth = AuthMiddleware<MainUser>()
let database = Database(MemoryDriver())


let drop = Droplet(database: database, availableMiddleware: ["auth": auth, "trustProxy": TrustProxyMiddleware()], preparations: [MainUser.self, Book.self])


let console = ConsoleDestination()
let sbProvider = SwiftyBeaverProvider(destinations: [console])


try drop.addProvider(VaporPostgreSQL.Provider.self)
drop.addProvider(sbProvider)
let log = drop.log.self


let response = Response(text: "Hello, World!", responseType: .InChannel)
let webhook = WebhookServer(token: "w9BDQy2xVVo2QgUoMPJtQDYV", route: "submitBlog", response: response)
webhook.start()


drop.get("login") { request in
    return try drop.view.make("login")
}



drop.post("login") { request in
    guard let username = request.formURLEncoded?["username"]?.string,
        let password = request.formURLEncoded?["password"]?.string else {
            return try drop.view.make("login", ["flash": "Missing username or password"])
    }
    let credentials = UsernamePassword(username: username, password: password)
    do {
        
        try MainUser.authenticate(credentials: credentials)
        try request.auth.login(credentials)
        return Response(redirect: "/")
    } catch let e {
        return try drop.view.make("login", ["flash": "Invalid username or password \(e.localizedDescription)"])
    }
}


drop.get("register") { request in
    return try drop.view.make("register")
}

drop.post("register") { request in
    guard let username = request.formURLEncoded?["username"]?.string,
        let password = request.formURLEncoded?["password"]?.string else {
            return try drop.view.make("register", ["flash": "Missing username or password"])
    }
    let credentials = UsernamePassword(username: username, password: password)
    
    do {
        try _ = MainUser.register(credentials: credentials)
        try request.auth.login(credentials)
        return Response(redirect: "/")
    } catch let e as TurnstileError {
        return try drop.view.make("register", Node(node: ["flash": e.description]))
    }
}
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


drop.get("createGame"){ req in
   // create random room 
    // display to user
    
    // user connects to room based on key 
    
    
    
    drop.socket("cardGame"){ req, ws in
        try background {
            while ws.state == .open {
                try? ws.ping()
                drop.console.wait(seconds: 10)
            }
        }
        ws.onBinary = { ws, data in
             var jsonData = Data(bytes: data)
            var jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String:Any]
            let eventType = jsonDict["event"] as! String
            switch eventType {
            case "join":
                break
            case "play":
                break
            default:
                break
                
            }
            
            
        }
        
        ws.onText = { ws, text in
            
            
            print(text)
            // reverse the characters and send back
            let rev = String(text.characters.reversed())
            try ws.send(rev)
            
            
            var dictionary = ["user":"kerr"]
            var json = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            var bytes = try json.makeBytes()
            try ws.send(bytes)
            
        }
        
        ws.onClose = { ws, code, reason, clean in
            print("Closed.")
        }
        
    }
    return try JSON(node: ["Room":"cardGame"])
}

drop.socket("ws") { req, ws in
    print("New WebSocket connected: \(ws)")
    
    // ping the socket to keep it open
    try background {
        while ws.state == .open {
            try? ws.ping()
            drop.console.wait(seconds: 10) // every 10 seconds
        }
    }
    
    ws.onText = { ws, text in
        print("Text received: \(text)")
        
        // reverse the characters and send back
        let rev = String(text.characters.reversed())
        try ws.send(rev)
    }
    
    ws.onClose = { ws, code, reason, clean in
        print("Closed.")
    }
}


drop.post("newBook"){ req in
    
    var book = try Book(node: req.json)
    try book.save()
    return book
}

drop.resource("novels", BookController())

drop.resource("posts", PostController())

drop.run()
