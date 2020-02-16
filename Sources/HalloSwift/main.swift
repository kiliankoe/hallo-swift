import Foundation
import Publish
import Plot

struct HalloSwift: Website {
    enum SectionID: String, WebsiteSectionID {
        case episodes
    }

    struct ItemMetadata: WebsiteItemMetadata, PodcastCompatibleWebsiteItemMetadata {
        var podcast: PodcastEpisodeMetadata?
        var speaker: [String]
        var audio: Audio
        var episode: String
    }

    var url = URL(string: "https://hallo-swift.de")!
    var name = "Hallo Swift"
    var description = "Podcast über Swift, iOS, macOS und verwandte Themen"
    var language: Language = .german
    var imagePath: Path? = "/cover.png"

    var iTunesURL = URL(string: "https://podcasts.apple.com/podcast/id1225721421")!

    var githubURL = URL(string: "https://github.com/hallo-swift")!
    var twitterURL = URL(string: "https://twitter.com/hallo_swift")!
}

let podcastConfig = PodcastFeedConfiguration<HalloSwift>(
    targetPath: "feed.xml",
    type: .episodic,
    imageURL: URL(string: "/cover.png")!,
    copyrightText: "Copyright 2017 Hallo Swift",
    author: PodcastAuthor(name: "Hallo Swift", emailAddress: "mail@hallo-swift.de"),
    description: HalloSwift().description,
    subtitle: "",
    isExplicit: false,
    category: "Technology")

try HalloSwift().publish(using: [
    .addMarkdownFiles(),
    .copyResources(),
    .generateHTML(withTheme: .halloSwift),
    .generatePodcastFeed(for: .episodes, config: podcastConfig),
    .generateSiteMap()
])
