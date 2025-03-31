.PHONY: run

run:
	@flutter run --debug \
		--dart-define-from-file=.version \
		--pub
