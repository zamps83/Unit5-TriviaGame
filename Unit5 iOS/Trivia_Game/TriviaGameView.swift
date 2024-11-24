// TriviaGameView.swift

import SwiftUI

struct TriviaGameView: View {
    let numberOfQuestions: Int
    let category: String
    let difficulty: String
    let questionType: String

    @ObservedObject var viewModel = TriviaViewModel()
    @State private var selectedAnswers: [UUID: String] = [:]
    @State private var showingScore = false
    @State private var score = 0

    var body: some View {
        NavigationStack {
            if viewModel.questions.isEmpty {
                ProgressView("Loading Trivia Questions...")
                    .task {
                        await viewModel.fetchTriviaQuestions(
                            amount: numberOfQuestions,
                            category: category,
                            difficulty: difficulty,
                            type: questionType
                        )
                    }
            } else {
                List(viewModel.questions) { question in
                    VStack(alignment: .leading) {
                        Text(question.question)
                            .font(.headline)
                        ForEach(question.incorrectAnswers + [question.correctAnswer].shuffled(), id: \.self) { answer in
                            Button(action: {
                                selectedAnswers[question.id] = answer
                            }) {
                                HStack {
                                    Text(answer)
                                    Spacer()
                                    if selectedAnswers[question.id] == answer {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
                Button("Submit Answers") {
                    calculateScore()
                }
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .navigationTitle("Trivia Game")
        .alert(isPresented: $showingScore) {
            Alert(
                title: Text("Your Score"),
                message: Text("\(score)/\(viewModel.questions.count)"),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func calculateScore() {
        let correctAnswers = viewModel.questions.filter { question in
            selectedAnswers[question.id] == question.correctAnswer
        }
        score = correctAnswers.count
        showingScore = true
    }
}
