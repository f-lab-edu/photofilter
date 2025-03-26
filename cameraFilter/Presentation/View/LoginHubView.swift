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
            viewModel.login(type: .apple)
        } label: {
            Text("Apple로 로그인하기")
                .foregroundStyle(.white)
                .font(.title3)
                .bold()
        }
        .frame(maxWidth: .infinity, maxHeight: 56)
        .background(.black, in: RoundedRectangle(cornerRadius: 8))
    }
    
    private var googleLoginButton : some View {
        Button {
            viewModel.login(type: .google)
        } label: {
            Text("Google로 로그인하기")
                .foregroundStyle(.black)
                .font(.title3)
                .bold()
        }
        .frame(maxWidth: .infinity, maxHeight: 56)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray, lineWidth: 1))
    }
    
    private var phoneLoginButton : some View {
        NavigationLink {
            PhoneLoginView(viewModel: PhoneLoginViewModel(repository: PhoneLoginRepository()))
        } label: {
            Text("핸드폰 번호로 로그인하기")
                .frame(maxHeight: 24)
                .foregroundStyle(.black)
                .font(.subheadline)
                .underline(color: .gray)
                .bold()
        }
    }
    
    @StateObject private var viewModel : LoginHubViewModel
    
    init(useCase: UserLoginUseCaseProtocol) {
        self._viewModel = StateObject(wrappedValue: LoginHubViewModel(userLoginUseCase: useCase))
    }
    
    var body: some View {
        
        NavigationView {
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
            .alert("알림", isPresented: $viewModel.showSuccessAlert, actions: {
                
            }, message: {
                Text("로그인 성공")
            })
            .onViewDidLoad {
                viewModel.bind()
            }
            
            if viewModel.loginState == .success
            {
               let _ = print("로그인 성공!")
            }
        }
        
    }
}

#Preview {
    LoginHubView(useCase: UserLoginUseCaseMock(repository: UserLoginRepository()))
}
