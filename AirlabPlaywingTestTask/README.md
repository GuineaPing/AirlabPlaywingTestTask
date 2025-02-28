## **Airlab & Playwing Test Task**
## Video Conferencing Application

## Overview
This application demonstrates a basic video conferencing setup, using macOS platform APIs for detecting, previewing, and recording video and audio. It allows you to:
- List and select available webcams.
- Preview live video with optional black & white filter.
- Display device connection status.
- Record video and audio to separate files.

---

## Prerequisites
- **macOS 15+**
- **Xcode 14+** with Swift 5
- A system with at least one integrated or external webcam
- Optional external microphone for audio recording

---

## Installation & Running
1. Copy AirlabPlaywingTestTask.app localy and run.

## Build from source code  
1. **Clone or download** [the repository](https://github.com/GuineaPing/AirlabPlaywingTestTask) to your local machine.
2. **Open the project** in Xcode by double-clicking the `.xcodeproj` or `.xcworkspace` file.
3. **Check signing settings** if needed (in the project’s “Signing & Capabilities” settings).
4. **Build and run**:
   - Press the _Run_ button ( ▶ ) in Xcode
   - The application window will open, displaying the device dropdown menus and status indicators.

---

## Application Inteface
Application conrols are located on the on the horisontal bar screen on the top of the screen.
1. **Start/Stop button** to contol live feed of the selected camera. It also possible start video feed by pressing big blue camera icon in the centre of the application screen. After start operation viedostream from camera camera displays in application window.
2. **Balck/White switch** to enable black & white filter.
3. **Save switch** to enable save video record file. If it set on, then before strting video feed, it possible to select output file name and location.
4. **Refresh button** enables to refresh the list of video camers that available.
5. **Selected camera** drop down list for select current camera.

## To begin video preview:
1. Select the desired video device from the dropdown.
2. Click **Start Preview** to see the live feed.
3. Click **Stop Preview** to end the session.
4. (Bonus) Click **Record** to capture both video and audio as separate files.

---

## Approach & Challenges
- **Device Integration**: We used `AVFoundation` to enumerate all video input devices and manage their connection states. A primary challenge was handling the permissions and ensuring that device selection changes dynamically reflected in the preview.
- **Video Preview**: Live video feed is captured using `AVCaptureSession`, and we applied a sample grayscale filter by intercepting the video buffer. Managing performance while applying filters required using the GPU and efficient data handling.
- **User Interface**: A straightforward layout with dropdowns and buttons for clarity. Synchronizing the UI with camera status updates was done via observing `AVCaptureSession` notifications.
- **Bonus (Recording)**: For separate video files, leveraged distinct `AVCaptureMovieFileOutput` connections. Handling file paths and ensuring the correct format was a minor hurdle, especially with simultaneous recording streams.

If you have any questions about setup or usage, please let me know!
