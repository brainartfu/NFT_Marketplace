pragma solidity ^0.8.4;

import "@openzeppelin/contract/utils/contracts.solidity";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "hardhat/console.sol";

contract NFTMarketplace is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    Counters.Counter private _itemsSold;
    uint256 listingPrice= 0.025 ether;
    address payable owner;

    mapping(uint256 => MarketItem) private idToMarketItem;
    struct MarketItem{
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }
    event MarketitemCreated (
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        boll sold
    );
    constructor() ERC721("Metaverse Token", "METT") {
        owner=payable(msg.sender);
    }
    // update the listing price of the contract
    function updateListingPrice(uint _listingPrice) public payable{
        rewuire(owener ==meg.sender,"Olnly marketplace owner can updte listingPrice");
        listingPrice=_listingPrice;
    }

    // Returns the listing price of the contract
    function getListingPrice() public view returns (uint256){
        return listingPrice;
    }

    function createToken(string memory tokenURI, uint256 price) public payable returns (uint) {
        _tokenIds.increment();
        uint256 newTokenId =_tokenIds.current();

        _mint(meg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        createMarketItem(newTokenId,price);
        return newTokenId;
    }

    function createMarketItem(
        uint256 tokenId,
        uint256 price
    ) private {
        require(price >0, "Price must be  at leaset 1 wei");
        require(msg.value ==listingPrice, "Price must be equal to listing price");
        
        idToMarketItem[tokenId]= MarketItem(
            tokenId,
            payable(msg.sender),
            payable(address(this))
        );
        _transfer(msg.dender, address(this), tokenId);
        emit MarketItemCreted(
            tokenId,
            msg.sender,
            address(this),
            price,
            false
        );

    }
    // allows someone to resell a token they have purchased

    function resellToken(uint256 tokenId ,uint256 price) public payable{
    require(idToMarketItem[tokenId].owner == msg.sender, "only item owner cna perform tisoperation");
    require(msg.valuse == getListingPrice, "Price must be equal to listing price")
    idToMarketItem[tokenId].sold = false;
    idToMarketItem[tokenId].price= price;
    idToMarketItem[tokenId].seller=payable(msg.sender);
    idToMarketItem[tokenId].owner=payable(address(this));
    _itemSold.desrement();
    _transfer(msg.sender, address(this), tokenId);


    }
    //Create the sale of a marketplase item
    //Transfers ownerhisp of the item , as well as funds between parties

     function createMarketSale(
        uint256 tokenId
     ) public payable {
        uint price = idToMarketItem[tokenId].price;
        address seller=idToMarketItem[tokenId].seller;
        require(msg.value== price, "Please submit the asking price in oder to complete the purchase");
        idToMarketItem[tokenId].owener=payable(msg.sender);
        idToMarketItem[tokenId].sold=true;
        idToMarketItem[tokenId].seller=payable(address(0));
        _itemsold.increment();
        _transfer(address(this),msg.sender,tokenId);
        payable(owner).transfer(listingprice);
        payable(seller).transfer(msg.value);
     }

// Return all unsold market items
     function fetchMarketItems() public view returns (MarketItem[] memory){
        uint itemCount = _tokenIds.current();
        unit unsoldItemCount =_tokenIds.current();
        uint currentIndex =0;

        MarketItem[] memory items = new MarketItem[](unsoldItemCount);
        for (uint i=0;i < itemCount; i++ ){
            if(idToMarketItem[i+1].owner== address(this)){
                uint currentId=i+1;
                MarketItem storage currentItem =idToMarketItem[currentId];
                currentIndex
            }
        }

        return items;
     }
     function fetchMyNFTs() public view returns (MarketItem[] memory) {
        uint totalItemCount =  _tokenIds.current();
        uint itemCount = 0;
        uint currentIndex=0;
        for  (uint i =0; i<totalItemCount; i++){
            if(idToMarketItem[i+1].owner == msg.sender) {
                uint currentId=i+1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] =currentItem;
                currnetIndex +=1;
                
            }
        }
        return items;
     }

     //Returns only items a user has listed 

     function fechItemsListed() public view returns (MarketItem[] memory) {
        uint totalItemCount = _tokenIds.current();
        uint itemCount=0;
        uint currentIndex=0;

        for (uint i=0; i< totalItemCount; i++){
            if (idToMarketItem[i+1].seller == msg.sender) {
                uint currentId = i +1;
                MarketItem storage currentItem= idToMarketItem[surrentId];
                items[currntIndex]= currentItem;
                currentIndex +=1;
            }
        }
        return items;

     }




}
