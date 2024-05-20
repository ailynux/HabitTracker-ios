//
//  ViewModels.swift
//  habit_tracker
//
//  Created by Ailyn Diaz on 4/16/24.
//

import Foundation
import SwiftUI

struct HabitDetailView: View {
    var habit: Habit
    @ObservedObject var habitsViewModel: HabitsViewModel
    @State private var isEditing = false
    @State private var editedHabitTitle = ""
    @State private var editedHabitDescription = ""
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all) // Gradient background

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text(habit.title.uppercased())
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        Spacer()
                        Button(action: {
                            isEditing.toggle()
                            editedHabitTitle = habit.title
                            editedHabitDescription = habit.description
                        }) {
                            Image(systemName: "pencil.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title)
                                .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal)

                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(15)
                            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5)
                            .padding(.horizontal)
                    } else {
                        Button(action: {
                            isImagePickerPresented.toggle()
                        }) {
                            VStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: 50))
                                    .foregroundColor(.blue)
                                Text("Upload Photo")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5)
                            .padding(.horizontal)
                        }
                    }

                    Text(habit.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)

                    HStack {
                        Spacer()

                        VStack {
                            Spacer()

                            Text("Progress")
                                .font(.custom("Futura", size: 28)) // Replace "YourCoolFont" with the actual name of your font
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .padding(.top, 20)

                            BarChartView(data: [Double(habit.completionCount)], barColors: [Color.blue])
                                .frame(height: 150)
                                .padding(.horizontal)
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)

                            Spacer()
                        }

                        Spacer()
                    }




                    VStack(spacing: 20) {
                        HStack {
                            Text("Completion Count:")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            Text("\(habit.completionCount)")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal)

                        HStack(spacing: 40) {
                            Button(action: {
                                decrementCompletionCount()
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.system(size: 40))
                                    .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 2)
                            }
                            Button(action: {
                                incrementCompletionCount()
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 40))
                                    .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 2)
                            }
                        }
                        .padding(.top)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                }
                .padding(.top, 20) // Move the content closer to the top
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .sheet(isPresented: $isEditing) {
            AddHabitView(habitsViewModel: habitsViewModel, newHabitTitle: $editedHabitTitle, newHabitDescription: $editedHabitDescription, habitToEdit: habit)
        }
    }

    private func incrementCompletionCount() {
        if let index = habitsViewModel.habits.firstIndex(where: { $0.id == habit.id }) {
            habitsViewModel.habits[index].completionCount += 1
        }
    }

    private func decrementCompletionCount() {
        if let index = habitsViewModel.habits.firstIndex(where: { $0.id == habit.id }) {
            habitsViewModel.habits[index].completionCount -= 1
        }
    }
}

// ImagePicker struct for selecting an image from the photo library
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
