import Foundation

struct RoutineStep: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var note: String
    var date: Date = Date()
}
