//
//  AddHabitView.swift
//  habit_tracker
//
//  Created by Ailyn Diaz on 5/15/24.
//

import Foundation
import SwiftUI

struct AddHabitView: View {
    @ObservedObject var habitsViewModel: HabitsViewModel
    @Binding var newHabitTitle: String
    @Binding var newHabitDescription: String
    @Environment(\.presentationMode) var presentationMode

    var habitToEdit: Habit? // Add property to hold the habit to be edited

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBlue)
                    .edgesIgnoringSafeArea(.all) // Extend the background color to the edges

                VStack(alignment: .center, spacing: 20) {
                    // Title
                    Text(habitToEdit != nil ? "EDIT HABIT" : "ADD A NEW HABIT")
                        .font(.system(size: 28, weight: .bold, design: .rounded)) // Custom font and size
                        .foregroundColor(.white)
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.2))
                                .padding(.horizontal, 10)
                        )
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)

                    // Image in a holder
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .frame(width: 150, height: 150)
                            .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)

                        Image("habits_t")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 130, height: 130)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    .padding(.bottom, 20)

                    // Header and text field for habit title
                    VStack(alignment: .leading, spacing: 5) {
                        Text("TITLE")
                            .font(.headline)
                            .foregroundColor(.white)

                        TextField("Enter habit title", text: $newHabitTitle)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 2)
                            .onAppear {
                                if let habit = habitToEdit {
                                    newHabitTitle = habit.title
                                    newHabitDescription = habit.description
                                }
                            }
                    }
                    .padding(.horizontal)

                    // Header and text field for habit description
                    VStack(alignment: .leading, spacing: 5) {
                        Text("DESCRIPTION")
                            .font(.headline)
                            .foregroundColor(.white)

                        TextField("Enter habit description", text: $newHabitDescription)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 2)
                    }
                    .padding(.horizontal)

                    // Save button
                    Button(action: {
                        if let habitToEdit = habitToEdit {
                            habitsViewModel.editHabit(id: habitToEdit.id, newTitle: newHabitTitle, newDescription: newHabitDescription)
                        } else {
                            let newHabit = Habit(title: newHabitTitle, description: newHabitDescription, completionCount: 0)
                            habitsViewModel.habits.append(newHabit)
                        }
                        newHabitTitle = ""
                        newHabitDescription = ""
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text(habitToEdit != nil ? "UPDATE" : "SAVE")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(0.5), radius: 3, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}
