import SwiftUI
import AVKit

struct PreviewScreenView: View {
    @Environment(\.dismiss) private var dismiss
    let videoURL: URL
    @State private var isLoading = false
    @State private var analysisScore: Int? = nil
    @State private var showResult = false

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
                    uploadVideoForAnalysis(videoURL: videoURL, shotType: "發球") { score in
                        DispatchQueue.main.async {
                            self.analysisScore = score
                            self.isLoading = false
                            self.showResult = true
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
        .fullScreenCover(isPresented: $showResult) {
            if let score = analysisScore {
                AnalysisResultView(overallScore: score)
            }
        }
    }
}


