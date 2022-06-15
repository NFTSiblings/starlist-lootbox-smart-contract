// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@siblings/modules/AdminPrivileges.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

/**
* @notice THIS PRODUCT IS IN BETA, SIBLING LABS IS NOT RESPONSIBLE FOR ANY LOST FUNDS OR
* UNINTENDED CONSEQUENCES CAUSED BY THE USE OF THIS PRODUCT IN ANY FORM.
*/

/**
 * @dev Contract module which provides allowlist functionality
 * using the cryptographic technique called Merkle Proof.
 *
 * Inheriting from `MerkleProofAllowlist` will make the
 * {requireMerkleProof} modifier available - add this modifier
 * to a function in your contract to require that the
 * caller provide a valid merkle proof, and that their
 * address is on the allowlist.
 *
 * Merkle proofs must be provided as a bytes32 array.
 *
 * Provide the Merkle root to the constructor, or update
 * it with the {setMerkleRoot} function.
 *
 * See more module contracts from Sibling Labs at
 * https://github.com/NFTSiblings/Modules
 */
contract MerkleProofAllowlist is AdminPrivileges {
    bytes32 merkleRoot;

    constructor(bytes32 _merkleRoot) {
        merkleRoot = _merkleRoot;
    }

    /**
    * @dev Set Merkle root.
    */
    function setMerkleRoot(bytes32 root) public onlyAdmins {
        merkleRoot = root;
    }

    /**
    * @dev Function which uses the {merkleProof} modifier. Invoke this function
    * if you want a function to conditionally require a valid Merkle proof.
    */
    function requireMerkleProof(bytes32[] calldata _merkleProof) internal merkleProof(_merkleProof) {}

    /**
    * @dev Modifier which requires a valid Merkle proof sent from an address
    * which is a part of the Merkle tree.
    */
    modifier merkleProof(bytes32[] calldata _merkleProof) {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(
            MerkleProof.verify(_merkleProof, merkleRoot, leaf),
            "MerkleProofAllowlist: Invalid Merkle Proof"
        );
        _;
    }
}