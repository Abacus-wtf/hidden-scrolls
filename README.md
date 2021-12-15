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

### Notes

Until [solmate](https://github.com/Rari-Capital/solmate) has native ERC721 support, we use Open Zeppelin's ERC721 implementation. This requires us to workaround the differing source directory name `contracts` instead of Dapptool's expected `src`. To do this we can run:

```bash
ln -s contracts lib/zeppelin-solidity/src
echo /src >>.git/modules/lib/zeppelin-solidity/info/exclude
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

### Generate Base64 encoding using Openssl

```bash
echo -n "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><defs><pattern id='imgpattern' x='0' y='0' width='1' height='1'><image width='350' height='350' href='https://lh3.googleusercontent.com/proxy/m1seWtOYFyO7PKJTJZdvtvKh97PjWiPVxeiXfPjYsz-LgyOfdEOB2Tl5qEUUJWgS-CjqBgnz898DQOI-tOTFUERLA6b6ynd6'/></pattern></defs><style>.base { fill: black; font-family: Apple Chancery, cursive; font-size: 12px; }</style><rect width='100%' height='100%' fill='url(#imgpattern)' d='M 100,100 L 120,110 150,90 170,220 70,300 50,250 50,200 70,100 50,70 Z' /><text class='base' margin='2px' x='98px' y='62px'>lore</text></svg>" | openssl base64
```

Outputs:

```bash
PHN2ZyB4bWxucz0naHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmcnIHByZXNlcnZl
QXNwZWN0UmF0aW89J3hNaW5ZTWluIG1lZXQnIHZpZXdCb3g9JzAgMCAzNTAgMzUw
Jz48ZGVmcz48cGF0dGVybiBpZD0naW1ncGF0dGVybicgeD0nMCcgeT0nMCcgd2lk
dGg9JzEnIGhlaWdodD0nMSc+PGltYWdlIHdpZHRoPSczNTAnIGhlaWdodD0nMzUw
JyBocmVmPSdodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vcHJveHkv
bTFzZVd0T1lGeU83UEtKVEpaZHZ0dktoOTdQaldpUFZ4ZWlYZlBqWXN6LUxneU9m
ZEVPQjJUbDVxRVVVSldnUy1DanFCZ256ODk4RFFPSS10T1RGVUVSTEE2YjZ5bmQ2
Jy8+PC9wYXR0ZXJuPjwvZGVmcz48c3R5bGU+LmJhc2UgeyBmaWxsOiBibGFjazsg
Zm9udC1mYW1pbHk6IEFwcGxlIENoYW5jZXJ5LCBjdXJzaXZlOyBmb250LXNpemU6
IDEycHg7IH08L3N0eWxlPjxyZWN0IHdpZHRoPScxMDAlJyBoZWlnaHQ9JzEwMCUn
IGZpbGw9J3VybCgjaW1ncGF0dGVybiknIGQ9J00gMTAwLDEwMCBMIDEyMCwxMTAg
MTUwLDkwIDE3MCwyMjAgNzAsMzAwIDUwLDI1MCA1MCwyMDAgNzAsMTAwIDUwLDcw
IFonIC8+PHRleHQgY2xhc3M9J2Jhc2UnIG1hcmdpbj0nMnB4JyB4PSc5OHB4JyB5
PSc2MnB4Jz5sb3JlPC90ZXh0Pjwvc3ZnPg==
```

Adding the image prepend we get:

```
data:image/svg+xml;base64,PHN2ZyB4bWxucz0naHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmcnIHByZXNlcnZl
QXNwZWN0UmF0aW89J3hNaW5ZTWluIG1lZXQnIHZpZXdCb3g9JzAgMCAzNTAgMzUw
Jz48ZGVmcz48cGF0dGVybiBpZD0naW1ncGF0dGVybicgeD0nMCcgeT0nMCcgd2lk
dGg9JzEnIGhlaWdodD0nMSc+PGltYWdlIHdpZHRoPSczNTAnIGhlaWdodD0nMzUw
JyBocmVmPSdodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vcHJveHkv
bTFzZVd0T1lGeU83UEtKVEpaZHZ0dktoOTdQaldpUFZ4ZWlYZlBqWXN6LUxneU9m
ZEVPQjJUbDVxRVVVSldnUy1DanFCZ256ODk4RFFPSS10T1RGVUVSTEE2YjZ5bmQ2
Jy8+PC9wYXR0ZXJuPjwvZGVmcz48c3R5bGU+LmJhc2UgeyBmaWxsOiBibGFjazsg
Zm9udC1mYW1pbHk6IEFwcGxlIENoYW5jZXJ5LCBjdXJzaXZlOyBmb250LXNpemU6
IDEycHg7IH08L3N0eWxlPjxyZWN0IHdpZHRoPScxMDAlJyBoZWlnaHQ9JzEwMCUn
IGZpbGw9J3VybCgjaW1ncGF0dGVybiknIGQ9J00gMTAwLDEwMCBMIDEyMCwxMTAg
MTUwLDkwIDE3MCwyMjAgNzAsMzAwIDUwLDI1MCA1MCwyMDAgNzAsMTAwIDUwLDcw
IFonIC8+PHRleHQgY2xhc3M9J2Jhc2UnIG1hcmdpbj0nMnB4JyB4PSc5OHB4JyB5
PSc2MnB4Jz5sb3JlPC90ZXh0Pjwvc3ZnPg==
```

We can then paste this string in our browser url to render as an image!