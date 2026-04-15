from fasthtml.common import FastHTML, Html, Head, Title, Body, H1, Meta
from fasthtml.common import serve

app = FastHTML()


@app.get("/")
def home():
    return Html(
        Head(
            Title("Hello World"),
            Meta(charset="utf-8"),
            Meta(name="viewport", content="width=device-width, initial-scale=1"),
        ),
        Body(
            H1("Hello World"),
        ),
    )


if __name__ == "__main__":
    serve()
