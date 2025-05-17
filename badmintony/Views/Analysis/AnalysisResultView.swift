import SwiftUI

struct AnalysisResultView: View {
    let overallScore: Int
    let analysisText: String
    @Binding var navigationPath: NavigationPath
    @Environment(\.dismiss) private var dismiss
    let isFromCamera: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // 顶部导航栏
            HStack {
                Spacer()
                Text("分析結果")
                    .font(.system(size: 17, weight: .semibold))
                Spacer()
            }
            .padding(.top, 8)
            .padding(.horizontal)
            
            // 总体评分
            VStack(spacing: 8) {
                Text("總體評分")
                    .font(.system(size: 17))
                    .foregroundColor(.gray)
                Text("\(overallScore)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.blue)
            }
            .padding(.top, 24)
            
            // 分析内容
            VStack(alignment: .leading, spacing: 16) {
                Text("分析內容")
                    .font(.system(size: 17, weight: .semibold))
                Text(analysisText)
                    .font(.system(size: 15))
                    .foregroundColor(.black.opacity(0.8))
            }
            .padding()
            .background(Color(white: 0.98))
            .cornerRadius(12)
            .padding(.horizontal)
            
            Spacer()
            
            // 返回主页按钮
            Button(action: {
                navigationPath = NavigationPath()
                onDismiss()
            }) {
                Text("返回主頁")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color.white)
    }
}

struct AnalysisItemView: View {
    let title: String
    let score: Int
    let details: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Text("\(score)")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            Text(details)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    NavigationStack {
        AnalysisResultView(
            overallScore: 85,
            analysisText: "根據影片分析，您的動作整體表現良好。揮拍動作標準，擊球時機準確，但建議加強手腕收尾動作的穩定性，並注意保持重心穩定。",
            navigationPath: .constant(NavigationPath()),
            isFromCamera: false,
            onDismiss: {}
        )
    }
}

func uploadVideoForAnalysis(videoURL: URL, shotType: String, completion: @escaping (Int?, String?) -> Void) {
    let url = URL(string: "http://192.168.1.100:8000/analyze/")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    let boundary = UUID().uuidString
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

    var data = Data()
    // 影片檔案
    data.append("--\(boundary)\r\n".data(using: .utf8)!)
    data.append("Content-Disposition: form-data; name=\"file\"; filename=\"video.mov\"\r\n".data(using: .utf8)!)
    data.append("Content-Type: video/quicktime\r\n\r\n".data(using: .utf8)!)
    data.append(try! Data(contentsOf: videoURL))
    data.append("\r\n".data(using: .utf8)!)
    // 球種
    data.append("--\(boundary)\r\n".data(using: .utf8)!)
    data.append("Content-Disposition: form-data; name=\"shot_type\"\r\n\r\n".data(using: .utf8)!)
    data.append("\(shotType)\r\n".data(using: .utf8)!)
    data.append("--\(boundary)--\r\n".data(using: .utf8)!)

    URLSession.shared.uploadTask(with: request, from: data) { responseData, response, error in
        guard let responseData = responseData,
              let json = try? JSONSerialization.jsonObject(with: responseData) as? [String: Any],
              let score = json["score"] as? Int,
              let analysisText = json["analysis_text"] as? String else {
            completion(nil, nil)
            return
        }
        completion(score, analysisText)
    }.resume()
}

