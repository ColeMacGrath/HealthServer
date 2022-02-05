import App
import Vapor

#if DEBUG
let arguments = [CommandLine.arguments.first ?? ".", "serve", "--env", "development", "--hostname", "0.0.0.0", "--port", "8080"]
#else
let arguments = [CommandLine.arguments.first ?? ".", "serve", "--env", "production", "--hostname", "0.0.0.0", "--port", "8080"]
#endif

var env = try Environment.detect(arguments: arguments)
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
defer { app.shutdown() }
try configure(app)
try app.run()
