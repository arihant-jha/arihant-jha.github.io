from fasthtml.common import FastHTML, Html, Head, Title, Body, H1, P
from fasthtml.common import Style, Meta
from fasthtml.common import serve

app = FastHTML()


@app.get("/")
def home():
    return Html(
        Head(
            Title("Emberwood Blog"),
            Meta(charset="utf-8"),
            Meta(name="viewport", content="width=device-width, initial-scale=1"),
            Style(
                """
                body {
                    margin: 0;
                    font-family: 'Inter', system-ui, sans-serif;
                    display: grid;
                    place-items: center;
                    min-height: 100vh;
                    color: #1b1b1f;
                    background: #f2f2f5;
                }
                h1 {
                    margin: 0;
                    font-size: 2.4rem;
                }
                p {
                    margin: 0.4rem 0 0;
                    color: #4a4a55;
                }
                """
            ),
        ),
        Body(
            H1("Hello, Emberwood"),
            P("FastHTML is serving a minimal hello world."),
        ),
    )


if __name__ == "__main__":
    serve()
