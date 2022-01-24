import Fluent
import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: UserController())
    try app.register(collection: HealthRecordController())
    try app.register(collection: SchedulesController())
    try app.register(collection: DoctorsController())
    try app.register(collection: AppointmentsController())
}
