import Foundation

class UserFileManager: NSObject {
    let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    func saveFile(data: String, fileName: String) {
        let fileUrl = documentDirectoryUrl.appendingPathComponent(fileName)
        try! data.data(using: .utf8)!.write(to: fileUrl, options: .atomic)
        print("export \(fileUrl) is done.")
    }
}
