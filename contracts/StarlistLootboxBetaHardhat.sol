// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@siblings/modules/AdminPrivileges.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

interface IERC721 {
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
}

interface IERC1155 {
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external;
}

contract StarlistLootboxBetaHardhat is AdminPrivileges {
    address private LOSTPOETS_PAGES = 0xc256f2Cd270f9296C4f6c42A07639e581a5A23E7; // should be constant on deployment
    address private LOSTPOETS = 0x0E1d3a11a9684B907212b51dC4A06d4F793329dA; // should be constant on deployment
    address private VAULT = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148; // should be constant on deployment

    mapping(address => uint8) public claimed;
    bytes32 private merkleRootOne;
    bytes32 private merkleRootTwo;
    uint16[] private poetTokenIDs = [3011, 3009, 3008]; // Double check these IDs before deployment

    // constructor unnecessary on deployment to mainnet,
    // all addresses will be hardcoded
    constructor(address pages, address poets, address vault) {
        LOSTPOETS_PAGES = pages;
        LOSTPOETS = poets;
        VAULT = vault;
    }

    function setMerkleRoots(bytes32 rootOne, bytes32 rootTwo) public onlyAdmins {
        merkleRootOne = rootOne;
        merkleRootTwo = rootTwo;
    }

    function claim(bytes32[] calldata _merkleProof) public {
        require(claimed[msg.sender] == 0, "This wallet has already claimed");
        claimed[msg.sender]++;

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        if (MerkleProof.verify(_merkleProof, merkleRootOne, leaf)) {
            IERC1155(LOSTPOETS_PAGES).safeTransferFrom(VAULT, msg.sender, 1, 1, "");
        } else {
            require(MerkleProof.verify(_merkleProof, merkleRootTwo, leaf), "Invalid Merkle proof");

            uint16 id = poetTokenIDs[poetTokenIDs.length - 1];
            poetTokenIDs.pop();

            IERC721(LOSTPOETS).safeTransferFrom(VAULT, msg.sender, id);
        }
    }
}