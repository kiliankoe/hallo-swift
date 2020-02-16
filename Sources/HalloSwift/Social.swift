import Foundation
import Plot

extension Node where Context == HTML.BodyContext {
    static func socialDetail(for speaker: String) -> Node {
        let speakerElements = speaker.split(separator: " ").map(String.init)

        // Known hosts only need a name and we use their stored Twitter handles.
        if speakerElements.count == 1 {
            var twitterHandle = ""
            switch speaker.lowercased() {
                case "ben": twitterHandle = "benchr"
                case "dom": twitterHandle = "swiftpainless"
                case "vincent": twitterHandle = "regexident"
                case "bilal": twitterHandle = "reffas_bilal"
                case "kilian": twitterHandle = "kiliankoe"
                default: break
            }
            guard !twitterHandle.isEmpty else {
                print("⚠️ No social info for \(speaker)")
                return .text(speaker)
            }
            return .group(.text("\(speaker) "), .twitterLink(for: twitterHandle))
        } else {
            // For guests we're looking for twitter handles (@foobar) or generic URLs to link.
            let name = speakerElements.first!
            let links: [Node] = speakerElements
                .dropFirst()
                .map { element in
                    if element.contains("@") {
                        return twitterLink(for: element)
                    } else {
                        guard let url = URL(string: element) else { fatalError("Invalid social URL: \(element)")}
                        return .group(.text(" "), .a(.href(url), .text(url.host!)))
                    }
                }
            return .group(.text("\(name) "), .group(links))
        }
    }

    private static func twitterLink(for handle: String) -> Node {
        let handle = handle.replacingOccurrences(of: "@", with: "")
        guard let twitterURL = URL(string: "https://twitter.com/\(handle)") else { fatalError("Invalid twitter URL with handle `\(handle)`") }
        return .a(.href(twitterURL), .text("@\(handle)"))
    }
}
