GOPATH	:= $(shell pwd)
GOBIN	:= ${GOPATH}/bin
PATH	:= ${GOBIN}:${PATH}

export GOPATH
export GOBIN
export PATH

all: server client

server:
	cd src/server && goapp build

client:
	cd src/client && go install

serve:
	goapp serve src/server


boltdb_URL		:= https://github.com/boltdb/bolt.git
boltdb_version		:= v1.1.0
boltdb_path		:= src/github.com/boltdb/bolt

govendor_URL		:= https://github.com/kardianos/govendor.git
govendor_version	:= 8f0ca0d38f51fd780feb6fa0698c6bc4f58ba996
govendor_path		:= src/github.com/kardianos/govendor

safefile_URL		:= https://github.com/dchest/safefile.git
safefile_version	:= 855e8d98f1852d48dde521e0522408d1fe7e836a
safefile_path		:= src/github.com/dchest/safefile

gorillamux_URL		:= https://github.com/gorilla/mux.git
gorillamux_version	:= 26a6070f849969ba72b72256e9f14cf519751690
gorillamux_path		:= src/github.com/gorilla/mux

gorillactx_URL		:= https://github.com/gorilla/context.git
gorillactx_version	:= 1c83b3eabd45b6d76072b66b746c20815fb2872d
gorillactx_path		:= src/github.com/gorilla/context

binding_URL		:= https://github.com/mholt/binding.git
binding_version		:= 89411c4ffb61f0ebef45d8bdb830103b358ef9fa
binding_path		:= src/github.com/mholt/binding

uuid_URL		:= https://github.com/satori/go.uuid.git
uuid_version		:= d41af8bb6a7704f00bc3b7cba9355ae6a5a80048
uuid_path		:= src/github.com/satori/go.uuid

ishell_URL		:= https://github.com/abiosoft/ishell.git
ishell_version		:= 72b49343026dad59165eab20454a998f99950b22
ishell_path		:= src/github.com/abiosoft/ishell

goshlex_URL		:= https://github.com/flynn-archive/go-shlex.git
goshlex_version		:= 3f9db97f856818214da2e1057f8ad84803971cff
goshlex_path		:= src/github.com/flynn/go-shlex

readline_URL		:= https://github.com/chzyer/readline.git
readline_version	:= v1.1
# XXX readline_path is overridden by deps-readline stupidity
readline_path		:= src/github.com/chzyer/readline
readline_realpath	:= src/gopkg.in/readline.v1

xcrypto_URL		:= https://github.com/golang/crypto.git
xcrypto_version		:= 1f22c0103821b9390939b6776727195525381532
xcrypto_path		:= src/golang.org/x/crypto


DEPS	:= \
	govendor \
	safefile \
	gorillamux \
	gorillactx \
	binding \
	uuid \
	\
	goshlex \
	xcrypto\
	readline \
	ishell \

#
# This extra mv is because for some reason git strips off the ".v1" from the destination dir name,
# 	git clone https://github.com/chzyer/readline.git -o readline.v1 
# So even though this should cause the repository to be cloned into a directory named "readline.v1", it
# actually ends up in a directory named "readline".  WTF?
#
deps-readline:
	./bin/git-fetch-version ${readline_URL} ${readline_version} ${readline_path}
	mkdir -p src/gopkg.in
	cd src/gopkg.in && ln -s ../../${readline_path} readline.v1

deps-xcrypto:
	./bin/git-fetch-version ${xcrypto_URL} ${xcrypto_version} ${xcrypto_path}

deps-goshlex:
	./bin/git-fetch-version ${goshlex_URL} ${goshlex_version} ${goshlex_path}

deps-ishell:
	./bin/git-fetch-version ${ishell_URL} ${ishell_version} ${ishell_path}
	cd ${ishell_path} && go build

deps-uuid:
	./bin/git-fetch-version ${uuid_URL} ${uuid_version} ${uuid_path}

deps-binding:
	./bin/git-fetch-version ${binding_URL} ${binding_version} ${binding_path}

deps-gorillactx:
	./bin/git-fetch-version ${gorillactx_URL} ${gorillactx_version} ${gorillactx_path}

deps-gorillamux:
	./bin/git-fetch-version ${gorillamux_URL} ${gorillamux_version} ${gorillamux_path}

deps-boltdb:
	./bin/git-fetch-version ${boltdb_URL} ${boltdb_version} ${boltdb_path}
	cd ${boltdb_path} && ${MAKE} build
	cd ${boltdb_path} && cp bin/bolt ${GOPATH}/bin

deps-safefile:
	./bin/git-fetch-version ${safefile_URL} ${safefile_version} ${safefile_path}

deps-govendor: deps-safefile
	./bin/git-fetch-version ${govendor_URL} ${govendor_version} ${govendor_path}
	cd ${govendor_path} && go install

deps: ${DEPS:%=deps-%}

clean:
	rm -rf pkg
	rm -rf $(foreach dir,${DEPS},${${dir}_path})
	rm -rf $(foreach dir,${DEPS},${${dir}_realpath})
	./bin/prune-empty-dirs src
