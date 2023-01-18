//
//  DownloadManger.swift
//  youtube-downloader
//
//  Created by frh alshaalan on 02/06/1444 AH.
//

//import Foundation
import SwiftUI
import Photos
import UIKit
import _AVKit_SwiftUI
import AVKit
import AVFoundation


class DownloadManger: NSObject, ObservableObject,URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("راييعيعععععععع يابطله")
        guard let url = downloadTask.originalRequest?.url else {
            DispatchQueue.main.async {
                self.reportError(error: "لرجاء المحاوله لاحقاٍ")
                
            }
            return
        }
        //الباث بعدين واحد لحفط الملفات بعدين توجيه
        let directoryPath = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask)[0]
        let destinationURL = directoryPath.appendingPathComponent(url.lastPathComponent)
        try? FileManager.default.removeItem(at: destinationURL)//اذا موجود من اول يحذفه
        
        do{
            try FileManager.default.copyItem(at: location, to: destinationURL)//هنا ننقل التمبروري او ننسخه اف يو ويل
            print("تاسكك الفايل منجر")
            DispatchQueue.main.async{
                withAnimation {
                    self.showtheprosess = false
                }
                let controller = UIDocumentInteractionController(url: destinationURL)
                controller.delegate = self
                controller.presentPreview(animated: true)
            }
        }
        catch{
            DispatchQueue.main.async {
                self.reportError(error: "حاول مره اخرى")
                
            }
        }
    }
    @State var player = AVPlayer()

    @Published var downloadURL: URL!
    @Published var downloadtasksession : URLSessionDownloadTask!
    @Published var progressdownload: CGFloat = 0
    @Published var showtheprosess = false
    // تنبيه
    @Published var alertMsg = ""
    @Published var showAlert = false
    @Published var isDownloading = false
    @Published var isDownloaded = false

    // التحميل
    
    func startDownload(urlString: String){

//        if let statusCode = (response as? HTTPURLResponse)?.statusCode {
//            print("Successfully downloaded. Status code: \(statusCode)")
//        }
        // نشوف اذا صحيح او لا
        guard let correctURL = URL(string: urlString) else {
            self.reportError(error: "معليش الرابط غير صحيح ")
                
            return

            
        }
            
        progressdownload = 0
        withAnimation {
            showtheprosess = true
        }
        let session = URLSession(configuration: .default, delegate:self, delegateQueue: nil)
        downloadtasksession = session.downloadTask(with: correctURL)
        downloadtasksession.resume()
    }
    
    // اذا خطا
    func reportError(error: String){
        alertMsg = error
        showAlert.toggle ()
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        //هذا ياطويلين العمر للبروقرس
        let progress = CGFloat(totalBytesWritten)/CGFloat(totalBytesExpectedToWrite)
        print("تقدم البرنامج")
        DispatchQueue.main.async{
            self.progressdownload = progress
        }
    }
    

    
    func cancellation(){
        if let task = downloadtasksession, task.state == .running {
            downloadtasksession.cancel()
            withAnimation{
                self.showtheprosess = false
                
            }
        }
    }
    
    func downloadFile() {
        isDownloading = true

        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        let destinationUrl = docsUrl?.appendingPathComponent("myVideo.mp4")

        if let destinationUrl = destinationUrl {
            if FileManager().fileExists(atPath: destinationUrl.path) {
                print("File already exists")
                isDownloading = false
            } else {
                let urlRequest = URLRequest(url: URL(string: "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4")!)

                let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                    if let error = error {
                        print("Request error: ", error)
                        self.isDownloading = false
                        return
                    }

                    guard let response = response as? HTTPURLResponse else { return }

                    if response.statusCode == 200 {
                        guard let data = data else {
                            self.isDownloading = false
                            return
                        }
                        DispatchQueue.main.async {
                            do {
                                try data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                DispatchQueue.main.async {
                                    self.isDownloading = false
                                }
                            } catch let error {
                                print("Error decoding: ", error)
                                self.isDownloading = false
                            }
                        }
                    }
                }
                dataTask.resume()
            }
        }
    }
    
    
    func getVideoFileAsset() -> AVPlayerItem? {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationURL = directoryPath.appendingPathComponent(url.lastPathComponent)

        let destinationUrl = docsUrl?.appendingPathComponent("myVideo.mp4")
        if let destinationUrl = destinationUrl {
            if (FileManager().fileExists(atPath: destinationUrl.path)) {
                let avAssest = AVAsset(url: destinationUrl)
                return AVPlayerItem(asset: avAssest)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    ////    private func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
    //        private func currentUIWindow(_ controller: UIDocumentInteractionController) -> UIWindow? {
    ////            private func   documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
    //            let connectedScenes = UIApplication.shared.connectedScenes
    //                .filter { $0.activationState == .foregroundActive }
    //                .compactMap { $0 as? UIWindowScene }
    //
    //            let window = connectedScenes.first?
    //                .windows
    //                .first { $0.isKeyWindow }
    //
    //            return window
    //
    //        }
    
//        func documentInteractionControllerViewForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
//            return
//        }
  
 

    
    
    //هدي تبع لو ماحط رابط بس كلام
    internal func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        DispatchQueue.main.async {
            if let error = error{
                withAnimation {
                    self.showtheprosess = false
                }
                self.reportError (error: error.localizedDescription)
                return
            }
        }
    }
    //    public extension UIApplication(_ controller: UIDocumentInteractionController) -> UIViewController{
    //        func currentUIWindow() -> UIWindow? {
    //            let connectedScenes = UIApplication.shared.connectedScenes
    //                .filter { $0.activationState == .foregroundActive }
    //                .compactMap { $0 as? UIWindowScene }
    //
    //            let window = connectedScenes.first?
    //                .windows
    //                .first { $0.isKeyWindow }
    //
    //            return window
    //
    //        }
    //    }
    
    
}
