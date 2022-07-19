const { inputToConfig } = require("@ethereum-waffle/compiler");
const { expect } = require("chai");
const { ethers } = require("hardhat");

/**
 * This test script has been written for the beta version of the
 * Starlist Lootbox smart contract. For testing purposes, we
 * will only mint 5 pages and 5 poets.
 * 
 * In this test script, the odd numbered addresses from the list of
 * signers returned by hardhat are eligible to redeem pages, and
 * the even numbered addresses are eligible to redeem poets.
 *
 * There are more than 5 addresses on the latter list but that
 * does not matter for testing purposes.
 */

beforeEach(async function () {
    [owner, addr1, addr2, addr3] = await ethers.getSigners();

    contract = await ethers.getContractFactory("MyToken721");
    // This ERC721 contract automatically mints 5 tokens to the deploying wallet
    MyToken721 = await contract.deploy();
    
    contract = await ethers.getContractFactory("MyToken1155");
    // This ERC1155 contract automatically mints 5 tokens to the deploying wallet
    MyToken1155 = await contract.deploy();

    contract = await ethers.getContractFactory("StarlistLootboxBetaHardhat");
    StarlistLootbox = await contract.deploy(MyToken1155.address, MyToken721.address, owner.address);

    // Set Merkle roots
    await StarlistLootbox.setMerkleRoots(
        "0x877fe7274418177acaa0699f32f89694321a25b17f7304db1c013d60570020d7",
        "0x21d221c85435a38e43ed164e11b98be3f57bb2819a7cea8534f5a21f751fbc21"
    )

    // Grant approvals to StarlistLootbox contract to transfer prize NFTs
    await MyToken721.approve(StarlistLootbox.address, 3011);
    await MyToken721.approve(StarlistLootbox.address, 3009);
    await MyToken721.approve(StarlistLootbox.address, 3008);
    await MyToken1155.setApprovalForAll(StarlistLootbox.address, true);

    // An uninitialised bytes32 value
    bytesZero = "0x0000000000000000000000000000000000000000000000000000000000000000";
    // A Merkle root generated from all hardhat signers
    altMerkleRoot = "0xd38a533706a576a634c618407eb607df606d62179156c0bed7ab6c2088b01de9";

    merkleProofAddr1 = [
        '0x1ebaa930b8e9130423c183bf38b0564b0103180b7dad301013b18e59880541ae',
        '0xf24a4dcb4a3ee2c54bf215cfe6be755201e573ad8f6a778851425006cbc9915d',
        '0x12df2a23b0889255874e67c32642bb04ec44a48dccb81381e16a73900a719081',
        '0x11c302f4e7d66f5a729f48fab3b5ff0f46269cfb2ec323bf3f18de489b7b5559'
    ];

    merkleProofAddr2 = [
        '0xe9707d0e6171f728f7473c24cc0432a9b07eaaf1efed6a137a4a8c12c79552d9',
        '0x86e4758919e8a5ac58f2df266df38c6563731b20b0259c60638f1582b1aeb22b',
        '0x3f933fac88b328d711a101bcd6e0f93686e681b6bb78d2ed044185c29f87719e',
        '0x6bdebc196b5d4fd6effd732bbb12f6c9a9dc322c1a138e5fb98cc7500741e89f'
    ];

    merkleProofAddr3 = [
        '0x00314e565e0574cb412563df634608d76f5c59d9f817e85966100ec1d48005c0',
        '0xf24a4dcb4a3ee2c54bf215cfe6be755201e573ad8f6a778851425006cbc9915d',
        '0x12df2a23b0889255874e67c32642bb04ec44a48dccb81381e16a73900a719081',
        '0x11c302f4e7d66f5a729f48fab3b5ff0f46269cfb2ec323bf3f18de489b7b5559'
    ]

    altMerkleProof = [
        '0xe9707d0e6171f728f7473c24cc0432a9b07eaaf1efed6a137a4a8c12c79552d9',
        '0x7e0eefeb2d8740528b8f598997a219669f0842302d3c573e9bb7262be3387e63',
        '0x90a5fdc765808e5a2e0d816f52f09820c5f167703ce08d078eb87e2c194c5525',
        '0x5a34698734dde87d16cbecce5d1c793eed47d6456e40489b991d8fb9e370a92d',
        '0x6d6cbee8dcc53afd0fe8468716e17f2c38de5112a301ca32c586f1daa063b47d'
    ]
});

