//
//  CheckBoxToggleStyle.swift
//  ShotLog
//
//  Created by Fabian Kreuzer on 02.02.24.
//

import Foundation
import SwiftUI

extension ToggleStyle where Self == CheckboxToggleStyle {
 
    static var checkmark: CheckboxToggleStyle { CheckboxToggleStyle() }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            
            configuration.label
            
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(lineWidth: 2)
                .frame(width: 25, height: 25)
                .cornerRadius(5.0)
                .overlay {
                    Image(systemName: configuration.isOn ? "checkmark" : "")
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }
 
            
 
        }
    }
}
