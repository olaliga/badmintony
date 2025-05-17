import AVFoundation
import SwiftUI

class CameraViewModel: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate {
    @Published var isRecording = false
    @Published var videoURL: URL? = nil
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isFlashOn = false
    @Published var currentOrientation: UIDeviceOrientation = .portrait

    let session = AVCaptureSession()
    private let movieOutput = AVCaptureMovieFileOutput()
    private var outputURL: URL?

    override init() {
        super.init()
        checkPermissions()
        setupOrientationObserver()
    }

    private func setupOrientationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationChanged),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }

    @objc private func orientationChanged() {
        currentOrientation = UIDevice.current.orientation
    }

    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.setupSession()
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.showAlert = true
                        self?.alertMessage = "需要相機權限才能使用此功能"
                    }
                }
            }
        case .denied, .restricted:
            showAlert = true
            alertMessage = "請在設置中允許訪問相機"
        @unknown default:
            showAlert = true
            alertMessage = "未知的相機權限狀態"
        }
    }

    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        do {
            try device.lockForConfiguration()
            if device.hasTorch {
                device.torchMode = isFlashOn ? .off : .on
                isFlashOn.toggle()
            }
            device.unlockForConfiguration()
        } catch {
            print("無法設置閃光燈: \(error.localizedDescription)")
        }
    }

    func switchCamera() {
        // 實現切換前後鏡頭的功能
    }

    private func setupSession() {
        print("開始設置相機...")
        
        #if targetEnvironment(simulator)
        print("在模擬器環境中運行")
        // 在模擬器中使用默認相機
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("無法獲取模擬器相機設備")
            return
        }
        print("成功獲取模擬器相機設備")
        #else
        print("在實機環境中運行")
        // 使用 AVCaptureDeviceDiscoverySession 獲取可用設備
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: .back
        )
        let devices = discoverySession.devices
        print("可用的設備: \(devices)")
        
        guard let device = devices.first else {
            print("無法找到可用的相機設備")
            return
        }
        print("成功獲取實機相機設備")
        #endif
        
        do {
            print("嘗試配置相機輸入...")
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
                print("成功添加相機輸入")
            } else {
                print("無法添加相機輸入")
                return
            }
            
            print("嘗試配置視頻輸出...")
            if session.canAddOutput(movieOutput) {
                session.addOutput(movieOutput)
                print("成功添加視頻輸出")
                
                // 設置視頻穩定
                if let connection = movieOutput.connection(with: .video) {
                    if connection.isVideoStabilizationSupported {
                        connection.preferredVideoStabilizationMode = .auto
                        print("已啟用視頻穩定")
                    }
                    
                    // 設置視頻方向
                    if #available(iOS 17.0, *) {
                        if connection.isVideoRotationAngleSupported(0) {
                            connection.videoRotationAngle = 0
                        }
                    } else {
                        if connection.isVideoOrientationSupported {
                            connection.videoOrientation = .portrait
                        }
                    }
                    print("已設置視頻方向")
                } else {
                    print("無法獲取視頻連接")
                    return
                }
            } else {
                print("無法添加視頻輸出")
                return
            }
            
            print("開始相機會話...")
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.session.startRunning()
                print("相機會話已開始運行")
            }
            
        } catch {
            print("設置相機時發生錯誤: \(error.localizedDescription)")
        }
    }

    func startSession() {
        guard !session.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
        }
    }

    func stopSession() {
        guard session.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.stopRunning()
        }
    }

    func startRecording() {
        print("開始錄影...")
        guard let connection = movieOutput.connection(with: .video) else {
            print("無法獲取視頻連接")
            showAlert = true
            alertMessage = "無法設置錄影連接"
            return
        }
        
        // 確保視頻連接已準備好
        if !connection.isEnabled {
            print("視頻連接未啟用")
            showAlert = true
            alertMessage = "視頻連接未啟用"
            return
        }
        
        // 設置錄影方向
        if #available(iOS 17.0, *) {
            let angle: Double
            switch currentOrientation {
            case .portrait:
                angle = 0
            case .portraitUpsideDown:
                angle = 180
            case .landscapeLeft:
                angle = 90
            case .landscapeRight:
                angle = 270
            default:
                angle = 0
            }
            
            if connection.isVideoRotationAngleSupported(angle) {
                connection.videoRotationAngle = angle
            }
        } else {
            if connection.isVideoOrientationSupported {
                switch currentOrientation {
                case .portrait:
                    connection.videoOrientation = .portrait
                case .portraitUpsideDown:
                    connection.videoOrientation = .portraitUpsideDown
                case .landscapeLeft:
                    connection.videoOrientation = .landscapeRight
                case .landscapeRight:
                    connection.videoOrientation = .landscapeLeft
                default:
                    connection.videoOrientation = .portrait
                }
            }
        }
        
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(UUID().uuidString + ".mov")
        print("開始錄影到: \(fileURL)")
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
            if let error = error {
                self.showAlert = true
                self.alertMessage = "錄影失敗: \(error.localizedDescription)"
            } else {
                self.videoURL = outputFileURL
            }
        }
    }
}

struct CameraScreenView: View {
    @StateObject private var cameraVM = CameraViewModel()
    @State private var showPreview = false
    @State private var orientation: UIDeviceOrientation = .portrait
    @Binding var navigationPath: NavigationPath
    @Environment(\.dismiss) private var dismiss
    let selectedShotType: String
    
    var body: some View {
        ZStack {
            // 相機預覽
            CameraPreview(session: cameraVM.session, orientation: $orientation)
                .ignoresSafeArea()
            
            // 返回按鈕
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding(.leading, 20)
                    .padding(.top, 20)
                    
                    Spacer()
                }
                Spacer()
            }
            
            // 控制按鈕
            VStack {
                Spacer()
                
                HStack {
                    Button(action: {
                        cameraVM.switchCamera()
                    }) {
                        Image(systemName: "camera.rotate")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if cameraVM.isRecording {
                            cameraVM.stopRecording()
                        } else {
                            cameraVM.startRecording()
                        }
                    }) {
                        Circle()
                            .fill(cameraVM.isRecording ? Color.red : Color.white)
                            .frame(width: 70, height: 70)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 80, height: 80)
                            )
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        cameraVM.toggleFlash()
                    }) {
                        Image(systemName: cameraVM.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            cameraVM.checkPermissions()
            // 开始监听设备方向
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            NotificationCenter.default.addObserver(
                forName: UIDevice.orientationDidChangeNotification,
                object: nil,
                queue: .main
            ) { _ in
                orientation = UIDevice.current.orientation
            }
        }
        .onDisappear {
            // 停止监听设备方向
            UIDevice.current.endGeneratingDeviceOrientationNotifications()
            NotificationCenter.default.removeObserver(self)
        }
        .fullScreenCover(isPresented: $showPreview) {
            if let url = cameraVM.videoURL {
                PreviewScreenView(
                    videoURL: url,
                    selectedShotType: selectedShotType,
                    isFromCamera: true,
                    navigationPath: $navigationPath
                )
            }
        }
        .onChange(of: cameraVM.videoURL) { oldValue, newValue in
            if newValue != nil {
                showPreview = true
            }
        }
    }
}

#Preview {
    CameraScreenView(
        navigationPath: .constant(NavigationPath()),
        selectedShotType: "發球"
    )
}

