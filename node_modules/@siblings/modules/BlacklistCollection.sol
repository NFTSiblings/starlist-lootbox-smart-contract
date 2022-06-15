// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    function balanceOf(address owner) external view returns (uint256 balance);
}

interface IERC1155 {
    function balanceOf(address account, uint256 id) external view returns (uint256);
}

/**
* @notice THIS PRODUCT IS IN BETA, SIBLING LABS IS NOT RESPONSIBLE FOR ANY LOST FUNDS OR
* UNINTENDED CONSEQUENCES CAUSED BY THE USE OF THIS PRODUCT IN ANY FORM.
*/

/**
* @dev This contract exposes modifiers which require the given
* address' balance of tokens from a blacklisted collection to
* be 0. Use these modifiers to prevent a function from being
* run if the caller has tokens from blacklisted collections.
*
* With great power comes great responsibility.
*
* See more module contracts from Sibling Labs at
* https://github.com/NFTSiblings/Modules
*/
contract BlacklistCollection {
    string private errMsg = "BlacklistCollection: caller owns a blacklisted token";

    /**
    * @dev Use this modifier to prevent any wallet which
    * has tokens from the blacklisted collection from
    * running the function.
    *
    * Provide the address of the blacklisted collection
    * and the address of the wallet to check.
    *
    * This modifier is only compatible with ERC721
    * contracts. If the blacklisted contract is of type
    * ERC1155, use modifier {blacklistERC1155} instead.
    */
    modifier blacklistERC721(address collection, address owner) {
        require(IERC721(collection).balanceOf(owner) == 0, errMsg);
        _;
    }

    /**
    * @dev Use this modifier to blacklist multiple
    * ERC721 collections.
    */
    modifier blacklistManyERC721(address[] memory collections, address owner) {
        for (uint i; i < collections.length; i++) {
            require(IERC721(collections[i]).balanceOf(owner) == 0, errMsg);
        }
        _;
    }

    /**
    * @dev Use this modifier to prevent any wallet which
    * has tokens from the blacklisted collection from
    * running the function.
    *
    * Provide the address of the blacklisted collection,
    * the address of a wallet to check, and the ID of
    * the blacklisted token.
    *
    * This modifier is only compatible with ERC1155
    * contracts. If the blacklisted contract is of type
    * ERC721, use modifier {blacklistERC721} instead.
    */
    modifier blacklistERC1155(address collection, address owner, uint256 id) {
        require(IERC1155(collection).balanceOf(owner, id) == 0, errMsg);
        _;
    }

    /**
    * @dev Use this modifier to blacklist multiple
    * tokens from an ERC1155 collection.
    */
    modifier blacklistManyERC1155(address collection, address owner, uint[] memory tokenIds) {
        for (uint i; i < tokenIds.length; i++) {
            require(IERC1155(collection).balanceOf(owner, tokenIds[i]) == 0, errMsg);
        }
        _;
    }
}