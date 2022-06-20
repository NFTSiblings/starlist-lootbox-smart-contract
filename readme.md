## **General** **Description**

This smart contract will facilitate the transfer of Lost Poets NFTs to ‘starlist’ members.

Each wallet on the starlist (50 total) is guaranteed either a page or a poet from the Lost Poets collection. 3 wallets will receive a poet NFT, and the remaining 47 will receive a page NFT.

The wallets which will receive poets will be determined randomly beforehand.

Users will be able to call a claim function on the smart contract to be automatically transferred their prize NFT.

## **Technical Description**

First, a new wallet must be created, and all of the prize NFTs sent to this vault wallet.

Collectors will call a single ‘claim’ function from our smart contract through a front-end interface which will be created to accompany this smart contract.

A merkle tree will be generated from the 3 addresses which have ‘won’ a poet, and another merkle tree will be created from the 47 addresses which are to receive a page.

When a wallet calls the claim function, the function will check whether the calling wallet address is part of either merkle tree, and send the corresponding NFT to the caller by calling the `safeTransferFrom` function on the Lost Poets or Lost Poets Pages contract. The vault wallet will approve our smart contract for transfer of the poets and pages beforehand, so that the transfer can occur instantly. The function will then write to a mapping of addresses to show that the calling wallet has already claimed, and therefore cannot claim again.

## How to use this smart contract

**Before Deployment**

- Create a fresh wallet to store all of the prize NFTs in. This will need to be funded with a small amount of ETH for the approval transactions.
- Smart contract must be updated for mainnet, including:
    - Hardcoding mainnet addresses for Lost Poets and Lost Poets Pages contracts
    - Hardcoding address for the vault wallet
    - Updating the array of IDs for poet NFTs

**After Deployment**

- On the Lost Poets and Lost Poets Pages smart contracts, grant approval to our Lootbox Giveaway smart contract to transfer the poet and page NFTs.
- Claiming will not be available for users until we set the variables `merkleRootOne` and `merkleRootTwo`. This is done by calling the function `setMerkleRoots` on our smart contract.

## Timeline

**Day 0**

- Deploy contract
- Grant token approvals to new contract on Lost Poets and Lost Poets Pages contracts

**Day 7**

- Update Merkle root variables using `setMerkleRoots`

## Potential issues

- The Merkle root could be inputted incorrectly, leading to the claim function not working correctly. This can be resolved by updating the Merkle root variables with `setMerkleRoots`.
- The `poetTokenIDs` array is hardcoded with incorrect IDs. This can only be resolved by deploying a new smart contract.
- The vault wallet is hardcoded incorrectly. This can only be resolved by deploying a new smart contract.
- If a winner’s wallet address is accidentally included in both merkle trees (i.e. eligible to win a page and a poet), they will receive a page when they run the claim function, and won’t receive a poet.
