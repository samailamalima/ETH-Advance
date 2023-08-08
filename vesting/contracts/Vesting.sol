// SPDX-License-Identifier: MIT
// The SPDX-License-Identifier indicates the license under which the code is released.
// In this case, the MIT License is used.
pragma solidity ^0.8.19;

contract Vesting {
    uint256 public totalSupply;

    // Defines a structure to represent an organization's information.
    struct Organization {
        address organizationAddress;
        string name;
        uint256 tokenAmount;
    }

    // Defines a structure to represent a stakeholder's information.
    struct Stakeholder {
        address stakeholderAddress;
        string stakeholderPosition;
        uint256 vestingPeriod;
        uint256 startTime;
        uint256 tokenAmount;
        uint256 claimedToken;
    }

    // Maps stakeholder addresses to their information.
    mapping(address => Stakeholder) public stakeholders;

    // Maps addresses to a boolean value indicating whether they are whitelisted.
    mapping(address => bool) public whitelistedAddresses;

    // Maps organization addresses to their information.
    mapping(address => Organization) public organizations;

    // Maps addresses to their token balances.
    mapping(address => uint) public balances;

    // Event emitted when a new stakeholder is added.
    event NewStakeholder(uint256 startTime, uint256 vestingPeriod);

    // Event emitted when an address is whitelisted.
    event Whitelisted(uint256 time, address stakeholder);

    // Allows an organization to create a new organization entry.
    function createOrganization(string memory _name, address _organizationAddress, uint256 _token) external {
        organizations[_organizationAddress] = Organization({
            organizationAddress: _organizationAddress,
            name: _name,
            tokenAmount: _token
        });

        totalSupply += _token;
    }

    // Allows an organization to add a new stakeholder with vested tokens.
    function newStakeholder(
        address _stakeholderAddress,
        string memory _position,
        uint256 _vestingPeriod,
        uint256 _token
    ) external {
        require(organizations[msg.sender].organizationAddress == msg.sender, "Unauthorized");
        require(organizations[msg.sender].tokenAmount >= _token, "Cannot be greater than token");

        stakeholders[_stakeholderAddress] = Stakeholder({
            stakeholderAddress: _stakeholderAddress,
            stakeholderPosition: _position,
            vestingPeriod: _vestingPeriod,
            startTime: block.timestamp,
            tokenAmount: _token,
            claimedToken: 0
        });

        emit NewStakeholder(block.timestamp, _vestingPeriod);
    }

    // Allows an organization to whitelist a stakeholder's address.
    function whitelistAddress(address _stakeholder) external {
        require(organizations[msg.sender].organizationAddress == msg.sender, "You're not the organization owner");
        whitelistedAddresses[_stakeholder] = true;

        emit Whitelisted(block.timestamp, _stakeholder);
    }

    // Allows a whitelisted stakeholder to claim their vested tokens.
    function claimToken() external {
        require(whitelistedAddresses[msg.sender], "You're not whitelisted");
        Stakeholder storage stakeholder = stakeholders[msg.sender];
        require(
            organizations[msg.sender].organizationAddress == msg.sender ||
            stakeholder.stakeholderAddress == msg.sender, "Not in organization"
        );
        require(block.timestamp >= stakeholder.startTime + stakeholder.vestingPeriod, "Vesting period is over");

        uint256 claimableTokens = stakeholder.tokenAmount - stakeholder.claimedToken;
        require(claimableTokens > 0, "Insufficient funds");

        stakeholder.claimedToken += claimableTokens;
        balances[stakeholder.stakeholderAddress] = claimableTokens;
    }

    // Retrieves the claimed token balance for the caller's address.
    function getClaimedToken() external view returns (uint256){
        return balances[msg.sender];
    }

    // Retrieves a stakeholder's position information by providing their address.
    function getStakeholderPosition(address _address) external view returns (Stakeholder memory){
        return stakeholders[_address];
    }
}
