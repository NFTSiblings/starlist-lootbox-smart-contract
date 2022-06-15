// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AdminPrivileges.sol";

interface BurnInterface {
    function burn(uint256 tokenId) external;
}

/**
* @notice THIS PRODUCT IS IN BETA, SIBLING LABS IS NOT RESPONSIBLE FOR ANY LOST FUNDS OR
* UNINTENDED CONSEQUENCES CAUSED BY THE USE OF THIS PRODUCT IN ANY FORM.
*/

/**
* @dev Contract for burning tokens from an external collection.
*
* Token owners must approve your contract as an operator for
* their tokens before your contract will be able to burn them.
*
* This contract is compatible with contracts which utilise the
* ERC721Burnable extension. Alternatively, this contract will
* work with contracts which expose a {burn} function with the
* correct input params.
*
* Tokens which are to be burned are referred to in this
* contract as kindling.
*
* See more module contracts from Sibling Labs at
* https://github.com/NFTSiblings/Modules
*/
contract BurnExternal is AdminPrivileges {
    address public kindlingContractAddress;

    constructor(address _kindlingContractAddress) {
        updateKindlingContract(_kindlingContractAddress);
    }

    /**
    * @dev Update contract address of tokens to be burned.
    */
    function updateKindlingContract(address _kindlingContractAddress) public onlyAdmins {
        kindlingContractAddress = _kindlingContractAddress;
    }

    /**
    * @dev Call this function to burn tokens from another
    * collection.
    */
    function burnKindlingTokens(uint256[] calldata tokenIds) internal {
        for (uint i; i < tokenIds.length; i++) {
            BurnInterface(kindlingContractAddress).burn(tokenIds[i]);
        }
    }
}