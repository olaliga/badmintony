import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
        var videoPreviewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
    }

    let session: AVCaptureSession
    @Binding var orientation: UIDeviceOrientation

    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        
        // 设置初始方向
        updatePreviewOrientation(view.videoPreviewLayer)
        
        return view
    }

    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        // 更新预览方向
        updatePreviewOrientation(uiView.videoPreviewLayer)
    }
    
    private func updatePreviewOrientation(_ previewLayer: AVCaptureVideoPreviewLayer) {
        guard let connection = previewLayer.connection else { return }
        
        if #available(iOS 17.0, *) {
            let angle: Double
            switch orientation {
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
            switch orientation {
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
}
