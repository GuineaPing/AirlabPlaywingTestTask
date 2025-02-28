# **Airlab & Playwing Test Task**

## Video Conferencing Application

## Overview
This application demonstrates a basic video conferencing setup using macOS platform APIs for detecting, previewing, and recording video and audio. It allows you to:
- List and select available webcams.
- Preview live video with an optional black & white filter.
- Display device connection status.
- Record video and audio to separate files.

## Prerequisites
- **macOS 15+**
- **Xcode 14+** with Swift 5
- A system with at least one integrated or external webcam
- Optional external microphone for audio recording

## Installation & Running
1. Copy the **AirlabPlaywingTestTask.app** file to your local machine and run it.

## Build from Source Code
1. **Clone or download** [the repository](https://github.com/GuineaPing/AirlabPlaywingTestTask) to your local machine.
2. **Open the project** in Xcode by double-clicking the `.xcodeproj` or `.xcworkspace` file.
3. **Check signing settings** if needed (in the project's **Signing & Capabilities** section).
4. **Build and run**:
   - Press the **Run** (▶) button in Xcode.
   - The application window will open, displaying device dropdown menus and status indicators.

## Application Interface
Application controls are located on the horizontal bar at the top of the screen.

1. **Start/Stop (▶) Button**  
   Controls the live feed of the selected camera. You can also start the video feed by pressing the big blue camera icon in the center of the screen. Once the video stream starts, it is displayed in the application window. You can change the camera and toggle the black-and-white mode while the video feed is running.

2. **Black/White Switch**  
   Enables the black & white filter.

3. **Save Switch**  
   Enables video recording to a file. If turned on, you can choose the output file name and location before starting the video feed.

4. **Refresh Button**  
   Refreshes the list of available video cameras.

5. **Selected Camera Dropdown**  
   Lets you pick the current camera from the list.

## Approach & Challenges
- **Device Integration**: We used `AVFoundation` to enumerate all video input devices and manage their connection states. A primary challenge was handling permissions and ensuring that changes in device selection were dynamically reflected in the preview.
- **Video Preview**: Live video is captured using an `AVCaptureSession`, with a grayscale filter applied by intercepting the video buffer. Efficient data handling and GPU usage were key to maintaining performance.
- **User Interface**: A straightforward layout with dropdowns and buttons offers clarity. We synchronized the UI with camera status updates by observing relevant `AVCaptureSession` notifications.
- **Bonus (Recording)**: For separate video files, we used distinct `AVCaptureMovieFileOutput` connections. Handling file paths and ensuring correct formatting presented a small challenge when managing simultaneous recording streams.

If you have any questions about setup or usage, please let me know!
