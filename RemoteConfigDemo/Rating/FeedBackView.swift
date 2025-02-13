//
//  FeedBackView.swift
//  RemoteConfigDemo
//
//  Created by Mario Ban on 13.02.2025..
//


import SwiftUI

struct FeedBackView: View {
    @Binding var showFeedbackView: Bool
    @Binding var showFeedbackSentView: Bool
    @State private var feedbackText: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                Spacer()
                
                VStack {
                    Button(action: {
                        showFeedbackView = false
                    }) {
                        SwiftUI.Image("close")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 25, height: 25)
                            .padding(5)
                            .background(
                                Circle()
                                    .foregroundColor(Color.gray.opacity(0.15))
                            )
                    }
                }
            }
            
            Image("logo")
                .resizable()
                .frame(width: 75, height: 65)
            
            Text("Tvoje mišljenje nam je važno")
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
            
            Text("Ovdje opišite problem kako bi mogli poboljšati naše usluge.")
                .foregroundStyle(Color.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack {
                TextEditor(text: $feedbackText)
                    .frame(height: 150)
                    .padding()
                    .foregroundStyle(Color.white)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 25.0)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            }
            
            GeometryReader { geometry in
                Button(action: {
                    if !feedbackText.isEmpty {
                        showFeedbackSentView = true
                        showFeedbackView = false
                    }
                }) {
                    Text("POŠALJI")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(feedbackText.isEmpty ? Color.gray.opacity(0.3) : Color.orange)
                        .foregroundColor(feedbackText.isEmpty ? .gray : .white)
                        .fontWeight(.bold)
                }
                .cornerRadius(15)
                .frame(width: geometry.size.width)
            }
            .onTapGesture {
                showFeedbackView = false
            }
            .frame(height: 50)
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding()
    }
}
