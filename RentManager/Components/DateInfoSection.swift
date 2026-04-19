//
//  DateInfoSection.swift
//  RentManager
//
//  Created by Edward Suwandi on 06/03/26.
//

import SwiftUI

struct DateInfoSectionView: View {

    var startDate: Date
    var endDate: Date

    var body: some View {


            VStack(alignment: .leading) {
                
                
                Text("Rent Start")
                    .fontWeight(.bold)

                Text(startDate.formatted(date: .abbreviated, time: .omitted))
                    .padding(.bottom)
                
                Text("Rent End")
                    .fontWeight(.bold)

                Text(endDate.formatted(date: .abbreviated, time: .omitted))
            }


//            VStack(alignment: .leading) {
//
//               
//            }
        
    }
}
