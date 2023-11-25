//
//  QuestionView.swift
//  QuizApp
//
//  Created by Turki Alotabi on 24/11/2023.
//

import SwiftUI

struct Question: Identifiable, Decodable {
    let id: Int
    let createdAt: String
    let title: String
    let answer: String
    let options: [String]
    var selection: String?
    
}

struct QuestionView: View {
    @Binding var question: Question
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(question.title)
            
            ForEach(question.options, id:\.self){ options in
                HStack {
                    Button{
                        question.selection = options
                    } label: {
                        if question.selection == options{
                            Circle()
                                .shadow(radius: 3)
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color("AppColor"))
                        }else{
                            Circle()
                                .stroke()
                                .shadow(radius: 3)
                                .frame(width: 24, height: 24)
                        }
                    }
                    Text(options)
                }
                .foregroundColor(Color(uiColor: .secondaryLabel))
            }
        }
        .padding(.horizontal, 20)
        .frame(width: 340, height: 550, alignment: .leading)
        .background(Color(uiColor: .systemGray6))
        .cornerRadius(20)
        .shadow(color: Color(uiColor: .label).opacity(0.2), radius: 15)
    }
}

struct QuestionView_Previews: PreviewProvider{
    static var previews: some View{
        QuestionView(question: .constant(Question(id: 7, createdAt: "", title: "When was the IPhone first realased?", answer: "A", options: ["A", "B", "C", "D"])))
    }
}

//#Preview {
//    QuestionView()
//}
