//
//  AuthTitle.swift
//  duyguPinari
//
//  Created by İlknur Tulgar on 5.11.2024.
//

import Foundation
import SwiftUI

struct AuthTitle: View {
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack(alignment:.leading){
            
            TextStyles.hugeTitle(title)
            TextStyles.hugeTitle(subtitle)
            .padding(.leading,130)
            
        }
        .HugeTitlePadding()
    }
}
