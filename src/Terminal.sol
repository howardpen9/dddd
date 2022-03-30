//SPDX-License-Identifier: MIT
pragma solidity >=0.8.10;
import "lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
import "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "lib/openzeppelin-contracts/contracts/utils/Address.sol";
// import "../lib/prb-contracts/contracts/math/PRBMath.sol";
// import "../lib/prb-contracts/contracts/math/PRBMathUD60x18.sol";

import "./interfaces/ITerminal.sol";
import "./interfaces/IMembershipPass.sol";
import "./interfaces/IProjects.sol";
import "./interfaces/IFundingCycles.sol";
import "./interfaces/IMembershipPassBooth.sol";

import "./interfaces/IRoyaltyDistributor.sol";
import "./RoyaltyDistributor.sol";

contract Terminal is  ITerminal, Ownable, ReentrancyGuard {
    uint256 public override contributeFee = 4;

    IProjects public immutable projects;

    IFundingCycles public immutable fundingCycles;

    IMembershipPassBooth public immutable membershipPassBooth;
    /** 
        @param _projects A DAO's contract which mints ERC721 that represent project's ownership and transfers.
        @param _fundingCycles A funding cycle configuration store. (DAO Creator can launch mutiple times.)
        @param _passBooth The tiers with the Membership-pass this DAO has
        @param _owner the Owner of this ERC721, aka. the DAO Creator. 
    */
    constructor(
        IProjects _projects,
        IFundingCycles _fundingCycles,
        IMembershipPassBooth _passBooth,
        address _owner
    ) {
        require(
            _projects != IProjects(address(0)) &&
            _fundingCycles != IFundingCycles(address(0)) &&
            _passBooth != IMembershipPassBooth(address(0)) &&
            _owner != address(0),
            "Terminal: ZERO_ADDRESS"
        );
        projects = _projects;
        fundingCycles = _fundingCycles;
        membershipPassBooth = _passBooth;
        transferOwnership(_owner);
    }

    /**
    @notice Create the DAO's fundraising 
    @param _owner The address who will own the DAO. 
    @param _handle The unique handle name for a DAO  
    @param _uri dddd
    @param _tiers The total tiers of the Membership-pas
     */
    function createDao(
        address _owner,
        bytes32 _handle,
        string memory _uri,
        ImmutablePassTier[] calldata _tiers,
        FundingCycleProperties calldata _properties  //         FundingCycleProperties memory _properties
        // notice: memory or calldata 
    ) external override {
        bool validated = _validateConfigProperties(_tiers, _properties);
        require(validated, "Terminal::createDao: BAD_CONFIG");

        uint256 _projectId = projects.create(_owner, _handle, _uri);

        IRoyaltyDistributor royalty = new RoyaltyDistributor();

        //TODO fix types
        //membershipPassBooth.issue(_projectId, "name", "symbol",  tickets);
    }


    // TODO The wallet address who has specific ERC721 or ERC1155 in wallet 
    // then able to mint the Membership-pass.
    function whitelistMint(address _for) external override {}

    function claimPassOrRefund(uint256 _projectId) external override {}


    /**
     @notice 
     @param _projectId the DAO Project you are contributing to.
     */
    function contribute(
        uint256 _projectId,
        PayInfo[] memory _payData,
        string memory _memo
    ) external override {

    }

    function _validateConfigProperties(
        ImmutablePassTier[] memory _tiers,
        FundingCycleProperties memory _properties
    ) private pure returns (bool) {}
}
