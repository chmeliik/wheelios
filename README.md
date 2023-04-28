# Cachi2 on Wheels

Investigation: how much would downloading Python wheels (not just sdists) help with
hermetic builds?

## Usage

Prepare everything

```shell
make prepare
source venv/bin/activate
```

Do a hermetic build with/without wheels for a sample project

```shell
make atomic-reactor-sdists
make atomic-reactor-wheels

make dashdotdb-sdists
make dashdotdb-wheels
```
