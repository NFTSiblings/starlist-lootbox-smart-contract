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

contract StarlistLootboxBeta is AdminPrivileges {
    address constant private LOSTPOETS_PAGES = 0xc256f2Cd270f9296C4f6c42A07639e581a5A23E7;
    address constant private LOSTPOETS = 0x0E1d3a11a9684B907212b51dC4A06d4F793329dA;
    address constant private VAULT = 0x699a1928EA12D21dd2138F36A3690059bf1253A0;

    mapping(address => uint8) public claimed;
    bytes32 private merkleRootOne;
    bytes32 private merkleRootTwo;
    uint8[] private poetTokenIDs = [0,1,2,3,4]; // IDs in this array must be updated on deployment

    function setMerkleRoots(bytes32 rootOne, bytes32 rootTwo) public onlyAdmins {
        merkleRootOne = rootOne;
        merkleRootTwo = rootTwo;
    }

    function claim(bytes32[] calldata _merkleProof) public {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        bool page = MerkleProof.verify(_merkleProof, merkleRootOne, leaf);
        bool poet = MerkleProof.verify(_merkleProof, merkleRootTwo, leaf);

        require(page || poet, "Invalid Merkle proof");
        require(claimed[msg.sender] == 0, "This wallet has already claimed");

        claimed[msg.sender]++;

        if (page) {
            IERC1155(LOSTPOETS_PAGES).safeTransferFrom(VAULT, msg.sender, 1, 1, "");
        } else if (poet) {
            uint8 id = poetTokenIDs[poetTokenIDs.length - 1];
            poetTokenIDs.pop();

            IERC721(LOSTPOETS).safeTransferFrom(VAULT, msg.sender, id);
        }
    }
}