// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;
// function _requireERC721(address _tokenAddress) internal view returns (IERC721)
// {
//     require(_tokenAddress.isContract(),"The NFT Address should be a contract");
//     require(IERC721(_tokenAddress).supportsInterface(_INTERFACE_ID_ERC721),"The NFT contract has an invalid ERC721 implementation");
//     return IERC721(_tokenAddress);
// }

library Address {

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }
}
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }
  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused public {
    paused = false;
    emit Unpause();
  }
}
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

contract NFTMarketplace is Pausable  {
    using Address for address;
    bytes4 public constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    IERC721 public nftToken;
    IERC20 public auraToken;

    uint [] public auctionnID;
    uint [] public orderrID;

   
    constructor(address _nftAddress,address _auraAddress)  Ownable() {
        nftToken=IERC721(_nftAddress);
        auraToken=IERC20(_auraAddress);
    }
    
    function setPaused(bool _setPaused) public onlyOwner {
        return (_setPaused) ? pause() : unpause();
    }
    
 //...........................................................................................................................................................................    
    struct Order {
        bytes32 orderId;
        address payable seller; //seller address
        uint256 ethPrice;
        uint256 auraPrice;
    }

    struct AuctionData {
        bytes32 auctionId;
        address payable seller;
        uint256 minBid;         // Selling Price
        uint expiryTime;
    } 

    struct BidData{
       bytes32 bidId;
       uint bidCounter;
       uint newBid;
       uint auctionEndTime;
       address highestBidder;
       uint256 highestBid;
    }

     //offer  
    struct OfferAURA{
        uint256[] amount;
        uint256[] expiry;
        address[] buyerAddress;
    }

    struct OfferWETH{
        uint256[] amount;
        uint256[] expiry;
        address[] buyerAddress;
    }

     
    // ORDER EVENTS
    event OrderCreated(bytes32 orderId,address indexed seller,uint256 indexed tokenId,uint256 ethPrice,uint256 auraPrice);
    event AuctionCreated(bytes32 orderId,address indexed seller,uint256 indexed tokenId,uint256 minBid,uint256 expiryTime);
    event OrderUpdated(bytes32 orderId,uint256 ethPrice,uint256 auraPricw);
    event OrderSuccessfull(bytes32 orderId,address indexed buyer);
    event OrderCancelled(bytes32 id);
    event LogBid(address bidder, uint highestBid, address highestBidder);
    event OfferMade(address Buyer,uint256 Time,uint256 Amount);

    mapping(uint256 => Order) public orderByTokenId;  
    mapping(uint256 => AuctionData) public auctionByTokenId; 
    mapping(uint256 => BidData) public bidByTokenId;
    mapping(uint256 => OfferAURA) offerByBuyerAURA;  //offer
    mapping(uint256 => OfferWETH) offerByBuyerWETH;  //offer
    
    mapping(address => mapping(uint => bool)) public nested;
    mapping(address => uint256) public fundsByBidder;
    

 //...........................................................................................................................................................................    
    
    //create order
    function createOrder(uint256 _tokenId, uint256 _ethPrice, uint _auraPrice) public whenNotPaused
    {
        _createOrder(_tokenId,  _ethPrice, _auraPrice);
    }

    function _createOrder(uint256 _tokenId, uint256 _ethPrice,uint _auraPrice) internal
    {
        // Check order creator is the asset owner
        address tokenOwner = nftToken.ownerOf(_tokenId);
        require(tokenOwner == msg.sender,"Marketplace: Only the asset owner can create orders");
        require(_ethPrice > 0, "not enough funds send");
        require(_auraPrice > 0, "not enough funds send");
        nftToken.safeTransferFrom(tokenOwner,address(this), _tokenId);
        
        // create the orderId
        bytes32 _orderId = keccak256(abi.encodePacked(_tokenId, _ethPrice, _auraPrice));
        orderByTokenId[_tokenId] = Order({
            orderId: _orderId,
            seller: payable(msg.sender),
            ethPrice: _ethPrice,
            auraPrice: _auraPrice
        });
        orderrID.push(_tokenId);
        emit OrderCreated(_orderId,msg.sender,_tokenId,_ethPrice,_auraPrice);
    }
    
    function createAuctionByEth(uint256 _tokenId, uint256 _minBid,uint _expiryTime) public whenNotPaused
    {
        _createAuction(_tokenId,  _minBid, _expiryTime);
    }

    function createAuctionByAura(uint256 _tokenId, uint256 _minBid,uint _expiryTime) public whenNotPaused
    {
        _createAuction(_tokenId,  _minBid, _expiryTime);
    }

    function _createAuction(uint256 _tokenId, uint256 _minBid, uint _expiryTime) internal
    {
        // Check order creator is the asset owner
        address tokenOwner = nftToken.ownerOf(_tokenId);
        require(tokenOwner == msg.sender,"Marketplace: Only the asset owner can create orders");
        require(_minBid > 0, "not enough funds send");
        nftToken.safeTransferFrom(tokenOwner,address(this), _tokenId);
        
        // create the orderId
        bytes32 _auctionId = keccak256(abi.encodePacked(_tokenId,_minBid,_expiryTime));
        auctionByTokenId[_tokenId] = AuctionData({
            auctionId: _auctionId,
            seller: payable(msg.sender),
            minBid: _minBid,
            expiryTime: _expiryTime
        });

            bidByTokenId[_tokenId] = BidData({
            bidId:_auctionId,
            bidCounter:0,
            newBid:0,
            auctionEndTime:block.timestamp +_expiryTime,
            highestBidder:0x0000000000000000000000000000000000000000,
            highestBid:0
        });
        auctionnID.push(_tokenId);
        emit AuctionCreated(_auctionId, msg.sender, _tokenId, _minBid, _expiryTime);
    }

 //...........................................................................................................................................................................    
    
    //Cancel order
    function cancelOrder(uint256 _tokenId) public whenNotPaused
    {
        Order memory order = orderByTokenId[_tokenId];
        require(order.seller == msg.sender || msg.sender == owner(), "Marketplace: unauthorized sender");
        _cancelOrder(order.orderId,_tokenId,  msg.sender);
    }

    function _cancelOrder(bytes32 _orderId,uint256 _tokenId, address _seller) internal
    {
        delete orderByTokenId[_tokenId];
        nftToken.safeTransferFrom(address(this), _seller, _tokenId);   
        emit OrderCancelled(_orderId);
    }

 //...........................................................................................................................................................................    

    //Update Order
    function updateOrder( uint256 _tokenId, uint256 _ethPrice, uint256 _auraPrice) public whenNotPaused
    {    Order memory order = orderByTokenId[_tokenId];
        require(order.orderId != 0, "Markeplace: Order not yet published");
        require(order.seller == msg.sender, "Markeplace: sender is not allowed");
        require(order.ethPrice > 0, "Marketplace: Price should be bigger than 0");
        require(order.auraPrice > 0, "Marketplace: Price should be bigger than 0");        
        order.ethPrice = _ethPrice;
        order.auraPrice=_auraPrice;
        emit OrderUpdated(order.orderId, _ethPrice,_auraPrice);
    }

 //...........................................................................................................................................................................    

    //Return total number of id being listed for sale on a market place.
    function getOrderTokenIds(address _owner)public view returns(uint orderId)
    {
        uint countt=0;
        Order memory order ;
        for (uint256 index = 0; index < orderrID.length; index++)
        {
        uint aa=orderrID[index];
        order = orderByTokenId[aa];
        if(order.seller==_owner)
        {   countt+=1;   }

        }
        return countt;
    }

    //Return total number of id being listed for Auction on a market place.
    function getAuctionTokenIds(address _owner)public view returns(uint auctionId)
    {
        uint countt=0;
        AuctionData memory auctionData;
        for (uint256 index = 0; index < auctionnID.length; index++)
        {
        uint aa=auctionnID[index];
        auctionData = auctionByTokenId[aa];
        if(auctionData.seller==_owner)
        {   countt+=1;   }
        
        }
        return countt;
    }

 //...........................................................................................................................................................................    


    //Buy with ETH
    function safeExecuteOrderByEth( uint256 _tokenId) public whenNotPaused payable
    {
        Order memory order = _getValidOrder( _tokenId);
        require(order.ethPrice == msg.value, "Marketplace: invalid price");
        require(order.seller != msg.sender, "Marketplace: unauthorized sender");
        _executeOrder(order.orderId, msg.sender,   _tokenId);
        payable(order.seller).transfer(msg.value);
         for(uint i = _tokenId; i < orderrID.length-1; i++)
         {
               orderrID[i] = orderrID[i+1];      
         }
        orderrID.pop();
    }

    //Buy with $AURA
    function safeExecuteOrderByAura( uint256 _tokenId) public whenNotPaused
    { 
        Order memory order = _getValidOrder( _tokenId);
        require(order.auraPrice <= auraToken.balanceOf(msg.sender), "Marketplace: invalid price");
        require(order.seller != msg.sender, "Marketplace: unauthorized sender");
        _executeOrder(order.orderId, msg.sender,   _tokenId);
        auraToken.transferFrom(msg.sender,order.seller,order.auraPrice);
        for(uint i = _tokenId; i < orderrID.length-1; i++)
        {
              orderrID[i] = orderrID[i+1];      
        }
        orderrID.pop();
    }
    
    function _executeOrder(bytes32 _orderId, address _buyer, uint256 _tokenId) internal
    {   
        delete orderByTokenId[_tokenId];   
        nftToken.safeTransferFrom(address(this), _buyer, _tokenId);  
        emit OrderSuccessfull(_orderId, _buyer);
    }
        
    function _getValidOrder( uint256 _tokenId) internal view returns (Order memory order)
    {
        order = orderByTokenId[_tokenId];
        require(order.orderId != 0, "Marketplace: asset not published");
    }


 //...........................................................................................................................................................................        

    //Returns       1)Auction ID           2)Order ID     3)Total NFT owned by the address
    function tokensOfOwner(address _owner)public view returns (uint[]memory OrderId, uint[]memory AuctionId, uint[]memory TokensOfOwner)
    {
        uint256 count = nftToken.balanceOf(_owner);
        AuctionData memory auctionData;
        Order memory order ;
        uint256[] memory resultTokensOfOwner = new uint256[](count);
        uint256[] memory resultOrder=new uint256[](getOrderTokenIds(_owner));
        uint256[] memory resultAuction=new uint256[](getAuctionTokenIds(_owner));
        uint orderIndex=0;  
        uint auctionIndex=0;
        
        for (uint256 index = 0; index < auctionnID.length; index++) {
            uint aa=auctionnID[index];
           auctionData=auctionByTokenId[aa];
            if(auctionData.seller==_owner)
            {
               
                resultAuction[auctionIndex]=auctionnID[index];
                auctionIndex++;
                
            }
        }

        for (uint256 index = 0; index < orderrID.length; index++) {
            uint aa=orderrID[index];
            order = orderByTokenId[aa];
            if(order.seller==_owner)
            {
               
                resultOrder[orderIndex]=orderrID[index];
               orderIndex++;
            }
        }

        for (uint256 index = 0; index < count; index++) {
            resultTokensOfOwner[index] = nftToken.tokenOfOwnerByIndex(_owner, index);
        }
        return (resultOrder,resultAuction,resultTokensOfOwner);
    }

 //...........................................................................................................................................................................        

    //Get the Highest Bid on the Token ID
    function getHighestBid(uint _tokenId) public view returns(uint)
    {
        BidData memory bidData = _getValidBid( _tokenId);
        return fundsByBidder[bidData.highestBidder];
    }

 //...........................................................................................................................................................................    


    function _getValidAuction( uint256 _tokenId) internal view returns (AuctionData memory auctionData)
    {
        auctionData = auctionByTokenId[_tokenId];
        require(auctionData.auctionId != 0, "Marketplace: asset not published");
    }

    function _getValidBid( uint256 _tokenId) internal view returns (BidData memory bidData)
    {
        bidData = bidByTokenId[_tokenId];
        require(bidData.bidId != 0, "Marketplace: asset not published");
    }       
    
    function placeBidAura(uint _tokenId,uint _bid) public
    {
        AuctionData memory auctionData = _getValidAuction( _tokenId);
        BidData memory bidData = _getValidBid( _tokenId);
        require(auraToken.balanceOf(msg.sender) >= auctionData.minBid, "error");
        require(block.timestamp <= bidData.auctionEndTime, "auction canceled");
        require(auraToken.balanceOf(msg.sender) > fundsByBidder[bidData.highestBidder], "error");
        if (bidData.bidCounter != 0)
        {
            auraToken.transferFrom(address(this),bidData.highestBidder,bidData.highestBid);
        }
        fundsByBidder[msg.sender] = _bid;

        bidByTokenId[_tokenId] = BidData({
            bidId:auctionData.auctionId,
            bidCounter:bidData.bidCounter+1,
            newBid:_bid,
            auctionEndTime:bidData.auctionEndTime,
            highestBidder:msg.sender,
            highestBid:_bid
        });
        auraToken.transferFrom(msg.sender,address(this),_bid);
        emit LogBid(msg.sender, bidData.highestBid, bidData.highestBidder);
        // return true;
    }

    function placeBidEth(uint _tokenId) public payable
    {
        AuctionData memory auctionData = _getValidAuction( _tokenId);
        BidData memory bidData = _getValidBid( _tokenId);
        require(msg.value >= auctionData.minBid, "error");
        require(block.timestamp <= bidData.auctionEndTime, "auction canceled");
        require(msg.value > fundsByBidder[bidData.highestBidder], "error");
        if (bidData.bidCounter != 0)
        {
            (bool success, ) = bidData.highestBidder.call{value: bidData.highestBid}("");
            require(success, "Failed to send Ether");
        }
        fundsByBidder[msg.sender] = msg.value;

        bidByTokenId[_tokenId] = BidData({
            bidId:auctionData.auctionId,
            bidCounter:bidData.bidCounter+1,
            newBid:msg.value,
            auctionEndTime:bidData.auctionEndTime,
            highestBidder:msg.sender,
            highestBid:msg.value
        });
        emit LogBid(msg.sender, bidData.highestBid, bidData.highestBidder);
        // return true;
    }

    function acceptBid( uint256 _tokenId) public
    {
        AuctionData memory auctionData = _getValidAuction( _tokenId);
        require(auctionData.seller==msg.sender,"user is not owner");
        BidData memory bidData = _getValidBid( _tokenId);
        require(block.timestamp > bidData.auctionEndTime,"Auction is not ended");
        nftToken.safeTransferFrom(address(this), bidData.highestBidder, _tokenId);
        payable(auctionData.seller).transfer(bidData.highestBid);
        delete auctionByTokenId[_tokenId];
        for(uint i = _tokenId; i < auctionnID.length-1; i++)
        {
        auctionnID[i] = auctionnID[i+1];      
        }
        auctionnID.pop();
    }   
 //...........................................................................................................................................................................    
    
    //Make Offer by $AURA & $WETH
    function makeOfferAURA(uint256 _amount,uint256 _tokenID,uint256 _time,address _seller) public {
        require(nftToken.balanceOf(_seller)==_tokenID,"The Token ID doesn't exist");

        offerByBuyerAURA[_tokenID].amount.push(_amount); 
        offerByBuyerAURA[_tokenID].expiry.push(_time);
        offerByBuyerAURA[_tokenID].buyerAddress.push(msg.sender); 
        emit OfferMade(msg.sender, _time , _amount);

    }
    function makeOfferWETH(uint256 _amount,uint256 _tokenID,uint256 _time,address _seller) public {
         require(nftToken.balanceOf(_seller)==_tokenID,"The Token ID doesn't exist");
        offerByBuyerWETH[_tokenID].amount.push(_amount);
        offerByBuyerWETH[_tokenID].expiry.push(_time);
        offerByBuyerWETH[_tokenID].buyerAddress.push(msg.sender);
        emit OfferMade(msg.sender, _time , _amount);
        
    }

    function DisplayOfferOnID(uint256 _tokenID) public view returns(OfferAURA memory AURA, OfferWETH memory WETH){
        return (offerByBuyerAURA[_tokenID],offerByBuyerWETH[_tokenID]);
    }

    function acceptOffer(uint256 _tokenId,address _buyer) public {
        Order memory _orderData=orderByTokenId[_tokenId];
        AuctionData memory _auctionData=auctionByTokenId[_tokenId];
        require(nftToken.ownerOf(_tokenId)==msg.sender ||_orderData.seller==msg.sender|| _auctionData.seller==msg.sender );
        uint256 index;
        for(uint256 i=0; i<= offerByBuyerAURA[_tokenId].amount.length;i++)
        {
            if(_buyer == offerByBuyerAURA[_tokenId].buyerAddress[i])
            {
                index=i;
            }
        }
       require(offerByBuyerAURA[_tokenId].amount[index]> 0,"The offer does not exist");
       require(auraToken.balanceOf(offerByBuyerAURA[_tokenId].buyerAddress[index]) >= offerByBuyerAURA[_tokenId].amount[index], "The buyer doesn't have enough amount to proceed on");
       auraToken.transferFrom(offerByBuyerAURA[_tokenId].buyerAddress[index], msg.sender, offerByBuyerAURA[_tokenId].amount[0]);
       nftToken.transferFrom(msg.sender,_buyer,_tokenId);
    }
}
