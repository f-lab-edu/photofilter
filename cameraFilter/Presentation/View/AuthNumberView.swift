//
//  AuthNumberView.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/19/25.
//

import Foundation
import SwiftUI


struct AuthNumberView : View {
    
    private var titleLabel : some View {
        Text("인증번호를\n입력해주세요.")
            .font(.title)
            .bold()
            .multilineTextAlignment(.leading)
    }
    
    private var authnumberField : some View {
        TextField(text: $authNumber) {
            Text("인증번호")
        }
        .frame(maxWidth: .infinity, maxHeight: 42)
        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray, lineWidth: 1))
    }
    
    private var requestAuthButton : some View {
        Button {
            
        } label: {
            Text("확인")
                .font(.title2)
                .foregroundStyle(.white)
                .bold()
        }
        .frame(maxWidth: .infinity, maxHeight: 56)
        .background(.blue, in: RoundedRectangle(cornerRadius: 8))
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))

    }
    
    @State private var authNumber : String = ""
    
    @StateObject private var viewModel : AuthNumberViewModel
    
    init(viewModel: AuthNumberViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            HStack {
                titleLabel
                Spacer()
            }
            .padding(20)
            
            authnumberField
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            
            Spacer()
            requestAuthButton
        }
        .onViewDidLoad {
            
        }
    }
}


#Preview {
    AuthNumberView(viewModel: AuthNumberViewModel(authNumberUsecase: AuthNumberUseCase(repository: AuthNumberRepository())))
}
