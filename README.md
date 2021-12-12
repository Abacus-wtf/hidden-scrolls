<h3 align="center">📜 Hidden Scrolls 📜</h3>

<div align="center">

[![Tests](https://github.com/abacus-wtf/hidden-scrolls/actions/workflows/tests.yml/badge.svg)](https://github.com/abacus-wtf/hidden-scrolls/actions/workflows/tests.yml)
[![Lints](https://github.com/abacus-wtf/hidden-scrolls/actions/workflows/lints.yml/badge.svg)](https://github.com/abacus-wtf/hidden-scrolls/actions/workflows/lints.yml)
[![License](https://img.shields.io/badge/License-AGPL--3.0-blue)](LICENSE.md)

</div>

<p align="center">Abacus Folklore hidden entirely on-chain.</p>

## Architecture

- [`FolkloreBook.sol`](src/FolkloreBook.sol): The main factory containing all hidden scrolls.
- [`HiddenScroll.sol`](src/HiddenScroll.sol): Hidden Scroll is a folklore instance deployed and managed by the FolkloreBook.

## Contributing

Install [DappTools](https://dapp.tools) with the official [installation guide](https://github.com/dapphub/dapptools#installation).

All Contributions are welcome! Open an issue to request repository contributor access!

### Setup

```sh
git clone https://github.com/abacus-wtf/hidden-scrolls.git
cd hidden-scrolls
make
```

### Run Tests

```sh
dapp test
```

### Measure Coverage

```sh
dapp test --coverage
```

### Update Gas Snapshots

```sh
dapp snapshot
```

### Generate Pretty Visuals

We use [surya](https://github.com/ConsenSys/surya) to create contract diagrams.

Run `yarn visualize` to generate an amalgamated contract visualization in the `./assets/` directory. Or use the below commands for each respective contract.
