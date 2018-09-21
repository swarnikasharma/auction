pragma experimental ABIEncoderV2;
pragma solidity ^0.4.24;
contract Auction{
    address public addr_auctioneer;
    uint256 payment;
    uint256 public q;   //large prime
    uint256 public n_bid_items;
    uint256 public item_index;
    int256 public t;    //for testing
    int256 public count_notary;
    bool public auction_open;
    int256 public count_bidder;
    struct bidder{
        uint256 n_items;
        int256 u_w;
        int256 v_w;
        uint index;
        int256[2][] items;
    }
    struct notary{
        address addr_notary;
        uint256 flag;
        int256 pay;
    }
    
    mapping(address => bidder) public bidders;
    mapping(int256 => address) public assigned_notary;  //notary assigned to bidder
    mapping(uint256 => uint256) public bid_items;      //items for auction
    mapping(int256 => notary) public notaries;
    
    //constructor
    function Auction(uint256 prime, uint256 n)
    {
        addr_auctioneer=msg.sender;
        payment=0;
        q=prime;
        n_bid_items=n;
        auction_open=false;
        count_bidder = 0;
        //t=msg.sender;
    }
    //adding items to the main item list which are open for auction. 
    //Also making a check so that the current index does not exceed the total item count. 
    function add_bid_items(uint256 item_id)
    {
           if(item_index<n_bid_items)
            {
                bid_items[item_index]=item_id;
                item_index=item_index+1;
            }
            else
            {
                auction_open = true;
            }
        
    }
    //functions that registers notary
    function register_notary()
    {
        notaries[count_notary].addr_notary=msg.sender;
        notaries[count_notary].flag=0;
        count_notary++;
        
    }
    //function that registers bidder
    function register_bidder(int256 u_w,int256 v_w,uint n_items)
    {
        count_bidder++;
        bidders[msg.sender].u_w=u_w;
        bidders[msg.sender].v_w=v_w;
        bidders[msg.sender].n_items=n_items;
        bidders[msg.sender].index=0;
        //randomly assign a notary to a bidder
        int256 r;
        do
        {
             r = int(block.blockhash(block.number-1))%10 + 1;
            //r=uint64(keccak256(block.timestamp, block.difficulty))%(q);
        }while(notaries[r].flag==1);
        assigned_notary[r]=msg.sender;
        notaries[r].flag=1;
    }
    //function to add items that the bidder wants to bid on 
    function addItem(int256 u,int256 v)
    {
        if(auction_open)
        {
            if(bidders[msg.sender].index<bidders[msg.sender].n_items)
            {
                bidders[msg.sender].items.push([u,v]);
                bidders[msg.sender].index++;
            }
        }
        
    }
    
   
   
    //only for testing purpose
    function test() 
    {
       t=bidders[msg.sender].items[1][bidders[msg.sender].index-1];
    }
}
