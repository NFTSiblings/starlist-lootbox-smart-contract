# Smart-Contract-Modules

A range of smart contract modules available for developers to use under the MIT license.

See all contract modules at https://github.com/NFTSiblings/Modules

NOTICE: THIS PRODUCT IS IN BETA, SIBLING LABS IS NOT RESPONSIBLE FOR ANY LOST FUNDS OR
UNINTENDED CONSEQUENCES CAUSED BY THE USE OF THIS PRODUCT IN ANY FORM.



AdminPause.sol
* Contract which adds pausing functionality. Any function
* which uses the {whenNotPaused} modifier will revert when the
* contract is paused.
*
* Use {togglePause} to switch the paused state.
*
* Contract admins can run any function on a contract regardless
* of whether it is paused.



AdminPrivileges.sol
* Contract module that designates an owner and admins
* for a smart contract.
*
* Inheriting from `AdminPrivileges` will make the
* {onlyAdmins} modifier available, which can be applied to
* functions to restrict all wallets except for the stored
* owner and admin addresses.



Allowlist.sol
* Adds allowlist functionality to a contract.
*
* Allowlist is tracked with a mapping which pairs an
* address to a uint - this provides versatile
* functionality to your base contract.
*
* If your allowlist is binary (e.g. an address is
* either allowed or not), simply check if the
* paired uint for the address is greater than 0.
* Alternatively, track how many allowlist places
* each address is entitled to with the uint.
*
* Use the {requireAllowlist} modifier to prevent
* a function from being run if the caller does
* not have at least 1 allowlist place.



AllowlistSalePeriod.sol
* Contract module which facilitates an allowlist only sale
* period prior to a public sale.
*
* Inheriting from `ALSalePeriod` will make the {onlyDuringALPeriod}
* & {onlyDuringPublicSale} modifiers available.
*
* {onlyDuringALPeriod} restricts a function from being called any
* time except for the pre-defined allowlist sale period.
* {onlyDuringPublicSale} restricts a function from being called
* until the allowlist sale period has concluded.
* 
* Provide the number of hours that the whitelist sale should
* occur for as an argument to the constructor.
* 
* Contract admins can run {beginALSale} function to begin the
* allowlist sale period, public sale period begins
* automatically after the end of the allowlist sale period.



BlacklistCollection.sol
* This contract exposes modifiers which require the given
* address' balance of tokens from a blacklisted collection to
* be 0. Use these modifiers to prevent a function from being
* run if the caller has tokens from blacklisted collections.
*
* With great power comes great responsibility.



BurnExternal_V1.sol
* Contract for burning tokens from an external collection.
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



BurnExternal_V2.sol
* Contract for burning tokens from an external collection.
*
* Token owners must approve your contract as an operator for
* their tokens before your contract will be able to burn them.
*
* This contract is compatible with contracts which utilise the
* ERC721Burnable and ERC1155Burnable extensions. Alternatively,
* this contract will work with contracts which expose a {burn}
* function with the correct input params.
*
* Tokens which are to be burned are referred to in this
* contract as kindling.



ERC20Payment.sol
* Contract which provides ERC20 Payment functionality.
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



RoyaltiesConfig.sol
* Contract which adds support for Rarible and EIP2981 NFT
* royalty standards.
*
* Royalty recipient is set to the contract deployer by default,
* and royalty percentage is set to 10% by default.
* 
* Admins can use the {updateRoyalties} function to change the
* royalties percentage or royalty recipient.
*
* Rarible and LooksRare (LooksRare uses the EIP2981 NFT
* royalty standard) are the only marketplaces which this
* contract module will add support for. We recommend updating
* royalty settings for other marketplaces on their
* respective websites.