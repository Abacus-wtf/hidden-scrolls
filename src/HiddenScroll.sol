// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

///////////////////////////////////////////////////////////////////
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
///////////////////////////////////////////////////////////////////

/// @title HiddenScroll
/// @author abigger87
/// @dev This contract is a folklore instance deployed by the [FolkloreBook](./FolkloreBook.sol) contract.
/// @dev ASCII Text generated with https://patorjk.com/software/taag/#p=display&f=Delta%20Corps%20Priest%201&t=Scroll
contract HiddenScroll {

  /// @dev The Primary Lore Object
  struct Lore {
    address creator;
    uint256 parentLoreId;
    bool nsfw;
    bool struck;
    string loreMetadataURI;
  }

  /// @dev The current lore id
  uint256 public currentLore;

  /// @dev Mapping lore to 

  bytes32 public immutable SCROLL_NAME;

  constructor(bytes32 _SCROLL_NAME) {
    SCROLL_NAME = _SCROLL_NAME;
  }
}
