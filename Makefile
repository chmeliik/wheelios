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
