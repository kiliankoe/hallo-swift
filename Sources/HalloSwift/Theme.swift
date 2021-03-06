import Foundation
import Publish
import Plot

extension Theme where Site == HalloSwift {
    static var halloSwift: Self {
        Theme(htmlFactory: HalloSwiftHTMLFactory(),
              resourcePaths: ["Resources/HalloSwiftTheme/styles.css"])
    }

    private struct HalloSwiftHTMLFactory: HTMLFactory {
        private var css: [Path] = [
            "/styles.css",
            "https://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css"
        ]

        func makeIndexHTML(for index: Index, context: PublishingContext<HalloSwift>) throws -> HTML {
            HTML(
                .lang(context.site.language),
                .head(for: index, on: context.site, stylesheetPaths: css),
                .body(
                    .header(for: context),
                    .wrapper(
                        .class("content"),
                        .wrapper(
                            .img(.class("cover"), .src("/cover.png")),
                            .class("title"),
                            .h1(.text(index.title)),
                            .p(
                                .class("description"),
                                .text(context.site.description)
                            )
                        ),
                        .itemList(
                            for: context.allItems(
                                sortedBy: \.date,
                                order: .descending
                            ),
                            on: context.site
                        )
                    ),
                    .footer(for: context.site)
                )
            )
        }

        func makeSectionHTML(for section: Section<HalloSwift>, context: PublishingContext<HalloSwift>) throws -> HTML {
            HTML(
                .lang(context.site.language),
                .head(for: section, on: context.site, stylesheetPaths: css),
                .body(
                    .header(for: context),
                    .wrapper(
                        .h1(.text(section.title)),
                        .itemList(for: section.items, on: context.site)
                    ),
                    .footer(for: context.site)
                )
            )
        }

        func makeItemHTML(for item: Item<HalloSwift>, context: PublishingContext<HalloSwift>) throws -> HTML {
            HTML(
                .head(for: item, on: context.site, stylesheetPaths: css),
                .body(
                    .class("item-page"),
                    .header(for: context),
                    .wrapper(
                        .article(
                            .class("content"),
                            .div(
                                .audioPlayer(for: item.metadata.audio,
                                             showControls: true),
                                .contentBody(item.body)
                            ),
                            .span("Heute mit: "),
                            .ul(.class("host-list"), .forEach(item.metadata.speaker) { speaker in
                                .li(.span(.class("speaker-social"), .socialDetail(for: speaker)))
                            }),
                            .tagList(for: item, on: context.site)
                        )
                    ),
                    .footer(for: context.site)
                )
            )
        }

        func makePageHTML(for page: Page, context: PublishingContext<HalloSwift>) throws -> HTML {
            HTML(
                .lang(context.site.language),
                .head(for: page, on: context.site, stylesheetPaths: css),
                .body(
                    .header(for: context),
                    .wrapper(.contentBody(page.body)),
                    .footer(for: context.site)
                )
            )
        }

        func makeTagListHTML(for page: TagListPage, context: PublishingContext<HalloSwift>) throws -> HTML? {
            HTML(
                .lang(context.site.language),
                .head(for: page, on: context.site, stylesheetPaths: css),
                .body(
                    .header(for: context),
                    .wrapper(
                        .h1("Alle Tags"),
                        .ul(
                            .class("all-tags"),
                            .forEach(page.tags.sorted()) { tag in
                                .li(
                                    .class("tag"),
                                    .a(
                                        .href(context.site.path(for: tag)),
                                        .text(tag.string)
                                    )
                                )
                            }
                        )
                    ),
                    .footer(for: context.site)
                )
            )
        }

        func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<HalloSwift>) throws -> HTML? {
            HTML(
                .lang(context.site.language),
                .head(for: page, on: context.site, stylesheetPaths: css),
                .body(
                    .header(for: context),
                    .wrapper(
                        .h1(
                            "Getagged mit ",
                            .span(.class("tag"), .text(page.tag.string))
                        ),
                        .a(
                            .class("browse-all"),
                            .text("Alle Tags"),
                            .href(context.site.tagListPath)
                        ),
                        .itemList(
                            for: context.items(
                                taggedWith: page.tag,
                                sortedBy: \.date,
                                order: .descending
                            ),
                            on: context.site
                        )
                    ),
                    .footer(for: context.site)
                )
            )
        }

    }
}

private extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
    }

    static func header<T: Website>(for context: PublishingContext<T>) -> Node {
        let pages = context.pages.values.sorted { lhs, rhs in
            lhs.path < rhs.path
        }
        return .header(
            .nav(
                .ul(
                    .li(.class("site-name"), .a(.href("/"), .text(context.site.name))),
                    .forEach(pages) { page in
                        .li(.a(.href(page.path), .text(page.title)))
                    }
                )
            )
        )
    }

    static func itemList(for items: [Item<HalloSwift>], on site: HalloSwift) -> Node {
        .ul(
            .class("item-list"),
            .forEach(items) { item in
                return .li(.article(
                    .h1(
                        .a(.href(item.path), .text(item.title)),
                        .span(.class("episode-number"), .text(item.metadata.episode))
                    ),
                    .tagList(for: item, on: site),
                    .p(.text(item.description))
                ))
            }
        )
    }

    static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
        .ul(.class("tag-list"), .forEach(item.tags) { tag in
            .li(.class("tag"),
                .a(
                    .href(site.path(for: tag)),
                    .text(tag.string)
                )
            )
        })
    }

    static func footer(for site: HalloSwift) -> Node {
        .footer(
            .p(
                .a(.class("symbol"), .href(site.githubURL), .i(.class("fa fa-github"))),
                .a(.class("symbol"), .href(site.twitterURL), .i(.class("fa fa-twitter")))
            ),
            .p(
                .a(.img(.src("/HalloSwiftTheme/badge-apple.svg")), .href(site.iTunesURL)),
                .a(.img(.src("/HalloSwiftTheme/badge-rss.svg")), .href("/feed.xml"))
            ),
            .p(
                .class("small"),
                .text("© Copyright 2017-\(currentYear) Hallo Swift")
            )
        )
    }

    static var currentYear: Int {
        Calendar(identifier: .gregorian).component(.year, from: Date())
    }
}
