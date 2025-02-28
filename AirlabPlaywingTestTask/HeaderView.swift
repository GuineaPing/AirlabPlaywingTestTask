//
//  Header.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 26.02.2025.
//

import SwiftUI
import AVFoundation

struct HeaderView: View {
    @Binding var runCamera: Bool
    @Binding var cameras: [AVCaptureDevice]
    @Binding var blackWhite: Bool
    @StateObject var settings = AppSettings()
    
    var body: some View {
        HStack {
            Button {
                runCamera.toggle()
            } label: {
                Image(systemName: runCamera ? "stop.fill" : "play.fill")
            }
            .focusable(false)
            .buttonStyle(.borderless)
            .padding(.leading, 25)
            .help("Start/stop camera")
            
            Toggle("B/W mode", isOn: $blackWhite)
                .focusable(false)
                .padding(.leading, 10)
            
            Spacer()
            Text("Selected camera:")
            Menu {
                camerasList()
            } label: {
                selectedCamera
            }
            .focusable(false)
//            .menuIndicator(.hidden)
            .menuStyle(.borderlessButton)
            .padding(.trailing, 25)
            .frame(width: 300)
            .help("Select camera")
        }
        .padding(.bottom, 0)
        .frame(height: 35)
        .background(.clear)
        .padding(.bottom, 0)
        Divider()
            .foregroundStyle(.gray)
            .padding(.top, -5)
    }
    
    func camerasList() -> some View {
        VStack {
            ForEach(cameras.indices, id: \.self) { index in
                Button {
                    settings.selectedID = cameras[index].uniqueID
                } label: {
                    cameraLabel(camera: cameras[index])
                }
            }
        }
    }
    
    var selectedCamera: some View  {
        if let index = cameras.firstIndex(where: { $0.uniqueID == settings.selectedID }) {
            let camera = cameras[index]
            return cameraLabel(camera: camera)
        } else {
            return cameraLabel(camera: nil)
        }
    }
    
    func cameraLabel(camera: AVCaptureDevice?) -> some View {
        if camera == nil {
            return Text("no camera selected")
        } else {
            return Text("\(camera!.localizedName) / \(camera!.isConnected ? "" : "not ")connected")
        }
    }
}

#Preview {
    ContentView()
}
