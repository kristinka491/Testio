//
//  LoginView.swift
//  Testio
//
//  Created by Krystsina on 2023-10-10.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var testioViewModel: TestioViewModel
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            backgroundView()
            
            formView()
        }
        .ignoresSafeArea()
        .alert(isPresented: $viewModel.isShowErrorAlert) {
            Alert(
                title: Text(StringConstants.alertTitle),
                message: Text(StringConstants.alertMessage)
            )
        }
        .onChange(of: viewModel.isLoginSuccess) { isLogin in
            if isLogin {
                testioViewModel.isUserLoggedIn.toggle()
            }
        }
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
    
    private func formView() -> some View {
        GeometryReader { geometryReader in
            VStack(spacing: .zero) {
                Image("logo")
                    .padding(.bottom, 40)
                
                TextFieldView(
                    text: $viewModel.username,
                    placeHolder: StringConstants.usernamePlaceholder,
                    imageName: "userIcon"
                )
                
                TextFieldView(
                    text: $viewModel.password,
                    placeHolder: StringConstants.passwordPlaceholder,
                    imageName: "lockIcon"
                )
                
                Button(action: {
                    viewModel.login()
                    
                }, label: {
                    Text(StringConstants.loginButton)
                        .foregroundColor(.white)
                })
                .font(.system(size: 17))
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(Color.buttonBackgroundColor)
                .cornerRadius(10)
                .padding(.horizontal, 32)
                .padding(.top, 8)
            }
            .padding(.top, geometryReader.size.height / 5)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
