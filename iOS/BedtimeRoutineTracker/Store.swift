import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    static let freeLimit = 15

    @Published var items: [RoutineStep] = []
    @Published var isPro: Bool = false

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("bedtimeroutine_items.json")
        load()
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: RoutineStep) {
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: RoutineStep) {
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            items[idx] = item
            save()
        }
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: RoutineStep) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([RoutineStep].self, from: data) else {
            items = [
            RoutineStep(title: "Bath", note: ""),
            RoutineStep(title: "Brush teeth", note: ""),
            RoutineStep(title: "Pajamas", note: ""),
            RoutineStep(title: "Story time", note: ""),
            RoutineStep(title: "Lights out", note: "")
            ]
            save()
            return
        }
        items = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
