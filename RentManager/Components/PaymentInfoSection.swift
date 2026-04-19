//
//  PaymentInfoSection.swift
//  RentManager
//
//  Created by Edward Suwandi on 06/03/26.
//

import SwiftUI

struct PaymentInfoSection: View {

    var accountNumber: String

    var body: some View {

        VStack(alignment: .trailing, spacing: 4) {

            Text("Payment")
                .fontWeight(.bold)

            Text("Bank Transfer")

            Text("Account: \(accountNumber)")
        }
    }
}
