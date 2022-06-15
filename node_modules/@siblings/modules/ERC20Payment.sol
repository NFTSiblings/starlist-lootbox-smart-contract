// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AdminPrivileges.sol";

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

/**
* @notice THIS PRODUCT IS IN BETA, SIBLING LABS IS NOT RESPONSIBLE FOR ANY LOST FUNDS OR
* UNINTENDED CONSEQUENCES CAUSED BY THE USE OF THIS PRODUCT IN ANY FORM.
*/

/**
* @dev Contract which provides ERC20 Payment functionality.
*
* Use modifier {requireERC20Payment} to require ERC20 payment
* for a function to be run (i.e. mint function).
*
* Alternatively, directly invoke the {pay} function.
*
* Payers must approve their tokens for spending on the ERC20
* contract prior to using any function on this contract which
* transfers ERC20 tokens.
*
* Also included are tools for handling ERC20 tokens:
*
* {ERC20BalanceOf} queries the caller's ERC20 token balance.
*
* {convertDecimals} converts a small number (e.g. price) to
* account for an ERC20 token's decimal places.
*
* See more module contracts from Sibling Labs at
* https://github.com/NFTSiblings/Modules
*/
contract ERC20Payment is AdminPrivileges {
    address public ERC20Address;
    address private payoutAddress;
    uint private ERC20Decimals;

    constructor(address _ERC20Address, address _payoutAddress, uint _ERC20Decimals) {
        updateERC20(_ERC20Address, _payoutAddress, _ERC20Decimals);
    }

    /**
    * @dev Update details of ERC20 token.
    */
    function updateERC20(address _ERC20Address, address _payoutAddress, uint _ERC20Decimals) public onlyAdmins {
        ERC20Address = _ERC20Address;
        payoutAddress = _payoutAddress;
        ERC20Decimals = _ERC20Decimals;
    }

    /**
    * @dev Modifer which requires an ERC20 payment for the function
    * to run successfully. Tokens are transferred to the stored
    * payout address.
    */
    modifier requireERC20Payment(address from, uint amount) {
        require(IERC20(ERC20Address).transferFrom(from, payoutAddress, amount), "ERC20Payment: ERC20 payment failed");
        _;
    }

    /**
    * @dev Pays the given amount of ERC20 tokens from the given
    * address to the payout address.
    */
    function pay(address from, uint amount) internal requireERC20Payment(from, amount) {}

    /**
    * @dev Queries the ERC20 token balance of an address.
    */
    function ERC20BalanceOf(address _addr) internal view returns (uint) {
        return IERC20(ERC20Address).balanceOf(_addr);
    }

    /**
    * @dev This function can be used to multiply an amount (e.g. price
    * in ERC20 tokens) by the number of decimals the ERC20 token uses.
    *
    * e.g. 7 ASH becomes 7000000000000000000 (ASH token has 18
    * decimals).
    */
    function convertDecimals(uint amount) public view returns (uint) {
        return amount * 10 ** ERC20Decimals;
    }
}