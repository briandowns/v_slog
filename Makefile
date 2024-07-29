all: fmt vet test 

.PHONY: test
test:
	v -stats test ./

.PHONY: fmt
fmt:
	v fmt -w .

.PHONY: vet
vet:
	v vet -w .
