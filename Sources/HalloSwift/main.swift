import Foundation
import Publish
import Plot

struct HalloSwift: Website {
    enum SectionID: String, WebsiteSectionID {
        case episodes
    }

    struct ItemMetadata: WebsiteItemMetadata {
        var number: String
        var speaker: [String]
        var mp3URL: URL // this could probably be a computed var based on `number`
    }

    var url = URL(string: "https://hallo-swift.de")!
    var name = "Hallo Swift"
    var description = "Podcast über Swift, iOS, macOS und verwandte Themen"
    var language: Language { .german }
    var imagePath: Path? { nil }

    var iTunesURL = URL(string: "https://podcasts.apple.com/podcast/id1225721421")!
    var rssFeed = URL(string: "http://feeds.soundcloud.com/users/soundcloud:users:300507271/sounds.rss")! // FIXME

    var githubURL = URL(string: "https://github.com/hallo-swift")!
    var twitterURL = URL(string: "https://twitter.com/hallo_swift")!
}

try HalloSwift().publish(using: [
    .addMarkdownFiles(),
    .copyResources(),
    .generateHTML(withTheme: .halloSwift),
    .generateRSSFeed(including: [.episodes]),
    .generateSiteMap()
])
