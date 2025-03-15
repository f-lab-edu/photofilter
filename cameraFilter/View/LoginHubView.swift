//
//  ContentView.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/8/25.
//

import SwiftUI

struct LoginHubView: View {
    
    
    private var appleLoginButton : some View {
        Button {
            viewModel.onClickLogin(type: .apple)
        } label: {
            Text("Apple로 로그인하기")
                .foregroundStyle(.white)
                .font(.title3)
                .bold()
        }
        .frame(maxWidth: .infinity, maxHeight: 56)
        .background(.black, in: RoundedRectangle(cornerRadius: 8))
        .alert("애플로그인 성공", isPresented: $viewModel.showSuccessAlert) {
            
        }
    }
    
    private var googleLoginButton : some View {
        Button {
            viewModel.onClickLogin(type: .google)
        } label: {
            Text("Google로 로그인하기")
                .foregroundStyle(.black)
                .font(.title3)
                .bold()
        }
        .frame(maxWidth: .infinity, maxHeight: 56)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray, lineWidth: 1))
        .alert("구글로그인 성공", isPresented: $viewModel.showSuccessAlert) {
            
        }
    }
    
    private var phoneLoginButton : some View {
        Button {
            
        } label: {
            Text("핸드폰 번호로 로그인하기")
                .foregroundStyle(.black)
                .font(.subheadline)
                .underline(color: .gray)
                .bold()
        }
        .frame(maxWidth: .infinity, maxHeight: 56)
    }
    
    @ObservedObject private var viewModel : LoginHubViewModel
    
    init(viewModel: LoginHubViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Text("안녕하세요, 로그인 방법을 선택해주세요.")
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    .fontWeight(.bold)
                Spacer()
            }
            
            
            Spacer()
            
            VStack {
                appleLoginButton
                googleLoginButton
                phoneLoginButton
            }
        }
        .padding()
        
        if viewModel.updateUIState == .loading
        {
            ProgressView()
        }
        else if viewModel.updateUIState == .success
        {
           let _ = print("로그인 성공!")
        }
    }
}

#Preview {
    LoginHubView(viewModel: LoginHubViewModel(userLoginUseCase: UserLoginUseCase(repository: UserLoginRepository())))
}
