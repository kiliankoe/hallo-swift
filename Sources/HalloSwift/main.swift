import Foundation
import Publish
import Plot

struct HalloSwift: Website {
    enum SectionID: String, WebsiteSectionID {
        case episodes
    }

    struct ItemMetadata: WebsiteItemMetadata {
        let title: String
        let publishDate: Date
        let author: String

        let description: String
        let summary: String

        let url: URL
        let media: [URL]
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://hallo-swift.de")!
    var name = "Hallo Swift"
    var description = "Podcast über Swift, iOS, macOS und verwandte Themen"
    var language: Language { .german }
    var imagePath: Path? { nil }
}

try HalloSwift().publish(withTheme: .foundation)
