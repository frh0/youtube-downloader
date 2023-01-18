//
//  progresdownloadview.swift
//  youtube-downloader
//
//  Created by frh alshaalan on 03/06/1444 AH.
//

import SwiftUI

struct progresdownloadview: View {
    @Binding var progress: CGFloat
    @EnvironmentObject var downloadm: DownloadManger
    var body: some View {
        ZStack{
            Color.primary
                .opacity(0.5)
                .ignoresSafeArea()
            VStack(spacing : 15){
                ZStack{
                    Circle()
                        .fill(Color.gray)
                    
                    shapeofprogress(progress: progress)
                        .fill((Color(hue: 0.084, saturation: 0.316, brightness: 0.481)).opacity(0.25))
                        .rotationEffect(.init(degrees: -90))
                }
               
                .frame(width: 70, height: 70)
                Button(action: {downloadm.cancellation()}, label: { Text("الغاء")
                    
                })
                .padding(.top)
            
            }
            .padding(.vertical,20)
            .padding(.horizontal,50)
            .background(Color.white.opacity(0.5))
            .cornerRadius(8)
            
        }
    }
}


struct progresdownloadview_Previews: PreviewProvider {
    static var previews: some View {
        progresdownloadview(progress: .constant(0.5))
    }
}
struct shapeofprogress: Shape{
    var progress : CGFloat
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addArc(center:CGPoint(x: rect.midX, y: rect.midY), radius: 35, startAngle: .zero, endAngle: .init(degrees: Double(progress*360)), clockwise: false)
        }
    }

    }

