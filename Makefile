assets:
	typst compile example.typ --format png .github/assets/preview-{p}.png
	typst compile example.typ example.pdf
