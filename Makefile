.PHONY: install dev build lint check

install:
	pnpm install

dev:
	pnpm dev

build:
	pnpm build

lint:
	pnpm lint

check: lint build
