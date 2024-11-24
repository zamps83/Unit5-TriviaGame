// TriviaViewModel.swift

import Foundation

class TriviaViewModel: ObservableObject {
    @Published var questions: [TriviaQuestion] = []

    func fetchTriviaQuestions(amount: Int, category: String, difficulty: String, type: String) async {
        // Convert category name to ID
        let categoryID = categoryToID(category: category)
        
        // Construct the API URL
        let urlString = "https://opentdb.com/api.php?amount=\(amount)&category=\(categoryID)&difficulty=\(difficulty.lowercased())&type=\(type)"
        
        // Debug: Print the constructed URL
        print("Request URL: \(urlString)")
        
        // Ensure the URL is valid
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        do {
            // Fetch data
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Debug: Print the raw JSON response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(jsonString)")
            }

            // Decode response
            let decodedResponse = try JSONDecoder().decode(TriviaResponse.self, from: data)
            DispatchQueue.main.async {
                self.questions = decodedResponse.results
            }
        } catch {
            print("Error fetching trivia questions: \(error.localizedDescription)")
        }
    }

    // Maps category names to their corresponding IDs from the Open Trivia Database API
    private func categoryToID(category: String) -> String {
        let categoryMapping: [String: String] = [
            "General Knowledge": "9",
            "Entertainment: Books": "10",
            "Entertainment: Film": "11",
            "Entertainment: Music": "12",
            "Entertainment: Musicals & Theatres": "13",
            "Entertainment: Television": "14",
            "Entertainment: Video Games": "15",
            "Entertainment: Board Games": "16",
            "Science & Nature": "17",
            "Science: Computers": "18",
            "Science: Mathematics": "19",
            "Mythology": "20",
            "Sports": "21",
            "Geography": "22",
            "History": "23",
            "Politics": "24",
            "Art": "25",
            "Celebrities": "26",
            "Animals": "27",
            "Vehicles": "28",
            "Entertainment: Comics": "29",
            "Science: Gadgets": "30",
            "Entertainment: Japanese Anime & Manga": "31",
            "Entertainment: Cartoon & Animations": "32"
        ]
        return categoryMapping[category] ?? ""
    }
}
