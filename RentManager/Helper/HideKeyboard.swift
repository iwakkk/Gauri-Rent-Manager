//
//  HideKeyboard.swift
//  RentManager
//
//  Created by Edward Suwandi on 29/04/26.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
