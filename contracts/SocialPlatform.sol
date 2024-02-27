// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./NFTFactory.sol";

contract SocialPlatform {
    NFTFactory public nftFactoryAddress;

    struct User {
        bool registered;
        string role;
    }

    struct Group {
        string name;
        address[] members;
    }

    constructor(address _nftFactoryAddress) {
        nftFactoryAddress = NFTFactory(_nftFactoryAddress);
    }
}