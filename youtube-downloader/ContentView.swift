//
//  ContentView.swift
//  youtube-downloader
//
//  Created by frh alshaalan on 02/06/1444 AH.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @StateObject var downloadm = DownloadManger()
    @State var urlText = ""

    var body: some View {
        
        NavigationView{
           
            VStack{
              
                VStack(alignment: .center){
                    
                    TextField("ضع الرابط هنا", text: $urlText)
                        .multilineTextAlignment(.trailing)
                        .padding(10)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.5), Color.white.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(20)
                        .shadow(color: .gray, radius: 20)
                        .padding(.trailing,20)
                        .padding(.leading,20)
                    Button(action: {
                        downloadm.startDownload(urlString: urlText)
                    }, label: {
                        Text("حمّل لي ")
                            .fontWeight(.semibold)
                            .padding(.vertical,10)
                            .padding(.horizontal,30)
                            .background(Color(hue: 0.084, saturation: 0.316, brightness: 0.481))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(radius: 6)
                        
                        
                        
                        
                    })
                 
                 
                    
                }
                .padding(.top)
                
                
                .navigationTitle("مرحباً ، سعيدون بك :)")
                .navigationBarTitleDisplayMode(.inline)

               
                .preferredColorScheme(.light)
            .alert(isPresented: $downloadm.showAlert, content: {
                Alert(title: Text ("اوبس!"), message:
                        Text(downloadm.alertMsg), dismissButton:
                        .destructive(Text("Ok"), action: {
                        }))
            })
           }
            

            .frame(height: 1000).background(
                Image("bg")
                    .resizable())
           .overlay(
               ZStack{
                   if downloadm.showtheprosess{
                       progresdownloadview(progress: $downloadm.progressdownload).environmentObject(downloadm)

                   }
               }
           )
        }
    

      
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
            
            
