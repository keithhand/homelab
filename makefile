ENTRY_PATH=cmd/homelab
ENTRY_SCRIPT=homelab.go
RUN_COMMANDS=down up refresh

build:
	@go build -C $(ENTRY_PATH) -o ../../bin/

install: build
	@go install $(ENTRY_PATH)/$(ENTRY_SCRIPT)

$(RUN_COMMANDS):
	@go run $(ENTRY_PATH)/$(ENTRY_SCRIPT) $@
