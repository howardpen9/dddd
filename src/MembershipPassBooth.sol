// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "lib/openzeppelin-contracts/contracts/utils/Address.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "lib/openzeppelin-contracts/contracts/utils/Counters.sol";
import "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155Receiver.sol";

import "./MembershipPass.sol";
import "./interfaces/IMembershipPassBooth.sol";
import "./interfaces/IMembershipPass.sol";
// 

contract MembershipPassBooth is IMembershipPassBooth, Ownable {
    mapping(uint256 => IMembershipPass) public override membershipPassOf;

    constructor() {
    }


    /**
        @notice 
        Issued an owner's ERC1155 membershipPass that'll be used when 

        @dev 
        Deploys an owner's ERC1155 token contract.

        @param _projectId The ID of the proejct being isssued membershipPass
        @param _uri The ERC1155 URI
     */

    function issue(
        uint256 _projectId,
        string memory _uri,
        string memory _contractURI,
        address _feeCollector,
        uint256[] memory _tierFee,
        uint256[] memory _tierCapacity
    ) 
        external 
        override 
    {
        require(membershipPassOf[_projectId] == IMembershipPass(address(0)), 
            "MembershipPassBooth::issue: ALREADY_ISSUED."
        );
        
        MembershipPass membershipPass = new MembershipPass(
              _uri
            , _contractURI
            , _feeCollector
            , _tierFee
            , _tierCapacity
        );

        membershipPassOf[_projectId] = membershipPass;

        // emit Issue(_projectId, _uri, _contractURI, _feeCollector, _tierFee , _tierCapacity, msg.sender);
    }


}