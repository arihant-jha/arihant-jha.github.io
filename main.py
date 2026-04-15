from fasthtml.common import *

hdrs = (picolink, Script(src="https://cdn.tailwindcss.com"),
    Link(rel="stylesheet", href="https://cdn.jsdelivr.net/npm/daisyui@4.11.1/dist/full.min.css"))
app = FastHTML(hdrs=hdrs)
rt = app.route

@rt('/')
def get(): return Div(P('Hello World!'), hx_get="/change")

if __name__ == "__main__":
    serve(port=5050, reload=True)
