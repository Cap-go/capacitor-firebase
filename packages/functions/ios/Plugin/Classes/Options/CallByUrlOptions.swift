import Foundation

@objc public class CallByUrlOptions: CallOptions {
    private var url: URL

    init?(url: String, data: Any?, timeout: Int?) {
        guard let parsedUrl = URL(string: url) else {
            return nil
        }
        self.url = parsedUrl
        super.init(data: data, timeout: timeout)
    }

    func getUrl() -> URL {
        return url
    }
}
