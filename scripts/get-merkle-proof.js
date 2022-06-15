// Use npm to install merkletreejs and keccak256 in
// this directory prior to running this script

const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');

// Reads wallet addresses from public/addresses.json
const allowlistAddresses = require("../addresses/" + process.argv[2] + ".json");

const leafNodes = allowlistAddresses.map(addr => keccak256(addr));
const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true });

console.log(merkleTree.getHexProof(keccak256(process.argv[3])));