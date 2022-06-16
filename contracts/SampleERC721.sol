// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyToken721 is ERC721 {
    constructor() ERC721("MyToken", "MTK") {
        _safeMint(msg.sender, 3011);
        _safeMint(msg.sender, 3009);
        _safeMint(msg.sender, 3008);
    }
}