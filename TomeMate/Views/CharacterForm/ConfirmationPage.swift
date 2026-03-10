//
//  ConfirmationPage.swift
//  TomeMate
//
//  Created by Derrick Mangari on 2026-03-02.
//

import SwiftUI

struct ConfirmationPage: View {
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            Text("Character is Finished!")
                .font(.largeTitle)
                .bold()
                .padding(20)
            Text("Are you sure to proceed ?")
            Spacer()
        }
    }
}

#Preview {
    //ConfirmationPage()
}
