// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@siblings/modules/AdminPrivileges.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

interface IERC721 {}

interface IERC1155 {}

contract StarlistLootboxSkeleton is AdminPrivileges {
    bytes32 public merkleRootOne;
    bytes32 public merkleRootTwo;
    uint8[] private poetTokenIDs;
    mapping(address => uint8) public claimed;

    function setMerkleRoots(bytes32 rootOne, bytes32 rootTwo) public onlyAdmins {}

    function claim(bytes32[] calldata _merkleProof) public {}
}