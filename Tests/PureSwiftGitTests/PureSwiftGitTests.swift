import XCTest
@testable import PureSwiftGit

final class PureSwiftGitTests: XCTestCase {
    func testReadBlob() throws {
        let fileURL = URL(fileURLWithPath: #file)
        let repoURL = fileURL.deletingLastPathComponent().appendingPathComponent("../../Fixtures/sample-repo")
        let repo = Repository(repoURL)
        let obj = try repo.readObject("a5c19667710254f835085b99726e523457150e03")
        let expected = Object.blob("Hello, world\n".data(using: .utf8)!)
        XCTAssertEqual(obj, expected)
    }
}
