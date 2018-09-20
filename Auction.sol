pragma solidity ^0.4.24;
contract Auction{
    address public addr_auctioneer;
    int256 payment;
    int256 public q;   //large prime
    int256 public n_bid_items;
    int256 public item_index;
    int256 public t;    //for testing
    
    struct bidder{
        int256 n_items;
        mapping(int256 => int256) set;
        int256 value;
        int256 w;
        int256 index;
    }
    
    mapping(address => bidder) public bidders;
    mapping(int256 => int256) public assigned_notary;  //notary assigned to bidder
    mapping(int256 => int256) public bid_items;      //items for auction
    mapping(int256 => address) public notary;
    
    //constructor
    function Auction(int256 prime, int256 n)
    {
        addr_auctioneer=msg.sender;
        payment=0;
        q=prime;
        n_bid_items=n;
        
    }
    //adding items to the main item list which are open for auction. 
    //Also making a check so that the current index does not exceed the total item count. 
    function add_bid_items(int256 item_id)
    {
        if(item_index<n_bid_items)
        {
            bid_items[item_index]=item_id;
            item_index=item_index+1;
        }
    }
    //functions that registers notary
    function register_notary(int256 id)
    {
        notary[id]=msg.sender;
    }
    //function that registers bidder
    function register_bidder(int256 id,int256 value,int256 n_items)
    {
        
        bidders[msg.sender].value=value;
        bidders[msg.sender].n_items=n_items;
        bidders[msg.sender].w=value=value/n_items;  //computing h value for w according to the formula
        bidders[msg.sender].index=0;
    }
    //function to add items that the bidder wants to bid on 
    function addItem(int256 item_id)
    {
        if(bidders[msg.sender].index<bidders[msg.sender].n_items)
        {
            bidders[msg.sender].set[bidders[msg.sender].index]=item_id;
            bidders[msg.sender].index++;
        }
    }
    //nly for testing purpose
    function test() 
    {
       t = bidders[msg.sender].value;
    }
}