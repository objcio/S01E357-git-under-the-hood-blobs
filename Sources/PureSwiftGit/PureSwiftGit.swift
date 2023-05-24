import Foundation

enum Object: Hashable {
    case blob(Data)
    case commit
    case tree
}

public struct Repository {
    var url: URL
    init(_ url: URL) {
        self.url = url
    }

    var gitURL: URL {
        url.appendingPathComponent(".git")
    }

    func readObject(_ hash: String) throws -> Object {
        // todo verify that this is an actual hash
        let objectPath = "\(hash.prefix(2))/\(hash.dropFirst(2))"
        let data = try Data(contentsOf: gitURL.appendingPathComponent("objects/\(objectPath)")).decompressed
        var remainder = data
        let typeStr = String(decoding: remainder.remove(upTo: 0x20), as: UTF8.self)
        remainder.remove(upTo: 0)
        switch typeStr {
        case "blob": return .blob(remainder)
        default: fatalError()
        }
    }
}

extension Data {
    @discardableResult
    mutating func remove(upTo separator: Element) -> Data {
        let part = prefix(while: { $0 != separator })
        removeFirst(part.count)
        _ = popFirst()
        return part
    }
}
