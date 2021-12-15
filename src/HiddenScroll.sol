// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.10;

/*//////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////

   ▄█    █▄     ▄█  ████████▄  ████████▄     ▄████████ ███▄▄▄▄   
  ███    ███   ███  ███   ▀███ ███   ▀███   ███    ███ ███▀▀▀██▄ 
  ███    ███   ███▌ ███    ███ ███    ███   ███    █▀  ███   ███ 
 ▄███▄▄▄▄███▄▄ ███▌ ███    ███ ███    ███  ▄███▄▄▄     ███   ███ 
▀▀███▀▀▀▀███▀  ███▌ ███    ███ ███    ███ ▀▀███▀▀▀     ███   ███ 
  ███    ███   ███  ███    ███ ███    ███   ███    █▄  ███   ███ 
  ███    ███   ███  ███   ▄███ ███   ▄███   ███    ███ ███   ███ 
  ███    █▀    █▀   ████████▀  ████████▀    ██████████  ▀█   █▀  

   ▄████████  ▄████████    ▄████████  ▄██████▄   ▄█        ▄█       
  ███    ███ ███    ███   ███    ███ ███    ███ ███       ███       
  ███    █▀  ███    █▀    ███    ███ ███    ███ ███       ███       
  ███        ███         ▄███▄▄▄▄██▀ ███    ███ ███       ███       
▀███████████ ███        ▀▀███▀▀▀▀▀   ███    ███ ███       ███       
         ███ ███    █▄  ▀███████████ ███    ███ ███       ███       
   ▄█    ███ ███    ███   ███    ███ ███    ███ ███▌    ▄ ███▌    ▄ 
 ▄████████▀  ████████▀    ███    ███  ▀██████▀  █████▄▄██ █████▄▄██ 
                          ███    ███            ▀         ▀       

///////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////*/

/// Note: Waiting for solmate ERC721 impl
import {ERC721} from "zeppelin-solidity/token/ERC721/ERC721.sol";

import {MintAuthority} from "./MintAuthority.sol";

/// @title HiddenScroll
/// @author abigger87
/// @dev This contract is a folklore instance deployed by the [FolkloreBook](./FolkloreBook.sol) contract.
/// @dev ASCII Text generated with https://patorjk.com/software/taag/#p=display&f=Delta%20Corps%20Priest%201&t=Scroll
contract HiddenScroll is ERC721("Hidden Scroll", "aSCROLL"), MintAuthority {

  /// @notice The current token ID
  uint256 internal currTokenId;

  /// @dev the base svg as a string
  string constant BASE_SVG = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' />";

  constructor(
    address _mintAuthority
  ) {
    OWNER = msg.sender;
    mintAuthority = _mintAuthority;
  }

  function baseURI() public view returns (string memory) {
      return _baseURI();
  }

  function exists(uint256 tokenId) public view returns (bool) {
      return _exists(tokenId);
  }

  ///////////////////////////////////////////////
  //              MINTING LOGIC                //
  ///////////////////////////////////////////////

  /// @notice Emitted when a Hidden Scroll is minted
  /// @param tokenId The token id of the minted Hidden Scroll
  /// @param book The address to which the Hidden Scroll is minted
  event HiddenScrollMinted(uint256 indexed tokenId, address indexed book);

  /// @notice Mints the Hidden Scroll
  /// @param book The address to mint the hidden scroll to
  /// @param lore The text to write to the scroll
  function mint(address book, string memory lore) external onlyMintAuthority {
      uint256 newItemId = currTokenId;
      string memory newItemString = Strings.toString(newItemId);

      string memory finalSvg = string(
          abi.encodePacked(
              BASE_SVG,
              "<text class='base' margin='2px' x='4%' y='8%'>",
              lore,
              "</text></svg>"
          )
      );

      string memory json = Base64.encode(
          bytes(
              string(
                  abi.encodePacked(
                      '{"name": "Hidden Scrolls ',
                      newItemId,
                      '", "description": "Lore Edition #',
                      newItemId,
                      ' of the Hidden Scrolls Collection", "image": "data:image/svg+xml;base64,',
                      Base64.encode(bytes(finalSvg)),
                      '"}'
                  )
              )
          )
      );

      string memory finalTokenUri = string(
          abi.encodePacked("data:application/json;base64,", json)
      );

      _safeMint(book, newItemId);

      _setTokenURI(newItemId, finalTokenUri);

      currTokenId += 1;

      emit HiddenScrollMinted(newItemId, book);
  }

  /// @notice Emitted when a Hidden Scroll is burned
  /// @param tokenId The Hidden Scroll token id
  /// @param caller The address that initiated the burn
  event HiddenScrollBurned(uint256 indexed tokenId, address indexed caller);

  /// @notice Burns a Hidden Scroll
  /// @param tokenId The Token ID to burn
  function burn(uint256 tokenId) external onlyMintAuthority {
      _burn(tokenId);

      emit HiddenScrollBurned(tokenId, msg.sender);
  }
}
