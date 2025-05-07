import SwiftUI

struct AnalysisResultView: View {
    @Environment(\.dismiss) private var dismiss
    let overallScore: Int
    // 假資料
    let analysisItems: [String] = [
        "揮拍動作標準，擊球時機良好。",
        "步伐靈活，但重心略高，建議加強下肢穩定。",
        "肩膀發力自然，建議手腕收尾再明確一點。"
    ]

    var body: some View {
        VStack(spacing: 0) {
            // 導覽列
            HStack {
                Button("返回") { dismiss() }
                    .foregroundColor(.blue)
                    .font(.system(size: 17))
                Spacer()
                Text("分析結果")
                    .font(.system(size: 17))
                    .foregroundColor(.black)
                Spacer()
                Button("分享") {
                    // TODO: 分享功能
                }
                .foregroundColor(.blue)
                .font(.system(size: 17))
            }
            .padding()
            .background(Color.white)

            ScrollView {
                VStack(spacing: 24) {
                    // 整體分數區
                    VStack(spacing: 8) {
                        Text("\(overallScore)")
                            .font(.system(size: 48, weight: .regular))
                            .foregroundColor(Color(red: 0.2, green: 0.6, blue: 1.0))
                        Text("整體動作評分")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .background(Color(red: 0.95, green: 0.97, blue: 1.0))
                    .cornerRadius(20)
                    .padding(.horizontal, 24)

                    // 詳細分析區
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(analysisItems, id: \.self) { item in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(item)
                                    .font(.system(size: 17))
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(Color(white: 0.98))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 16)
            }
            .background(Color.white)
        }
        .background(Color.white.ignoresSafeArea())
    }
}

func uploadVideoForAnalysis(videoURL: URL, shotType: String, completion: @escaping (Int?) -> Void) {
    let url = URL(string: "http://你的伺服器IP:8000/analyze/")!
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
              let score = json["score"] as? Int else {
            completion(nil)
            return
        }
        completion(score)
    }.resume()
}

