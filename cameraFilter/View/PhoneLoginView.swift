//
//  PhoneLoginView.swift
//  cameraFilter
//
//  Created by 정종찬 on 3/9/25.
//

import SwiftUI

struct PhoneLoginView : View {
    
    private var phoneNumberField : some View {
        Text("")
    }
    
    var body : some View {
        VStack {
            HStack {
                Text("휴대폰 번호를 입력해주세요")
                    .font(.title)
                    .bold()
                Spacer()
            }
            
        }
        .padding()
    }
}


#Preview {
    PhoneLoginView()
}
