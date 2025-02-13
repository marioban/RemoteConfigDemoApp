//
//  RatingPromptView.swift
//  RemoteConfigDemo
//
//  Created by Mario Ban on 13.02.2025..
//


import SwiftUI
import StoreKit

struct RatingPromptView: View {
    @State private var rating: Int = 0
    @State private var showFeedbackView = false
    @State private var showFeedbackSentView = false
    @State private var showRatingPrompt = false
    @Environment(\.requestReview) var requestReview
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            if showFeedbackView || showFeedbackSentView {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
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
                
                Image("logo")
                    .resizable()
                    .frame(width: 75, height: 65)
                
                Text("Sviđa ti se naša aplikacija?")
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                
                Text("Ocijeni aplikaciju kako bi dobili povratnu informaciju i poboljšali našu uslugu.")
                    .foregroundStyle(Color.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 1)
                    .edgesIgnoringSafeArea(.horizontal)
                    .padding(.horizontal)
                
                HStack {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .foregroundColor(star <= rating ? .yellow : .yellow)
                            .font(.largeTitle)
                            .onTapGesture {
                                rating = star
                                handleRating(star)
                            }
                    }
                }
                .padding()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 10)
            .padding()
            
            if showFeedbackView {
                FeedBackView(
                    showFeedbackView: $showFeedbackView,
                    //showFeedbackPrompt: $showRatingPrompt,
                    showFeedbackSentView: $showFeedbackSentView
                )
            }
            
            if showFeedbackSentView {
                FeedbackSentView(
                    showSuccessView: $showFeedbackSentView,
                    showFeedbackView: $showFeedbackView
                )
            }
        }
    }
    
    @MainActor private func handleRating(_ rating: Int) {
        if rating < 4 {
            showFeedbackView = true
        } else {
            requestReview()
            dismiss()
        }
    }
}
