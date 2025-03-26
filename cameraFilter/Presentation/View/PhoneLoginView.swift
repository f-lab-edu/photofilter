//
//  PhoneLoginView.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/9/25.
//

import SwiftUI

struct PhoneLoginView : View {
    
    private var phoneNumberField : some View {
        TextField(text: $phoneNumber) {
            Text("핸드폰번호")
        }
        .frame(maxWidth: .infinity, maxHeight: 42)
        .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.gray, lineWidth: 1))
    }
    
    private var requestButton : some View {
        Button {
            viewModel.requestPhoneLogin(phoneNumber: phoneNumber)
        } label: {
            Text("인증번호 요청하기")
                .font(.title3)
                .foregroundStyle(.white)
                .bold()
        }
        .frame(maxWidth: .infinity, maxHeight: 56)
        .background(.blue, in: RoundedRectangle(cornerRadius: 8))

    }
    
    private var backButton : some View {
        Button {
            onTapPop()
        } label: {
            Image(systemName: "chevron.backward")
                .font(.system(size: 20, weight: .bold, design: .default))
                .foregroundStyle(.black)
        }
        .frame(maxWidth: 20, maxHeight: 20)

    }
    
    @State private var phoneNumber : String = ""
    @Environment(\.dismiss) private var onTapPop
    @ObservedObject private var viewModel : PhoneLoginViewModel
    
    init(viewModel: PhoneLoginViewModel) {
        self.viewModel = viewModel
    }
    
    var body : some View {
        VStack {
            
            HStack {
                Text("핸드폰 번호를\n입력해주세요.")
                    .font(.title)
                    .bold()
                Spacer()
            }
            .padding(.top, 10)
            
            Spacer()
                .frame(height: 14)
            
            phoneNumberField
            
            switch viewModel.phoneLoginState {
            case .success:
                Spacer()
            case .fail(error: let error):
                HStack {
                    Spacer()
                    Text(error.localizedDescription)
                        .hidden()
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .bold()
                        .underline()
                }
                Spacer()
            case .initial:
                Spacer()
            case .loading:
                Spacer()
            }
            
            requestButton
        }
        .padding()
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading)
            {
                backButton
            }
        }
        
        
    }
}


#Preview {
    PhoneLoginView(viewModel: PhoneLoginViewModel(repository: PhoneLoginRepository()))
}
