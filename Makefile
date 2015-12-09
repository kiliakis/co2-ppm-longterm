#version="0.1.0"

all: detailed vostok

detailed:
	bash scripts/process.sh

vostok:
	python scripts/process-ice-core.py

clean:
	rm data/* tmp/*

.PHONY: clean