describe("Uninitialised merkle root", function () {
    it("No wallets can mint if the merkle root variables are uninitialised", async function () {
        // This is equivalent to leaving the merkle roots unintialised
        await StarlistLootbox.setMerkleRoots(bytesZero, bytesZero);

        await expect(StarlistLootbox.connect(addr1).claim([]))
        .to.be.revertedWith("Invalid Merkle proof");

        await expect(StarlistLootbox.connect(addr1).claim([bytesZero]))
        .to.be.revertedWith("Invalid Merkle proof");

        await expect(StarlistLootbox.connect(addr1).claim(merkleProofAddr1))
        .to.be.revertedWith("Invalid Merkle proof");

        await expect(StarlistLootbox.connect(addr2).claim(merkleProofAddr2))
        .to.be.revertedWith("Invalid Merkle proof");
    });
});

describe("Setting merkle roots", function () {
    it("Only admins may set merkle roots", async function () {

        await expect(StarlistLootbox.connect(addr1).setMerkleRoots(altMerkleRoot, altMerkleRoot))
        .to.be.revertedWith("AdminPrivileges: caller is not an admin");

        await StarlistLootbox.setMerkleRoots(altMerkleRoot, altMerkleRoot);

    });
});

describe("Claiming prizes", function () {
    it("Cannot claim with invalid merkle proof", async function () {

        await expect(StarlistLootbox.connect(addr1).claim(merkleProofAddr2))
        .to.be.revertedWith("Invalid Merkle proof");

        await expect(StarlistLootbox.connect(addr2).claim(merkleProofAddr1))
        .to.be.revertedWith("Invalid Merkle proof");

        await expect(StarlistLootbox.connect(addr1).claim([]))
        .to.be.revertedWith("Invalid Merkle proof");

    });

    describe("Claiming pages", function () {
        it("Winner can claim a page", async function () {

            await StarlistLootbox.connect(addr2).claim(merkleProofAddr2);
            expect(await MyToken1155.balanceOf(addr2.address, 1)).to.equal(1);
            expect(await MyToken1155.balanceOf(owner.address, 1)).to.equal(4);
    
        });

        it("Winner can claim page after Merkle root has been updated", async function () {

            await StarlistLootbox.setMerkleRoots(altMerkleRoot, bytesZero);
            await StarlistLootbox.connect(addr1).claim(altMerkleProof);
            expect(await MyToken1155.balanceOf(addr1.address, 1)).to.equal(1);
            expect(await MyToken1155.balanceOf(owner.address, 1)).to.equal(4);

        });

        it("Winner cannot claim more than once", async function () {

            await StarlistLootbox.connect(addr2).claim(merkleProofAddr2);
            await expect(StarlistLootbox.connect(addr2).claim(merkleProofAddr2))
            .to.be.revertedWith("This wallet has already claimed");

        });
    });

    describe("Claiming poets", function () {
        it("Winner can claim a poet", async function () {

            await StarlistLootbox.connect(addr1).claim(merkleProofAddr1);
            expect(await MyToken721.balanceOf(addr1.address)).to.equal(1);
            expect(await MyToken721.ownerOf(3008)).to.equal(addr1.address);
            expect(await MyToken721.balanceOf(owner.address)).to.equal(2);
    
        });

        it("Winner can claim poet after Merkle root has been updated", async function () {

            await StarlistLootbox.setMerkleRoots(bytesZero, altMerkleRoot);
            await StarlistLootbox.connect(addr1).claim(altMerkleProof);
            expect(await MyToken721.balanceOf(addr1.address)).to.equal(1);
            expect(await MyToken721.ownerOf(3008)).to.equal(addr1.address);
            expect(await MyToken721.balanceOf(owner.address)).to.equal(2);

        });

        it("Winner cannot claim more than once", async function () {

            expect(await StarlistLootbox.claimed(addr1.address)).to.equal(0);

            await StarlistLootbox.connect(addr1).claim(merkleProofAddr1);
            await expect(StarlistLootbox.connect(addr1).claim(merkleProofAddr1))
            .to.be.revertedWith("This wallet has already claimed");

        });

        it("Multiple poets can be claimed", async function () {

            await StarlistLootbox.connect(addr1).claim(merkleProofAddr1);
            await StarlistLootbox.connect(addr3).claim(merkleProofAddr3);

        });
    });
});