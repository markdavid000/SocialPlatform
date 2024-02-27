// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./NFTFactory.sol";

error ALREADY_REGISTERED();
error ADDRESS_ZERO_DETECTED();
error INSUFFICIENT_FUNDS();
contract SocialPlatform {
    NFTFactory public nftFactoryAddress;
    uint256 private groupIdCounter;
    struct User {
        bool registered;
        string role;
    }

    struct Group {
        string name;
        address[] members;
    }

    struct Comment {
        address user;
        string content;
    }

    mapping(address => User) users;
    mapping(uint256 => Group) groups;
    mapping(uint256 => Comment[]) public nftComments;
    mapping(address => uint256) usersBalance;
    mapping(address => mapping(uint256 => bool)) public moderatedNFTs;

    event UserRegistered(address indexed user, string indexed role);
    event GroupCreated(uint256 indexed groupId, string name, address indexed creator);
    event EtherReceived(address indexed sender, uint256 amount);
    event EtherWithdrawn(address indexed receiver, uint256 amount);
    event ContentModerated(uint256 indexed tokenId, address user);
    event CommentAdded(uint256 indexed tokenId, address indexed commenter, string text);



    modifier onlyAdmin() {
        require(keccak256(abi.encodePacked(users[msg.sender].role)) == keccak256(abi.encodePacked("Admin")), "Only Admin can call this function");
        _;
    }

    modifier onlyAdminOrModerator() {
        require(keccak256(abi.encodePacked(users[msg.sender].role)) == keccak256(abi.encodePacked("Admin")) || keccak256(abi.encodePacked(users[msg.sender].role)) == keccak256(abi.encodePacked("Moderator")), "Only Admin or Moderator can call this function");
        _;
    }

    constructor(address _nftFactoryAddress) {
        nftFactoryAddress = NFTFactory(_nftFactoryAddress);
    }

    function registerUser(string memory _role) external {
        if(users[msg.sender].registered) {
            revert ALREADY_REGISTERED();
        }

        users[msg.sender] = User(true, _role);
        emit UserRegistered(msg.sender, _role);
    }

    function createGroup(string memory _name, address[] memory _members) external onlyAdmin {
        Group memory newGroup = Group({
            name: _name,
            members: _members
        });

        uint256 groupId = groupIdCounter++;

        groups[groupId] = newGroup;

        emit GroupCreated(groupId, _name, msg.sender);
    }

    function deposit() external payable {
        if(msg.sender == address(0)){
            revert ADDRESS_ZERO_DETECTED();
        }

        usersBalance[msg.sender] += msg.value;

        emit EtherReceived(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) external {
        if(usersBalance[msg.sender] < _amount) {
            revert INSUFFICIENT_FUNDS();
        }

        usersBalance[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
        
        emit EtherWithdrawn(msg.sender, _amount);
    }

    function moderateContent(uint256 _tokenId) public onlyAdminOrModerator {
        moderatedNFTs[msg.sender][_tokenId] = true;
        emit ContentModerated(_tokenId, msg.sender);
    }

    function viewNFT(uint256 _tokenId) public view returns (string memory) {
        return nftFactoryAddress.getTokenURI(_tokenId);
    }

    function getUserRole(address _user) public view returns (string memory) {
        return users[_user].role;
    }

    function addComment(uint256 _tokenId, string memory _text) public {
        nftComments[_tokenId].push(Comment(msg.sender, _text));
        emit CommentAdded(_tokenId, msg.sender, _text);
    }

    function getComments(uint256 _tokenId) public view returns (Comment[] memory) {
        return nftComments[_tokenId];
    }
}