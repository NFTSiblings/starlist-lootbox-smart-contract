// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AdminPrivileges.sol";

/**
* @notice THIS PRODUCT IS IN BETA, SIBLING LABS IS NOT RESPONSIBLE FOR ANY LOST FUNDS OR
* UNINTENDED CONSEQUENCES CAUSED BY THE USE OF THIS PRODUCT IN ANY FORM.
*/

/**
 * @dev Contract module which facilitates a private sale period
 * prior to a public sale.
 *
 * Inheriting from `PrivSalePeriod` will make the {onlyDuringPrivSale}
 * & {onlyDuringPublicSale} modifiers available.
 *
 * {onlyDuringPrivSale} restricts a function from being called any
 * time except for the pre-defined private sale period.
 * {onlyDuringPublicSale} restricts a function from being called
 * until the private sale period has concluded.
 * 
 * Provide the number of hours that the private sale should
 * occur for as an argument to the constructor.
 * 
 * Contract admins can run {beginPrivSale} function to begin the
 * private sale period, public sale begins
 * automatically after the end of the private sale period.
 *
 * See more module contracts from Sibling Labs at
 * https://github.com/NFTSiblings/Modules
 */
contract PrivSalePeriod is AdminPrivileges {
    uint public privSaleLength;
    uint public saleTimestamp;

    constructor(uint _privSaleHours) {
        setPrivSaleLengthInHours(_privSaleHours);
    }

    /**
    * @dev Begins private sale period. Public sale
    * automatically begins after private sale period
    * concludes.
    */
    function beginPrivSale() public onlyAdmins {
        saleTimestamp = block.timestamp;
    }

    /**
    * @dev Updates private sale length. Length
    * argument must provide a whole number of
    * hours.
    */
    function setPrivSaleLengthInHours(uint256 length) public onlyAdmins {
        privSaleLength = length * 3600;
    }

    /**
    * @dev Returns whether the private sale phase is
    * currently active.
     */
    function isPrivSaleActive() public view returns (bool) {
        return saleTimestamp != 0 && block.timestamp < saleTimestamp + privSaleLength;
    }

    /**
    * @dev Returns whether the public sale is currently
    * active.
     */
    function isPublicSaleActive() public view returns (bool) {
        return saleTimestamp != 0 && block.timestamp >= saleTimestamp + privSaleLength;
    }

    /**
    * @dev Restricts functions from being called except for during
    * the private sale.
    */
    modifier onlyDuringPrivSale() {
        require(
            isPrivSaleActive(),
            "PrivSalePeriod: This function may only be run during the private sale."
        );
        _;
    }

    /**
    * @dev Restricts a function from being called except after the
    * private sale has ended.
    */
    modifier onlyDuringPublicSale() {
        require(
            isPublicSaleActive(),
            "PrivSalePeriod: This function may only be run after the private sale is over."
        );
        _;
    }
}