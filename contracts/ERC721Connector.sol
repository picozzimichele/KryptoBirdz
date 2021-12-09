// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "./ERC721Metadata.sol";

contract ERC721Connector is ERC721Metadata {
    // We deploy connector and want to carry the Metadata over
    
    constructor(string memory name, string memory symbol) ERC721Metadata(name, symbol) {

    }
}