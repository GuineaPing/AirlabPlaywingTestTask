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
    @Binding var blackWhite: Bool
    @Binding var saveVideo: Bool
    @StateObject var settings = AppSettings()
    @State private var cameras: [AVCaptureDevice] = []
    @StateObject private var videoDevices = CameraListViewModel()
    
    var body: some View {
        HStack {
            Spacer().frame(width: 25)
            
            Button {
                runCamera.toggle()
            } label: {
                HStack {
                    Text (runCamera ? "Stop" : "Start")
                    Image(systemName: runCamera ? "stop.fill" : "play.fill")
                        .font(.title)
                }
            }
            .focusable(false)
            .buttonStyle(.borderless)
            .padding(.horizontal, 15)
            .help("Start/stop selected camera")
            
            Toggle("B/W mode", isOn: $blackWhite)
                .focusable(false)
                .padding(.horizontal, 10)
                .disabled(saveVideo)
                .help("Black & White mode")
            
            Toggle("Save", isOn: $saveVideo)
                .focusable(false)
                .padding(.horizontal, 10)
                .disabled(blackWhite || runCamera)
                .help("Save video to file")
            
            Spacer()
            
            Button {
                refreshList()
            } label: {
                Image(systemName: "arrow.clockwise")
                    .font(.title2)
            }
            .padding(.horizontal, 5)
            .focusable(false)
            .buttonStyle(.borderless)
            .help("Refresh connected cameras list")
            
            Text("Selected camera:")
                .foregroundStyle(.gray)
            
            Menu {
                camerasList()
            } label: {
                selectedCamera
            }
            .focusable(false)
            .menuStyle(.borderlessButton)
            .padding(.trailing, 25)
            .frame(width: 300)
            .help("Select camera")
        }
        .padding(.bottom, 0)
        .frame(height: 35)
        .background(.clear)
        .padding(.bottom, 0)
        .onAppear {
            refreshList()
        }

        Divider()
            .foregroundStyle(.gray)
            .padding(.top, -5)
    }
    
    func refreshList() {
        videoDevices.fetchCameras()
        cameras = videoDevices.cameras
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
//            return Text("\(camera!.localizedName)")
        }
    }
}

#Preview {
    ContentView()
}
