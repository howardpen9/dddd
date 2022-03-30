//SPDX-License-Identifier: MIT
// pragma solidity ^0.8.4;
pragma solidity >=0.8.10;


import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "./interfaces/IProjects.sol";
import "./abstract/Operatable.sol";
import "./libraries/Operations.sol";
// src/libraries/Operations.sol


contract Projects is ERC721, IProjects, Operatable {
        // uint256 _projectId = projects.create(_owner, _handle, _uri);
    
    // --- public stored properties --- //

    /// @notice A running count of project IDs.
    uint256 public override count = 0;
    
    /// @notice Each project's handle.
    mapping(uint256 => bytes32) public override handleOf;

    /// @notice The project that each unique handle represents.
    mapping(bytes32 => uint256) public override projectFor;

    /// @notice Handles that have been transfered to the specified address.
    mapping(bytes32 => address) public override transferAddressFor;

    /// @notice Optional mapping for project URIs
    mapping(uint256 => string) public override uriOf;


    //////////// --- external views --- ////////////
    /** 
      @notice 
      Whether the specified project exists.

      @param _projectId The project to check the existence of.

      @return A flag indicating if the project exists.
    */
    function exists(uint256 _projectId) external view override returns (bool) {
        return _exists(_projectId);
    }



    constructor(IOperatorStore _operatorStore)
    ERC721("NBHD DAOs", "NEIGHBORHOOD")
    Operatable(_operatorStore)
    {}

    /** @notice
        Create a new DAO.
     */
    function create(
        address _owner,
        bytes32 _handle,
        string calldata _uri
        ) external override returns (uint256) {

        // require(_handle != bytes32(0), "Projects::create: EMPTY_HANDLE");

        // // Increment the count, which will be used as the ID.
        // ++count;

        // _safeMint(_owner, count);
        // handleOf[count] = _handle;
        // projectFor[_handle] = count;

    }



        /**
      @notice 
      Allows a project owner to set the project's handle.

      @dev 
      Only a project's owner or operator can set its handle.

      @param _projectId The ID of the project.
      @param _handle The new unique handle for the project.
    */
    function setHandle(uint256 _projectId, bytes32 _handle)
        external
        override
        requirePermission(ownerOf(_projectId), _projectId, Operations.SetHandle)
    {
        // Handle must exist.
        require(_handle != bytes32(0), "Projects::setHandle: EMPTY_HANDLE");

        // Handle must be unique.
        require(
            projectFor[_handle] == 0 &&
                transferAddressFor[_handle] == address(0),
            "Projects::setHandle: HANDLE_TAKEN"
        );

        // Register the change in the resolver.
        projectFor[handleOf[_projectId]] = 0;

        projectFor[_handle] = _projectId;
        handleOf[_projectId] = _handle;

        emit SetHandle(_projectId, _handle, msg.sender);
    }



        /**
      @notice 
      Allows a project owner to set the project's uri.

      @dev 
      Only a project's owner or operator can set its uri.

      @param _projectId The ID of the project.
      @param _uri An ipfs CDN to more info about the project. Don't include the leading ipfs://
    */
    function setUri(uint256 _projectId, string calldata _uri)
        external
        override
        requirePermission(ownerOf(_projectId), _projectId, Operations.SetUri)
    {
        // Set the new uri.
        uriOf[_projectId] = _uri;

        emit SetUri(_projectId, _uri, msg.sender);
    }
}