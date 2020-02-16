import Foundation
import Publish
import Plot

extension Theme where Site == HalloSwift {
    static var halloSwift: Self {
        Theme(htmlFactory: HalloSwiftHTMLFactory(),
              resourcePaths: ["Resources/HalloSwiftTheme/styles.css"])
    }

    private struct HalloSwiftHTMLFactory: HTMLFactory {
        private var fontAwesomeCSS: Path = "https://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css"

        func makeIndexHTML(for index: Index, context: PublishingContext<HalloSwift>) throws -> HTML {
            HTML(
                .lang(context.site.language),
                .head(for: index, on: context.site, stylesheetPaths: [fontAwesomeCSS]),
                .body(
                    .header(for: context, selectedSection: nil),
                    .wrapper(
                        .h1(.text(index.title)),
                        .p(
                            .class("description"),
                            .text(context.site.description)
                        ),
                        .h2("Letzte Folgen"),
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
                .head(for: section, on: context.site, stylesheetPaths: [fontAwesomeCSS]),
                .body(
                    .header(for: context, selectedSection: section.id),
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
                .head(for: item, on: context.site, stylesheetPaths: [fontAwesomeCSS]),
                .body(
                    .class("item-page"),
                    .header(for: context, selectedSection: item.sectionID),
                    .wrapper(
                        .article(
                            .div(
                                .class("content"),
                                .audioPlayer(for: Audio(url: item.metadata.mp3URL, format: .mp3), showControls: true),
                                .contentBody(item.body)
                            ),
                            .span("Heute mit: "),
                            .ul(.class("host-list"), .forEach(item.metadata.speaker) { speaker in
                                .li(.span(.class("speaker-social"), .socialDetail(for: speaker)))
                            }),
                            .span("Tags: "),
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
                .head(for: page, on: context.site, stylesheetPaths: [fontAwesomeCSS]),
                .body(
                    .header(for: context, selectedSection: nil),
                    .wrapper(.contentBody(page.body)),
                    .footer(for: context.site)
                )
            )
        }

        func makeTagListHTML(for page: TagListPage, context: PublishingContext<HalloSwift>) throws -> HTML? {
            HTML(
                .lang(context.site.language),
                .head(for: page, on: context.site, stylesheetPaths: [fontAwesomeCSS]),
                .body(
                    .header(for: context, selectedSection: nil),
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
                .head(for: page, on: context.site, stylesheetPaths: [fontAwesomeCSS]),
                .body(
                    .header(for: context, selectedSection: nil),
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

    static func header<T: Website>(
        for context: PublishingContext<T>,
        selectedSection: T.SectionID?
    ) -> Node {
        let sectionIDs = T.SectionID.allCases

        return .header(
            .wrapper(
                .a(.class("site-name"), .href("/"), .text(context.site.name)),
                .if(sectionIDs.count > 1,
                    .nav(
                        .ul(.forEach(sectionIDs) { section in
                            .li(.a(
                                .class(section == selectedSection ? "selected" : ""),
                                .href(context.sections[section].path),
                                .text(context.sections[section].title)
                            ))
                        })
                    )
                )
            )
        )
    }

    static func itemList(for items: [Item<HalloSwift>], on site: HalloSwift) -> Node {
        .ul(
            .class("item-list"),
            .forEach(items) { item in
                .li(.article(
                    .h1(.a(
                        .href(item.path),
                        .text("\(item.metadata.number) - \(item.title)")
                    )),
                    .tagList(for: item, on: site),
                    .p(.text(item.description))
                ))
            }
        )
    }

    static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
        .ul(.class("tag-list"), .forEach(item.tags) { tag in
            .li(.a(
                .href(site.path(for: tag)),
                .text(tag.string)
            ))
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
                .a(.img(.src("/HalloSwiftTheme/badge-rss.svg")), .href(site.rssFeed))
            ),
            .p(
                .text("© Copyright 2017-\(currentYear) Hallo Swift")
            )
        )
    }

    static var currentYear: Int {
        Calendar(identifier: .gregorian).component(.year, from: Date())
    }
}
