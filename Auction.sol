pragma solidity ^0.4.24;
contract Auction{
    address public addr_auctioneer;
    uint256 payment;
    int256 public q;   //large prime
    uint256 public n_bid_items;
    uint256 public item_index;
    int256 public count_notary;
    int256 public count_bidder;
    int256 public count_winner;
    int256 public next_notary;
    bool public auction_open;
    int256 public x;
    
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
        int256 pay;
    }
    mapping(int256 => int256) public winners;
    mapping(int256 => bidder) public bidders;
    mapping(int256 => int256) public assigned_notary;  //notary-bidder assignment
    mapping(uint256 => uint256) public bid_items;      //items for auction
    mapping(int256 => notary) public notaries;
    mapping(int256 => int256) public sorted_bids;
    
    /*************************************************************************************************/
    
    //constructor
    function Auction(int256 prime, uint256 n)
    {
        addr_auctioneer=msg.sender;
        payment=0;
        q=prime;
        n_bid_items=n;
        auction_open=false;
        count_bidder = 0;
        count_notary=0;
        count_winner=0;
        next_notary=0;
    }
    //function to register notary
     function register_notary()
    {
        notaries[count_notary].addr_notary=msg.sender;
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
        bidders[count_bidder].addr_bidder=msg.sender;
        bidders[count_bidder].u_w=u_w;
        bidders[count_bidder].v_w=v_w;
        bidders[count_bidder].n_items=n_items;
        bidders[count_bidder].index=0;
        //assign notary to this bidder
        if(count_notary>=count_bidder&&next_notary<count_notary)
        {
          assigned_notary[next_notary]=count_bidder;
          next_notary++;
          count_bidder++;
        }
       
    }
    //adding items to the main item list which are open for auction. 
    //Also making a check so that the current index does not exceed the total item count. 
    function add_auction_items(uint256 item_id)
    {
           if(item_index<n_bid_items)
            {
                bid_items[item_index]=item_id;
                item_index=item_index+1;
            }
            if(item_index==n_bid_items)
            {
                auction_open = true;
            }
        
    }
    //functions that registers notary
   
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
    function add_bid_items(int256 u,int256 v)
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
    
    //procedure1 called by auctioneer
    //parameters: notary id1,notary id2,value u1,value u2,value v1,value v2
    function isEqual(int256 id1,int256 id2,int256 u1,int256 u2,int256 v1,int256 v2) public returns(int256 result) 
    {
        notaries[id1].pay++;
        notaries[id2].pay++;
        int256 val1=u1-u2;
        int256 val2=v1-v2;
        if(val1+val2==0)return 0;
        else if(val1+val2<(q/2))return 1;
        return 2;
        
    }
    //
    function isLarger(int256 x, int256 y) public returns(int256 result)
    {
        int256 u1=bidders[assigned_notary[x]].u_w;
        int256 v1=bidders[assigned_notary[x]].v_w;
        int256 u2=bidders[assigned_notary[y]].u_w;
        int256 v2=bidders[assigned_notary[y]].v_w;
        return isEqual(x,y,u1,u2,v1,v2);
    }
    function sort()
    {
        for(int256 k=0;k<next_notary;k++)
        {
            sorted_bids[k]=k;
        }
        for(int256 i=0;i<next_notary-1;i++)
        {
            int256 max=i;
            for(int256 j=i+1;j<next_notary;j++)
            {
                 if(isLarger(sorted_bids[max],sorted_bids[j]) == 2)
                    max=j;
            }
             (sorted_bids[i],sorted_bids[max])=(sorted_bids[max],sorted_bids[i]);
        }
        if(count_bidder>0)
        {
            winners[0] = sorted_bids[0];
            count_winner++;
        }
    }
    //parameters: notray id1,notary id2
    function unique_items(int256 id1,int256 id2) public returns(bool result)
    {
        int256 flag = 0;
        for(uint256 i = 0; i <bidders[assigned_notary[id1]].n_items; i++)//for every item of bidder1
        {
            int256 u1=bidders[assigned_notary[id1]].items[i][0];
            int256 v1=bidders[assigned_notary[id1]].items[i][1];
            for(uint256 j=0;j<bidders[id2].n_items;j++)//for every item of bidder2
            {
                int256 u2=bidders[assigned_notary[id2]].items[j][0];
                int256 v2=bidders[assigned_notary[id2]].items[j][1];
                if(isEqual(id1,id2,u1,u2,v1,v2)==0)
                {
                    flag=1;
                    break;
                }
                
            }
            if(flag==1)
                return false;
        }
        return true;
    }
    //parameters: notary id
    function compare_bidders(int256 id) public returns(bool result)
    {
        for(int i=0;i<count_winner;i++)
        {
            if(!unique_items(id,winners[i]))
                return false;
        }
        return true;
    }
    function announce_winners()
    {
        for(int i=1;i<next_notary;i++)
        {
            if(compare_bidders(sorted_bids[i]))
            {
                winners[count_winner]=i;
                count_winner++;
            }
        }
    }
    
    //only for testing purpose
    function test(int256 id) 
    {
       
    }
}
