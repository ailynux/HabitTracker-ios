//
//  BarChartView.swift
//  habit_tracker
//
//  Created by Ailyn Diaz on 4/16/24.
//
import Foundation
import SwiftUI

struct BarChartView: View {
    var data: [Double]
    var barSpacing: CGFloat = 8 // Increased spacing between bars
    var barHeight: CGFloat = 40 // Increased bar height
    var maxHeight: CGFloat = 300 // Increased maximum height of the bars
    var barColors: [Color]
    var animationDuration: Double = 1.0

    var body: some View {
        VStack {
            Text("Meter fills up in 30 days")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom, 4)

            HStack(spacing: barSpacing) {
                ForEach(0..<data.count, id: \.self) { index in
                    BarView(value: self.data[index], color: self.barColors[index], barHeight: self.barHeight, maxHeight: self.maxHeight, animationDuration: self.animationDuration)
                }
            }
        }
    }
}

struct BarView: View {
    var value: Double
    var color: Color
    var barHeight: CGFloat
    var maxHeight: CGFloat
    var animationDuration: Double

    @State private var currentHeight: CGFloat = 0

    var body: some View {
        VStack {
            Rectangle()
                .fill(color)
                .frame(width: barWidth(value: value), height: currentHeight)
                .onAppear {
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        self.currentHeight = barHeight
                    }
                }
                .onDisappear {
                    self.currentHeight = 0
                }

            Text(String(format: "%.0f", value))
                .font(.caption)
                .foregroundColor(.primary)
        }
    }

    private func barWidth(value: Double) -> CGFloat {
        let clampedValue = min(value, 30)
        let ratio = CGFloat(clampedValue / 30) // Convert ratio to CGFloat
        return ratio * maxHeight
    }
}

struct HabitProgressView: View {
    var habits: [Habit]

    var barColors: [Color] {
        return Array(repeating: Color.blue, count: habits.count)
    }

    var body: some View {
        VStack {
            Text("Habit Progress")
                .font(.title)

            BarChartView(data: habits.map { Double($0.completionCount) }, barColors: barColors)
                .frame(height: 150) // Adjusted height
                .padding()
        }
    }
}

struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        let randomHabits: [Habit] = (0..<3).map { _ in
            Habit(title: "Habit", description: "Description", completionCount: Int.random(in: 1...30))
        }

        return HabitProgressView(habits: randomHabits)
    }
}
