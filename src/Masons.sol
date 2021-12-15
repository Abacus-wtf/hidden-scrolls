// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.10;

/*
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////

_▄█        ▄██████▄     ▄████████ ████████▄     ▄████████
███       ███    ███   ███    ███ ███   ▀███   ███    ███
███       ███    ███   ███    ███ ███    ███   ███    █▀
███       ███    ███  ▄███▄▄▄▄██▀ ███    ███   ███
███       ███    ███ ▀▀███▀▀▀▀▀   ███    ███ ▀███████████
███       ███    ███ ▀███████████ ███    ███          ███
███▌    ▄ ███    ███   ███    ███ ███   ▄███    ▄█    ███
█████▄▄██  ▀██████▀    ███    ███ ████████▀   ▄████████▀
▀                      ███    ███

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
*/

// NFT contract to inherit from.
/// @dev Waiting for solmate ERC721 impl
import {ERC721} from "zeppelin-solidity/token/ERC721/ERC721.sol";

/// @title Masons
/// @author abigger87
/// @dev ASCII Text generated with https://patorjk.com/software/taag/#p=display&f=Delta%20Corps%20Priest%201&t=Scroll
contract Masons is ERC721("Masons", "aMASN") {
  
  function baseURI() public view returns (string memory) {
        return _baseURI();
    }

    function exists(uint256 tokenId) public view returns (bool) {
        return _exists(tokenId);
    }

    function mint(address to, uint256 tokenId) public {
        _mint(to, tokenId);
    }

    function safeMint(address to, uint256 tokenId) public {
        _safeMint(to, tokenId);
    }

    function safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public {
        _safeMint(to, tokenId, _data);
    }

    function burn(uint256 tokenId) public {
        _burn(tokenId);
    }
}
