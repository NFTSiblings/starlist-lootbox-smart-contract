// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@siblings/modules/AdminPrivileges.sol";

/**
* @notice THIS PRODUCT IS IN BETA, SIBLING LABS IS NOT RESPONSIBLE FOR ANY LOST FUNDS OR
* UNINTENDED CONSEQUENCES CAUSED BY THE USE OF THIS PRODUCT IN ANY FORM.
*/

/**
 * @dev Contract module which provides functionality
 * for an open edition NFT sale.
 *
 * Provide the sale length in hours to the
 * constructor.
 *
 * Use {beginSale} to begin the sale. The sale
 * period will automatically elapse and conclude.
 *
 * Use {isSaleActive} to check whether the sale
 * is active.
 * 
 * Use the {onlyDuringSale} modifier to restrict
 * a function from being called except during
 * the sale period.
 *
 * See more module contracts from Sibling Labs at
 * https://github.com/NFTSiblings/Modules
 */
contract OpenEdition is AdminPrivileges {
    uint256 public saleLength;
    uint256 public saleTimestamp;

    constructor(uint256 _saleLengthInHours) {
        setSaleLengthInHours(_saleLengthInHours);
    }

    /**
     * @dev Begin the sale. The sale period
     * will automatically elapse and conclude. 
     */
    function beginSale() public onlyAdmins {
        saleTimestamp = block.timestamp;
    }

    /**
     * @dev Set the sale length in seconds.
     */
    function setSaleLength(uint256 length) public onlyAdmins {
        saleLength = length;
    }

    /**
     * @dev Set the sale length in hours.
     */
    function setSaleLengthInHours(uint256 length) public onlyAdmins {
        saleLength = length * 3600;
    }

    /**
     * @dev Check whether the sale is currently
     * active.
     */
    function isSaleActive() public view returns (bool) {
        return saleTimestamp != 0 && block.timestamp < saleTimestamp + saleLength;
    }

    /**
     * @dev Use this modifier to restrict a
     * function from being run except for
     * during the sale period.
     */
    modifier onlyDuringSale() {
        require(isSaleActive(), "Sale is not available now");
        _;
    }
}