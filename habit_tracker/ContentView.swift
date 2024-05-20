//
//  ContentView.swift
//  habit_tracker
//
//  Created by Ailyn Diaz on 4/14/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var habitsViewModel = HabitsViewModel()
    @State private var showingAddHabit = false
    @State private var newHabitTitle = ""
    @State private var newHabitDescription = ""

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.green, Color.white, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing) // Enhanced background gradient
                    .edgesIgnoringSafeArea(.all) // Extend the background color to the edges

                VStack {
                    List {
                        ForEach(habitsViewModel.habits) { habit in
                            NavigationLink(destination: HabitDetailView(habit: habit, habitsViewModel: habitsViewModel)) {
                                HabitCellView(habit: habit)
                            }
                        }
                        .onDelete(perform: deleteHabits)
                    }
                    .listStyle(PlainListStyle()) // Use plain list style for a modern look
                    .background(Color.clear) // Transparent background to show gradient

                    Spacer()

                    Button(action: {
                        self.showingAddHabit.toggle()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                            Text("Add Habit")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    .padding()
                }
                .navigationTitle("Habit Tracker")
                .navigationBarItems(
                    leading: HStack {
                        Image("ghiblipfpailyn")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.leading, 8)
                        Text("@Ailynux")
                            .font(Font.custom("Avenir-Heavy", size: 20))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .leading, endPoint: .trailing))
                                    .shadow(color: .black, radius: 5, x: 0, y: 2)
                            )
                            .padding(5)
                            .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0, y: 2)
                    }
                )
            }
        }
        .sheet(isPresented: $showingAddHabit) {
            AddHabitView(habitsViewModel: habitsViewModel, newHabitTitle: $newHabitTitle, newHabitDescription: $newHabitDescription)
        }
    }

    private func deleteHabits(at offsets: IndexSet) {
        habitsViewModel.habits.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
