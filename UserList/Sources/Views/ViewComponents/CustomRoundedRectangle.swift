//
//  CustomRoundedRectangle.swift
//  UserList
//
//  Created by Margot Pasquali on 25/06/2024.
//

import SwiftUI

struct CustomRoundedRectangle: Shape {
    var topLeft: CGFloat = 0
    var topRight: CGFloat = 0
    var bottomLeft: CGFloat = 0
    var bottomRight: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.size.width
        let height = rect.size.height

        // Top left corner
        let tlRadius = min(min(topLeft, height / 2), width / 2)
        // Top right corner
        let trRadius = min(min(topRight, height / 2), width / 2)
        // Bottom left corner
        let blRadius = min(min(bottomLeft, height / 2), width / 2)
        // Bottom right corner
        let brRadius = min(min(bottomRight, height / 2), width / 2)

        path.move(to: CGPoint(x: width / 2.0, y: 0))
        path.addLine(to: CGPoint(x: width - trRadius, y: 0))
        path.addArc(center: CGPoint(x: width - trRadius, y: trRadius),
                    radius: trRadius,
                    startAngle: Angle(degrees: -90),
                    endAngle: Angle(degrees: 0),
                    clockwise: false)
        path.addLine(to: CGPoint(x: width, y: height - brRadius))
        path.addArc(center: CGPoint(x: width - brRadius, y: height - brRadius),
                    radius: brRadius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 90),
                    clockwise: false)
        path.addLine(to: CGPoint(x: blRadius, y: height))
        path.addArc(center: CGPoint(x: blRadius, y: height - blRadius),
                    radius: blRadius,
                    startAngle: Angle(degrees: 90),
                    endAngle: Angle(degrees: 180),
                    clockwise: false)
        path.addLine(to: CGPoint(x: 0, y: tlRadius))
        path.addArc(center: CGPoint(x: tlRadius, y: tlRadius),
                    radius: tlRadius,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 270),
                    clockwise: false)
        path.addLine(to: CGPoint(x: width / 2.0, y: 0))

        return path
    }
}
struct CustomRoundedRectangleView: View {
    var body: some View {
        CustomRoundedRectangle(topLeft: 20, topRight: 20, bottomLeft: 0, bottomRight: 0)
            .fill(Color.blue)
            .frame(width: 200, height: 100)
            .padding()
    }
}

#Preview {
    CustomRoundedRectangleView()
}
