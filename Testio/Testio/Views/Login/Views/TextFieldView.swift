//
//  TextFieldView.swift
//  Testio
//
//  Created by Krystsina on 2023-10-10.
//

import SwiftUI

struct TextFieldView: View {
    @Binding var text: String
    let placeHolder: String
    let imageName: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(imageName)
                .padding(.leading, 8)
            
            TextField(placeHolder, text: $text)
                .font(.system(size: 17))
                .foregroundColor(.black)
                .opacity(0.6)
                .autocorrectionDisabled(true)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 40)
        .background(Color.textFieldBackgroundColor)
        .cornerRadius(8)
        .padding(.horizontal, 32)
        .padding(.bottom, 16)
    }
}

struct TextFieldView_Previews: PreviewProvider {
    @State static var field: String = "Test"
    
    static var previews: some View {
        TextFieldView(
            text: $field,
            placeHolder: "placeholder",
            imageName: "image"
        )
    }
}
