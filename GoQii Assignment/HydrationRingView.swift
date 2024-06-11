//
//  HydrationRingView.swift
//  GoQii Assignment
//
//  Created by Ameya Chorghade on 10/06/24.
//

import SwiftUI

struct HydrationRingView: View {
    var totalIntake: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.5), lineWidth: 20)
            Circle()
                .trim(from: 0.0, to: min(CGFloat(totalIntake / 2000), 1.0))
                .stroke(totalIntake >= 2000 ? Color.green : Color.blue, lineWidth: 20)
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeInOut(duration: 1.0), value: totalIntake)
            Text("\(Int(totalIntake)) ml")
                .font(.title)
                .bold()
        }
        .frame(width: 150, height: 150)
        .padding()
    }
}


