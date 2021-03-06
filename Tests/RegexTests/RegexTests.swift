import XCTest
@testable import Regex

class RegexTests: XCTestCase {
    
    func testInitialiserReturnsNilForInvalidPattern() {
        let re = Regex(pattern: "[]")
        XCTAssertNil(re)
    }
    
    func testInitialiserReturnsObjectForValidPattern() {
        let re = Regex(pattern: "not [in]valid")
        XCTAssertNotNil(re)
    }
    
    func testReturnsTrueWhenStringDoesMatchExpression() {
        let re = Regex(pattern: "foo")!
        
        XCTAssertTrue(re.matches(string: "wibblefoobar"))
    }
    
    func testCapturesWholeMatchWithNoSubGroups() {
        let re = Regex(pattern: "fo+")!
        let matches: [Regex.Match] = re.matches(string: "a commonly used word in coding is foo, apparently")
        
        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches[0].wholeMatch, "foo")
    }
    
    func testCapturesWholeMatchWithSubGroups() {
        let matches = matchWithSubGroups()
        
        XCTAssertEqual(matches.count, 1)
        XCTAssertEqual(matches[0].wholeMatch, "Resolution: 1920x1080")
    }
    
    func testCapturesSubGroups() {
        let matches = matchWithSubGroups()
        
        XCTAssertEqual(matches[0].groups.count, 2)
        XCTAssertEqual(matches[0].groups[0], "1920")
        XCTAssertEqual(matches[0].groups[1], "1080")
    }
    
    func testCapturesMultipleMatches() {
        let re = Regex(pattern: "([\\d]+)x([\\d]+)")!
        let matches: [Regex.Match] = re.matches(string: "Some common resolutions are 1920x1080 1280x720 and so on")
        
        XCTAssertEqual(matches.count, 2)
        
        XCTAssertEqual(matches[0].wholeMatch, "1920x1080")
        XCTAssertEqual(matches[0].groups[0], "1920")
        XCTAssertEqual(matches[0].groups[1], "1080")
        
        XCTAssertEqual(matches[1].wholeMatch, "1280x720")
        XCTAssertEqual(matches[1].groups[0], "1280")
        XCTAssertEqual(matches[1].groups[1], "720")
    }

    @available(OSX 10.13, *)
    func testNamedCaptureGroups() {
        let re = Regex(pattern: "(?<numbers>\\d+)")!
        let matches: [Regex.Match] = re.matches(string: "Some common resolutions are 1920x1080 1280x720 and so on")

        XCTAssertEqual(matches.count, 4)
        for (match, number) in zip(matches, [1920, 1080, 1280, 720]) {
            XCTAssertEqual(match.group(named: "numbers"), "\(number)")
        }
    }
    
    private func matchWithSubGroups() -> [Regex.Match] {
        let re = Regex(pattern: "Resolution: ([\\d]+)x([\\d]+)")!
        let matches: [Regex.Match] = re.matches(string: "Some text Resolution: 1920x1080 (HD)")
        return matches
    }
}
