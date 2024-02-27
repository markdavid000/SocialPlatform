// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "./NFT.sol";

contract NFTFactory {
    NFT[] nftClones;

    function createNFTInstance(string memory _tokenName, string memory _tokenSymbol) external returns (NFT newNft_) {
        newNft_ = new NFT(_tokenName, _tokenSymbol);
        nftClones.push(newNft_);
    }

    function getcreateNFTInstance() external view returns (NFT[] memory) {
        return nftClones;
    }
}