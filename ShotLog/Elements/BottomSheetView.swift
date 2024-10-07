//
//  BottomSheetView.swift
//  ShotLog
//
//  Created by Fabian Kreuzer on 06.10.24.
//
import SwiftUI

struct BottomSheetView<Content: View>: View {
    @Binding var isPresented: Bool // Control the visibility from outside
    let content: Content
    
    // State variables for tracking drag gestures
    @State private var dragOffset = CGSize.zero

    // Init with a ViewBuilder
    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }

    var body: some View {
        VStack {
            Spacer() // Pushes the content to the bottom half

            // The main content of the bottom sheet
            content
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height / 2) // Adjust as needed
                .background(Color(.systemGray5))
                .cornerRadius(20)
                .shadow(radius: 10)
                .offset(y: dragOffset.height > 0 ? dragOffset.height : 0) // Move with drag gesture
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.height > 0 {
                                dragOffset = value.translation // Track downward drag
                            }
                        }
                        .onEnded { value in
                            if value.translation.height > 400 { // Threshold to dismiss
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isPresented = false // Dismiss the sheet
                                }
                            }
                            withAnimation(.easeInOut(duration: 0.3)) {
                                dragOffset = .zero 
                            }
                        }
                )
                .transition(.move(edge: .bottom)) // Slide-in transition from the bottom
        }
        .edgesIgnoringSafeArea(.all) // Ignore safe areas so the sheet covers the bottom area
        .background(
            Color.clear //transparent background
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isPresented = false // Dismiss the sheet
                    }
                }
        )
    }
}

