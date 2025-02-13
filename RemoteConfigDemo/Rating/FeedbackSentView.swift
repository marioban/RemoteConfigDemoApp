//
//  FeedbackSentView.swift
//  Reinvent-24sata
//
//  Created by Mario Ban on 28.10.2024..
//  Copyright © 2024 SMS. All rights reserved.
//

import SwiftUI

struct FeedbackSentView: View {
    @Binding var showSuccessView: Bool
    @Binding var showFeedbackView: Bool
    @State var requestFailed: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                Spacer()
                
                Button(action: {
                    showSuccessView = false
                    showFeedbackView = false
                }) {
                    Image("close")
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
            
            Text(!requestFailed ? "Uspješno poslano!" : "Nešto je pošlo po krivu")
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
            
            Text(!requestFailed ? "Povratna informacija je uspješno zabilježena i proslijeđena našem timu koji će raditi na rješavanju problema." : "Molimo pokušajte ponovo")
                .foregroundStyle(Color.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom)
        
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding()
    }
}
