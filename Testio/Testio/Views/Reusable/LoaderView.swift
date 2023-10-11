//
//  LoaderView.swift
//  Testio
//
//  Created by Krystsina on 2023-10-11.
//

import SwiftUI

struct LoaderView: View {
    var body: some View {
        ZStack {
            backgroundView()
            
            ProgressView() {
                Text(StringConstants.loadingTitle)
                    .font(.system(size: 13))
                    .foregroundColor(.loaderTextColor)
            }
        }
        .ignoresSafeArea()
    }
    
    private func backgroundView() -> some View {
        GeometryReader { geometryReader in
            VStack {
                Spacer()
                
                Image("backgroundImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometryReader.size.width, height: geometryReader.size.height / 2)
            }
        }
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}
