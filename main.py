from fasthtml.common import *

hdrs = (
    Script(src="https://cdn.tailwindcss.com"),
    Link(
        rel="stylesheet",
        href="https://cdn.jsdelivr.net/npm/daisyui@4.11.1/dist/full.min.css",
    ),
    Link(
        rel="stylesheet",
        href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,400;9..144,600&family=Space+Grotesk:wght@400;500;600&display=swap",
    ),
)
app = FastHTML(hdrs=hdrs, debug=True)
rt = app.route

TABS = [
    "Builder",
    "Open Saas",
    "Community",
    "Coach",
    "Book to App",
    "Find Your People",
    "Personal Agents",
    "Idea Land",
    "Website to cli",
    "External Connector",
    "Gallery to Insta",
]


@rt("/")
def get():
    return Div(
        Title("axh"),
        Div(
            Div(
                H1("axh", cls="text-4xl font-semibold tracking-tight"),
                P(
                    "my idealand",
                    cls="text-sm opacity-70",
                ),
                cls="space-y-1",
            ),
            cls="p-6",
        ),
        Div(
            # Left sidebar
            Div(
                Div(
                    *[
                        A(
                            label,
                            cls="tab tab-bordered w-full justify-start",
                            hx_get=f"/tab/{i}",
                            hx_target="#content",
                            hx_swap="innerHTML",
                        )
                        for i, label in enumerate(TABS)
                    ],
                    cls="tabs tabs-vertical flex flex-col w-full",
                ),
                cls="w-64 shrink-0 p-4 border-r border-base-200",
            ),
            # Main content placeholder
            Div(
                Div(
                    id="content",
                    hx_get="/tab/0",
                    hx_trigger="load",
                ),
                cls="flex-1 p-6",
            ),
            cls="flex min-h-[70vh]",
        ),
        cls="min-h-screen text-base-content font-[Space_Grotesk]",
        data_theme="dark",
    )


@rt("/tab/{i}")
def tab(i: int):
    if i < 0 or i >= len(TABS):
        return Div(
            H2("Not Found", cls="text-xl font-medium"),
            cls="h-full w-full flex items-center justify-center p-10",
        )
    return Div(
        H2(TABS[i], cls="text-3xl font-semibold"),
        cls="h-full w-full flex items-center justify-center p-10",
    )


if __name__ == "__main__":
    serve(port=5050, reload=True)
