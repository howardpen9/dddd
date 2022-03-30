// SPDX-License-Identifier: MIT
// pragma solidity ^0.8.4;
pragma solidity >=0.8.10;

import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import "./interfaces/IMembershipPass.sol";

import "lib/openzeppelin-contracts/contracts/token/common/ERC2981.sol";

contract MembershipPass is IMembershipPass, Ownable {
    using SafeMath for uint256;

    // Tier capacity is zero-indexed
    uint256[] public tierCapacity;

    mapping(uint256 => uint256) internal supplyByTier;

    // Royalty fee
    uint256[] public tierFee;

    // Contract-level metadata for OpenSea see https://docs.opensea.io/docs/contract-level-metadata
    string public override contractURI;
    address public override feeCollector;

    /** @notice 
    @param _uri  eqwew
    @param _contractURI dddd
    @param _feeCollector dddd
    */
    constructor(
        string memory _uri,
        string memory _contractURI,
        address _feeCollector,
        uint256[] memory _tierFee,
        uint256[] memory _tierCapacity
    ) ERC1155(_uri) {
        require(_tierFee.length > 0, "MembershipPassBooth::Tier not set");

        for (uint256 i = 0; i < _tierFee.length; i++) {
            if (_tierCapacity[i] == 0)
                revert("MembershipPassBooth: Tier capacity at least 1");
            if (_tierFee[i] > 10)
                revert("MembershipPassBooth: Tier fee less that 10%");
        }

        feeCollector = _feeCollector;
        tierFee = _tierFee;
        tierCapacity = _tierCapacity;
        contractURI = _contractURI;
    }

    // /**
    //     @notice
    //     Implement ERC2981, LooksRare

    //     @dev
    //     ddd

    //     @param _tokenId The 
    //     @param _salePrice The initial 

    //     @return feeCollector the address get fee .
    //  */
    function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
        external
        view
        // override
        returns (address receiver, uint256 royaltyAmount)
    {
        return (feeCollector, _salePrice.mul(tierFee[_tokenId]).div(100));
    }

    function getRemainingAmount(uint256 _tier)
        public
        view
        returns (uint256 _remainingAmount)
    {
        _remainingAmount = tierCapacity[_tier] - supplyByTier[_tier];
    }

    /************************* STATE MODIFYING FUNCTIONS *************************/

    /** 
    @notice
    mint ERC1155 MembershipPass, check openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol
    */
    function mintPassForMember(
        address _account,
        uint256 _tier,
        uint256 _amount
    ) external override onlyOwner {
        require(
            _tier < tierCapacity.length,
            "MembershipPassBooth::mintPassForMember: Tier not exist"
        );
        require(
            _amount <= getRemainingAmount(_tier),
            "MembershipPass::mintPassForMember: Insufficient balance"
        );

        supplyByTier[_tier] = supplyByTier[_tier].add(_amount);

        ERC1155._mint(_account, _tier, _amount, "");

        emit MintPass(_account, _tier, _amount);
    }

    // Total Mint: at first stage. 
    function batchMintPassForMember(
        address _account,
        uint256[] memory _tiers,
        uint256[] memory _amounts
    ) external override onlyOwner {
        for (uint256 i = 0; i < _tiers.length; i++) {
            if (_tiers[i] > tierCapacity.length)
                revert(
                    "MembershipPassBooth::mintPassForMember: Tier not exist"
                );
            if (_amounts[i] > getRemainingAmount(_tiers[i]))
                revert(
                    "MembershipPassBooth::batchMintPassForMember: Insufficient balance"
                );
            supplyByTier[_tiers[i]] = supplyByTier[_tiers[i]].add(_amounts[i]);
        }
        ERC1155._mintBatch(_account, _tiers, _amounts, "");

        emit BatchMintPass(_account, _tiers, _amounts);
    }

    // Fee Collector should be 
    function updateFeeCollector(address _feeCollector) external onlyOwner {
        feeCollector = _feeCollector;
    }
}
