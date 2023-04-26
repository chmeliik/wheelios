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
	podman build -f atomic-reactor-dockerfiles/wheelbuilder.Dockerfile -t atomic-reactor-wheelbuilder
	podman build -f atomic-reactor-dockerfiles/sdistbuilder.Dockerfile -t atomic-reactor-sdistbuilder

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
	./build.sh repos/atomic-reactor-wheels -f atomic-reactor-dockerfiles/wheel.Dockerfile

.PHONY: atomic-reactor-sdists
atomic-reactor-sdists:
	./prefetch.sh repos/atomic-reactor-sdists
	./build.sh repos/atomic-reactor-sdists -f atomic-reactor-dockerfiles/sdist.Dockerfile
