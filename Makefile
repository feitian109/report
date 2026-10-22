assets:
	mkdir -p .github/assets
	typst compile example.typ --format png .github/assets/preview-{p}.png
	typst compile example.typ example.pdf

filter:
	git filter-repo \
		--path-glob '*.pdf' \
		--path-glob '*.jpg' \
		--path-glob '*.png' \
		--invert-paths
