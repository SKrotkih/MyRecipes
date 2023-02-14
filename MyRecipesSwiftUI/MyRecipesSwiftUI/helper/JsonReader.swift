import Foundation

enum ReadingJsonError: Error {
    case fileNameError(String)
}

func readJSONFile(_ name: String) throws -> Data? {
    if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
        let fileUrl = URL(fileURLWithPath: filePath)
        let data = try Data(contentsOf: fileUrl)
        return data
    } else {
        let message = "The json file \(name) is not presentet in main bundle"
        throw ReadingJsonError.fileNameError(message)
    }
}
