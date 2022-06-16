// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyToken721 is ERC721 {
    constructor() ERC721("MyToken", "MTK") {
        for (uint8 i = 0; i < 5; i++) {
            _safeMint(msg.sender, i);
        }
    }
}