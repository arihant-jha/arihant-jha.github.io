from fasthtml.common import (
    FastHTML,
    serve,
    Html,
    Head,
    Title,
    Meta,
    Style,
    Body,
    Div,
    Section,
    H1,
    H2,
    P,
    Ul,
    Li,
    A,
    Small,
    Footer,
)
from starlette.exceptions import HTTPException

app = FastHTML()

SITE_TITLE = "Emberwood Blog"

posts = [
    {
        "slug": "returning-to-slow-reads",
        "title": "Returning to Slow Reads",
        "date": "April 7, 2026",
        "summary": "Why I’m carving out morning rituals that let me savor a few chapters before booting the laptop.",
        "body": "Once the inbox opens, the day feels like a race. I’m rediscovering the patience to sit with a book, underline passages, and let the ideas breathe."
    },
    {
        "slug": "mini-travel-journal",
        "title": "Mini Travel Journal: Copper Lakes",
        "date": "March 12, 2026",
        "summary": "A lakeside retreat that proved quiet mornings reset everything that feels heavy.",
        "body": "The early mist on Copper Lakes holds a sweetness that only a brief silence can pull out. I hiked three miles before sunrise and felt the plans for the year settle into place."
    },
    {
        "slug": "markdown-for-dinners",
        "title": "Markdown for Dinners",
        "date": "February 24, 2026",
        "summary": "Using FastHTML tables and styling to jot down weekly meals and notes for whoever cooks next.",
        "body": "This format keeps the grocery list within reach and the gratitude short but sharp — just the way dinner conversations are supposed to land."
    },
]

styles = """
:root {
    font-family: 'Inter', system-ui, sans-serif;
    color: #1d1d1f;
    background-color: #f4f4f7;
    line-height: 1.7;
}
body {
    margin: 0;
    min-height: 100vh;
}
main {
    max-width: 900px;
    margin: 0 auto;
    padding: 2.5rem 1.25rem 4rem;
}
.hero {
    background: #121212;
    color: white;
    padding: 3rem 2rem;
    border-radius: 1rem;
    margin-bottom: 2rem;
    box-shadow: 0 10px 30px rgba(0,0,0,0.25);
}
.section-title {
    display: flex;
    justify-content: space-between;
    align-items: baseline;
}
ul.posts {
    list-style: none;
    padding: 0;
    margin: 0;
}
li.post-card {
    background: white;
    border-radius: 0.75rem;
    padding: 1.5rem;
    margin-bottom: 1rem;
    box-shadow: 0 10px 25px rgba(0,0,0,0.08);
}
li.post-card a {
    color: inherit;
    text-decoration: none;
}
li.post-card h3 {
    margin-top: 0;
    margin-bottom: 0.25rem;
}
li.post-card small {
    color: #5c5c64;
}
.footer {
    border-top: 1px solid rgba(0,0,0,0.08);
    padding-top: 1.5rem;
    margin-top: 3rem;
    text-align: center;
    color: #777;
}
@media (max-width: 600px) {
    .hero {
        padding: 2rem;
    }
}
"""


@app.get("/")
def home():
    return Html(
        Head(
            Title(SITE_TITLE),
            Meta(charset="utf-8"),
            Meta(name="viewport", content="width=device-width, initial-scale=1"),
            Style(styles),
        ),
        Body(
            Div(
                Section(
                    Div(
                        H1("Emberwood Blog", cls="hero-title"),
                        P("Thoughts, experiments, and tiny lists from the firewood-scented corner of the web."),
                    ),
                    cls="hero",
                ),
                Section(
                    Div(
                        Div("Latest Notes", cls="section-title"),
                        Ul(
                            *[
                                Li(
                                    A(
                                        H2(post["title"], cls="post-title"),
                                        P(post["summary"]),
                                        Small(post["date"]),
                                        href=f"/posts/{post['slug']}",
                                    ),
                                    cls="post-card",
                                )
                                for post in posts
                            ],
                            cls="posts",
                        ),
                    ),
                ),
            ),
            Footer(
                P("Powered by FastHTML • Deployed on Railway."),
                cls="footer",
            ),
        ),
    )


@app.get("/posts/{slug}")
def post_detail(slug: str):
    post = next((p for p in posts if p["slug"] == slug), None)
    if not post:
        raise HTTPException(status_code=404, detail="Post not found")

    return Html(
        Head(
            Title(post["title"]),
            Meta(charset="utf-8"),
            Meta(name="viewport", content="width=device-width, initial-scale=1"),
            Style(styles),
        ),
        Body(
            Div(
                Section(
                    Div(
                        A("← Back", href="/"),
                        H1(post["title"]),
                        Small(post["date"]),
                        Div(
                            P(post["body"], cls="post-body-text"),
                        ),
                    )
                ),
            ),
            Footer(
                P("Emberwood Blog • FastHTML preview"),
                cls="footer",
            ),
        ),
    )


if __name__ == "__main__":
    serve()
