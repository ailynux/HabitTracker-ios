//
//  HabitCellView.swift
//  habit_tracker
//
//  Created by Ailyn Diaz on 5/15/24.
//

import Foundation
import SwiftUI

struct HabitCellView: View {
    var habit: Habit

    var body: some View {
        HStack {
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.yellow)
                .shadow(color: .black, radius: 2, x: 0, y: 1) // Add shadow depth

            VStack(alignment: .leading) {
                Text(habit.title)
                    .font(.headline)
                Text(habit.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.blue, lineWidth: 3) // Increased border size and changed to square
                    .frame(width: 40, height: 40)
                Text("\(habit.completionCount)")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.green.opacity(0.2)) // Light green background
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
    }
}
