// OptionsView.swift

import SwiftUI

struct OptionsView: View {
    @State private var numberOfQuestions = 5
    @State private var selectedCategory = "General Knowledge"
    @State private var selectedDifficulty = "Easy"
    @State private var isMultipleChoice = true
    @State private var navigateToGame = false // Tracks navigation to game

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Number of Questions")) {
                    Stepper("\(numberOfQuestions)", value: $numberOfQuestions, in: 1...20)
                }
                Section(header: Text("Category")) {
                    Picker("Select a Category", selection: $selectedCategory) {
                        Text("General Knowledge").tag("General Knowledge")
                        Text("Science").tag("Science")
                        Text("History").tag("History")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Difficulty")) {
                    Picker("Select Difficulty", selection: $selectedDifficulty) {
                        Text("Easy").tag("Easy")
                        Text("Medium").tag("Medium")
                        Text("Hard").tag("Hard")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Question Type")) {
                    Toggle("Multiple Choice", isOn: $isMultipleChoice)
                }
                NavigationLink(
                    destination: TriviaGameView(
                        numberOfQuestions: numberOfQuestions,
                        category: selectedCategory,
                        difficulty: selectedDifficulty,
                        questionType: isMultipleChoice ? "multiple" : "boolean"
                    ),
                    isActive: $navigateToGame
                ) {
                    Button(action: startTriviaGame) {
                        Text("Start Trivia Game")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .navigationTitle("Trivia Options")
        }
    }

    private func startTriviaGame() {
        navigateToGame = true // Trigger navigation to TriviaGameView
    }
}
