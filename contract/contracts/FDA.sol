//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import '@openzeppelin/contracts/utils/Counters.sol';
import "@openzeppelin/contracts/access/Ownable.sol";

contract FDA is ERC721, Ownable {
    
    // Varibles
    string baseURI;
    string baseExtension = ".json";
    uint256 public maxSupply = 30;
    bool public paused = false;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenSupply;
    Counters.Counter private _mintedTokens;

    // Errors
    error SoldOut();
    error InsufficientFunds();
    error MintLimit();
    error NotOwner();

    // Events
    event Minted(
        address indexed owner,
        string tokenURI,
        uint256 indexed mintTime
    );

    /*
    Token data include: name, symbol and initBaseURI
    */
    constructor(
        string memory name,
        string memory symbol,
        string memory _initBaseURI
    ) ERC721(name, symbol) {
        setBaseUri(_initBaseURI);
    }

    function mint() public {
        // Require not paused
        require(!paused, "paused");
        // Require user only own one
        require(balanceOf(msg.sender) < 1, "Only one per user");
        // Current supply
        uint256 supply = _tokenSupply.current();
        // Require MAX not reached
        require(supply + 1 < maxSupply + 1, "Max supply reached");
        uint256 tokenID = _tokenSupply.current() + 1;
        // Mint token to the requester with last token ID availible
        _safeMint(msg.sender, tokenID);
        // Increase counter by one
        _tokenSupply.increment();
        // Notify new token created
        emit Minted(msg.sender, tokenURI(tokenID), block.timestamp);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721)
        returns (string memory)
    {
        require(_exists(tokenId), "TokenID not exists");
        string memory currentBaseURI = _baseURI();
        return
            string(
                abi.encodePacked(currentBaseURI, Strings.toString(tokenId), baseExtension)
            );
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // Get baseURI
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    /****************************************************/
    /******************** Only Owner ********************/
    /****************************************************/
    // Update base URI
    function setBaseUri(string memory _baseUri) public onlyOwner {
        baseURI = _baseUri;
    }

    // Update base extension
    function setBaseExtension(string memory _baseExtension) external onlyOwner {
        baseExtension = _baseExtension;
    }

    // Update max supply
    function setMaxSupply(uint256 _maxSupply) public onlyOwner {
        maxSupply = _maxSupply;
    }

    // If we set pause to be false then we cannot mint NFT
    function pause(bool _state) external onlyOwner {
        paused = _state;
    }

    function getPause() external view onlyOwner returns (bool) {
        return paused;
    }

    function getNumberOfMintedTokens() external view returns (uint256 data) {
        return _tokenSupply.current();
    }
}