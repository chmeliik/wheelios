prepare: venv submodules

.PHONY: venv
venv:
	python3 -m venv venv
	venv/bin/pip install 'cachi2 @ git+https://github.com/chmeliik/cachi2@wheelios'

.PHONY: submodules
submodules:
	git submodule update --init
