//
//  QuizManager.swift
//  QuizApp
//
//  Created by Turki Alotabi on 25/11/2023.
//

import Foundation
import Supabase

class QuizManager: ObservableObject {
    
    @Published var questions = [Question]()
    @Published var quizResult = QuizResult(correct: 0, total: 0, grade: "100%")
    
//    @Published var mockQuestions = [
//        Question(title: "When was the IPhone first realased?", answer: "A", options: ["A", "B", "C", "D"]),
//        Question(title: "the IPhone first realased?", answer: "A", options: ["A", "B", "C", "D"]),
//        Question(title: "IPhone first realased?", answer: "A", options: ["A", "B", "C", "D"])
//    ]
    
    
    
    let client = SupabaseClient(supabaseURL: URL(string: "https://mgdfobgdkzfihfrgqqhu.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1nZGZvYmdka3pmaWhmcmdxcWh1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDA5MDA1OTQsImV4cCI6MjAxNjQ3NjU5NH0.SU2rM1zQhI3qo0v715EIJzc_cTOz-YVGQ2gmjehpxa4")
    
    init() {
        Task {
            do {
                let response = try await client.database.from("quiz").select().execute().data
                let data = response
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let questions = try decoder.decode([Question].self, from: data)
                await MainActor.run {
                    self.questions = questions
                }
            } catch {
                print("error fetching questions")
            }
        }
    }
    
    func CanSubmitQuiz() -> Bool{
        return questions.filter({ $0.selection == nil }).isEmpty

    }
    func gradeQuiz(){
        var correct: CGFloat = 0
        for question in questions {
            if question.answer == question.selection{
                correct+=1
            }
        }
        self.quizResult = QuizResult(correct: Int(correct), total:questions.count, grade: "\((correct/CGFloat(questions.count)) * 100) %")
    }
    
    func resetQuiz(){
        self.questions = questions.map({Question(id: $0.id, createdAt: $0.createdAt,title: $0.title, answer: $0.answer, options: $0.options, selection: nil)})
    }
    
}


struct QuizResult {
    let correct: Int
    let total: Int
    let grade: String
    
}
