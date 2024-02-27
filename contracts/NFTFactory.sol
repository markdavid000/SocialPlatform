// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTFactory is ERC721URIStorage {
    uint256 private tokenIdCounter;
    constructor(string memory _tokenName, string memory _tokenSymbol) ERC721(_tokenName, _tokenSymbol){}

    function createNFT(string memory _tokenURI) external {
        uint256 tokenId = tokenIdCounter++;
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenURI);
    }

    function getTokenURI(uint256 _tokenId) external view returns(string memory) {
        return tokenURI(_tokenId);
    }
}