pragma experimental ABIEncoderV2;
pragma solidity ^0.4.24;
contract Auction{
    address public addr_auctioneer;
    uint256 payment;
    int256 public q;   //large prime
    uint256 public n_bid_items;
    uint256 public item_index;
    int256 public t;    //for testing
    int256 public count_notary;
    int256 public count_bidder;
    bool public auction_open;
    
    struct bidder{
        address addr_bidder;
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
    
    mapping(int256 => bidder) public bidders;
    mapping(int256 => int256) public assigned_notary;  //notary assigned to bidder
    mapping(uint256 => uint256) public bid_items;      //items for auction
    mapping(int256 => notary) public notaries;
    
    //constructor
    function Auction(int256 prime, uint256 n)
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
        for(int i=0;i<count_bidder;i++)
        {
            if(bidders[i].addr_bidder==msg.sender)
                return;
        }
        bidders[count_bidder].u_w=u_w;
        bidders[count_bidder].v_w=v_w;
        bidders[count_bidder].n_items=n_items;
        bidders[count_bidder].index=0;
        count_bidder++;
        //yet to confirm
        if(count_notary>=count_bidder)
        {
            int256 r;
            do{
                r= int(block.blockhash(block.number-1))%count_notary + 1;
            }while(notaries[r].flag==1);
          assigned_notary[r]=count_bidder-1;
          notaries[r].flag=1;
        }
       
    }
    function getBidderId(address addr) public returns (int256 id)
    {
        for(int i=0;i<count_bidder;i++)
        {
            if(bidders[i].addr_bidder==addr)
                return i;
        }
        return -1;
    }
    //function to add items that the bidder wants to bid on 
    function addItem(int256 u,int256 v)
    {
        if(auction_open)
        {
            int256 id=getBidderId(msg.sender);
            if(id!=-1)
            {
                if(bidders[id].index<bidders[id].n_items)
                {
                    bidders[id].items.push([u,v]);
                    bidders[id].index++;
                }
            }
        }
        
    }
     function comparison1(int256 x, int256 y) public returns(int256 val1)
    {
       int256 u1 = bidders[assigned_notary[x]].u_w;
       int256 u2 = bidders[assigned_notary[y]].u_w;
       return u1-u2;
    }
    
    function comparison2(int256 x, int256 y) public returns(int256 val2)
    {
       int256 v1 = bidders[assigned_notary[x]].v_w;
       int256 v2 = bidders[assigned_notary[y]].v_w;
       return v1-v2;
    }
    
    //procedure1 by auctioneer
    function isLarger(int256 x, int256 y) public returns(bool result)
    {
        int256 val1=comparison1(x,y);
        int256 val2=comparison2(x,y);
        notaries[x].pay++;
        notaries[y].pay++;
        if(val1+val2==0||(val1+val2)<(q/2))return true;
        return false;
    }
    
    //only for testing purpose
    function test() 
    {
      // t=bidders[msg.sender].items[1][bidders[msg.sender].index-1];
    }
}
