prepare: venv submodules builder-images

.PHONY: venv
venv:
	python3 -m venv venv
	venv/bin/pip install 'cachi2 @ git+https://github.com/chmeliik/cachi2@wheelios'

.PHONY: submodules
submodules:
	git submodule update --init

.PHONY: builder-images
builder-images:
	podman build -f dockerfiles/atomic-reactor/wheelbuilder.Dockerfile -t atomic-reactor-wheelbuilder
	podman build -f dockerfiles/atomic-reactor/sdistbuilder.Dockerfile -t atomic-reactor-sdistbuilder
	podman build -f dockerfiles/cachi2/wheelbuilder.Dockerfile -t cachi2-wheelbuilder
	podman build -f dockerfiles/cachi2/sdistbuilder.Dockerfile -t cachi2-sdistbuilder

.PHONY: dashdotdb-wheels
dashdotdb-wheels:
	./prefetch.sh repos/dashdotdb-wheels
	./build.sh repos/dashdotdb-wheels

.PHONY: dashdotdb-sdists
dashdotdb-sdists:
	./prefetch.sh repos/dashdotdb-sdists
	./build.sh repos/dashdotdb-sdists

.PHONY: atomic-reactor-wheels
atomic-reactor-wheels:
	./prefetch.sh repos/atomic-reactor-wheels
	./build.sh repos/atomic-reactor-wheels -f dockerfiles/atomic-reactor/wheel.Dockerfile

.PHONY: atomic-reactor-sdists
atomic-reactor-sdists:
	./prefetch.sh repos/atomic-reactor-sdists
	./build.sh repos/atomic-reactor-sdists -f dockerfiles/atomic-reactor/sdist.Dockerfile

.PHONY: cachi2-wheels
cachi2-wheels:
	./prefetch.sh repos/cachi2-wheels
	./build.sh repos/cachi2-wheels -f dockerfiles/cachi2/wheel.Dockerfile

.PHONY: cachi2-sdists
cachi2-sdists:
	./prefetch.sh repos/cachi2-sdists
	./build.sh repos/cachi2-sdists -f dockerfiles/cachi2/sdist.Dockerfile
