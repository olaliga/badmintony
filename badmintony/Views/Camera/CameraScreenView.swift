import AVFoundation
import SwiftUI

class CameraViewModel: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate {
    @Published var isRecording = false
    @Published var videoURL: URL? = nil

    let session = AVCaptureSession()
    private let movieOutput = AVCaptureMovieFileOutput()
    private var outputURL: URL?

    override init() {
        super.init()
        setupSession()
    }

    private func setupSession() {
        session.beginConfiguration()
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
              session.canAddInput(videoInput) else { return }
        session.addInput(videoInput)

        if session.canAddOutput(movieOutput) {
            session.addOutput(movieOutput)
        }
        session.commitConfiguration()
    }

    func startSession() {
        if !session.isRunning {
            session.startRunning()
        }
    }

    func stopSession() {
        if session.isRunning {
            session.stopRunning()
        }
    }

    func startRecording() {
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(UUID().uuidString + ".mov")
        movieOutput.startRecording(to: fileURL, recordingDelegate: self)
        isRecording = true
    }

    func stopRecording() {
        movieOutput.stopRecording()
    }

    // MARK: - AVCaptureFileOutputRecordingDelegate
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            self.isRecording = false
            self.videoURL = outputFileURL
        }
    }
}

struct CameraScreenView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var cameraVM = CameraViewModel()
    @State private var showPreview = false

    var body: some View {
        ZStack {
            CameraPreview(session: cameraVM.session)
                .ignoresSafeArea()
            VStack {
                CameraTopBar(isRecording: cameraVM.isRecording, onCancel: { dismiss() })
                Spacer()
                GuideFrameView()
                Spacer()
                CameraBottomControls(isRecording: cameraVM.isRecording,
                                    onStart: { cameraVM.startRecording() },
                                    onStop: { cameraVM.stopRecording() })
            }
        }
        .onAppear { cameraVM.startSession() }
        .onDisappear { cameraVM.stopSession() }
        .onChange(of: cameraVM.videoURL) { url in
            if url != nil { showPreview = true }
        }
        .fullScreenCover(isPresented: $showPreview) {
            if let url = cameraVM.videoURL {
                PreviewScreenView(videoURL: url)
            }
        }
    }
}

struct CameraTopBar: View {
    var isRecording: Bool
    var onCancel: () -> Void

    var body: some View {
        HStack {
            Button("取消") { onCancel() }
                .foregroundColor(.white)
            Spacer()
            // 這裡可以根據 isRecording 顯示錄影時間或閃光燈按鈕
        }
        .padding()
        .background(Color.black.opacity(0.3))
    }
}

struct GuideFrameView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .stroke(Color.white.opacity(0.5), lineWidth: 3)
            .frame(width: 320, height: 420)
    }
}

struct CameraBottomControls: View {
    var isRecording: Bool
    var onStart: () -> Void
    var onStop: () -> Void

    var body: some View {
        if isRecording {
            Button(action: { onStop() }) {
                Circle().fill(Color.red).frame(width: 76, height: 76)
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
            }
            .padding(.bottom, 32)
        } else {
            Button(action: { onStart() }) {
                Circle().fill(Color.red).frame(width: 76, height: 76)
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
            }
            .padding(.bottom, 32)
        }
    }
}
