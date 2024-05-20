//
//  Habits.swift
//  habit_tracker
//
//  Created by Ailyn Diaz on 4/16/24.
//

import Foundation
import SwiftUI
import SwiftData

// all the user defaults save and codeables

struct Habit: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var completionCount: Int
}

class HabitsViewModel: ObservableObject {
    @Published var habits: [Habit] {
        didSet {
            saveHabits()
        }
    }

    private let habitsKey = "SavedHabits"

    init() {
        self.habits = []
        loadHabits()
    }

    func loadHabits() {
        if let data = UserDefaults.standard.data(forKey: habitsKey) {
            if let savedHabits = try? JSONDecoder().decode([Habit].self, from: data) {
                self.habits = savedHabits
                return
            }
        }
        self.habits = []
    }

    func saveHabits() {
        if let encoded = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(encoded, forKey: habitsKey)
        }
    }
    
    func editHabit(id: UUID, newTitle: String, newDescription: String) {
            if let index = habits.firstIndex(where: { $0.id == id }) {
                habits[index].title = newTitle
                habits[index].description = newDescription
            }
        }
    }

