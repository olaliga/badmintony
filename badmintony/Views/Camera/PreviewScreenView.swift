import SwiftUI
import AVKit

// 添加导航路径枚举并修改导航逻辑
enum NavigationDestination: Hashable {
    case selectShotType
}

// 模擬分析函數
func mockUploadVideoForAnalysis(videoURL: URL, shotType: String, completion: @escaping (Int, String) -> Void) {
    // 模擬網絡延遲
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        // 返回一個隨機分數和對應的分析文字
        let randomScore = Int.random(in: 60...95)
        let analysisText: String
        
        switch randomScore {
        case 90...100:
            analysisText = "您的動作表現非常出色！揮拍動作標準，擊球時機準確，重心穩定。建議可以嘗試更進階的技術動作。"
        case 80...89:
            analysisText = "您的動作整體表現良好。揮拍動作標準，擊球時機準確，但建議加強手腕收尾動作的穩定性。"
        case 70...79:
            analysisText = "您的動作基本正確，但還有改進空間。建議注意保持重心穩定，並加強手腕力量的運用。"
        default:
            analysisText = "您的動作需要改進。建議從基本動作開始練習，特別注意揮拍姿勢和擊球時機。"
        }
        
        completion(randomScore, analysisText)
    }
}

struct PreviewScreenView: View {
    @Environment(\.dismiss) private var dismiss
    let videoURL: URL
    let selectedShotType: String
    let isFromCamera: Bool
    @State private var isLoading = false
    @State private var showAnalysisResult = false
    @State private var analysisScore: Int = 0
    @State private var analysisText: String = ""
    @Binding var navigationPath: NavigationPath

    var body: some View {
        VStack {
            HStack {
                Button("重新錄製") { dismiss() }
                    .foregroundColor(.white)
                Spacer()
                Text("預覽")
                    .foregroundColor(.white)
                Spacer()
                Button("使用") {
                    isLoading = true
                    mockUploadVideoForAnalysis(videoURL: videoURL, shotType: selectedShotType) { score, text in
                        DispatchQueue.main.async {
                            self.analysisScore = score
                            self.analysisText = text
                            self.isLoading = false
                            self.showAnalysisResult = true
                        }
                    }
                }
                .disabled(isLoading)
                .foregroundColor(.blue)
            }
            .padding()
            .background(Color.black.opacity(0.3))

            VideoPlayer(player: AVPlayer(url: videoURL))
                .frame(height: 400)
                .background(Color.gray)

            if isLoading {
                ProgressView("分析中...")
            }

            Spacer()
        }
        .background(Color.black.ignoresSafeArea())
        .fullScreenCover(isPresented: $showAnalysisResult) {
            AnalysisResultView(
                overallScore: analysisScore,
                analysisText: analysisText,
                navigationPath: $navigationPath,
                isFromCamera: isFromCamera,
                onDismiss: {
                    if isFromCamera {
                        // 从相机进入时，重置导航栈并关闭所有模态视图
                        dismiss() // 关闭 AnalysisResultView
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            dismiss() // 关闭 PreviewScreenView
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                dismiss() // 关闭 CameraScreenView
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    // 重置导航栈并导航到 SelectShotTypeView
                                    navigationPath = NavigationPath()
                                    navigationPath.append(NavigationDestination.selectShotType)
                                }
                            }
                        }
                    } else {
                        // 从相册进入时，重置导航栈并关闭当前视图
                        showAnalysisResult = false
                        navigationPath = NavigationPath()
                        dismiss()
                    }
                }
            )
        }
    }
}

#Preview {
    PreviewScreenView(
        videoURL: URL(string: "https://example.com/video.mp4")!,
        selectedShotType: "發球",
        isFromCamera: false,  // 添加预览参数
        navigationPath: .constant(NavigationPath())
    )
}


