pragma solidity ^0.4.24;
contract Auction{
    address public addr_auctioneer;
    uint256 payment;
    uint256 public q;   //large prime
    uint256 public n_bid_items;
    uint256 public item_index;
    uint256 public t;    //for testing
    
    struct bidder{
        uint256 n_items;
        uint256 u_w;
        uint256 v_w;
        uint index;
        uint256[2][] items;
    }
    struct notary{
        address addr_notary;
        uint256 flag;
        
    }
    
    mapping(address => bidder) public bidders;
    mapping(uint256 => address) public assigned_notary;  //notary assigned to bidder
    mapping(uint256 => uint256) public bid_items;      //items for auction
    mapping(uint256 => notary) public notaries;
    
    //constructor
    function Auction(uint256 prime, uint256 n)
    {
        addr_auctioneer=msg.sender;
        payment=0;
        q=prime;
        n_bid_items=n;
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
    }
    //functions that registers notary
    function register_notary(uint256 id)
    {
        notaries[id].addr_notary=msg.sender;
        notaries[id].flag=0;
    }
    //function that registers bidder
    function register_bidder(uint256 u_w,uint256 v_w,uint n_items)
    {
        bidders[msg.sender].u_w=u_w;
        bidders[msg.sender].v_w=v_w;
        bidders[msg.sender].n_items=n_items;
        bidders[msg.sender].index=0;
        //randomly assign a notary to a bidder
        uint256 r;
        do
        {
            r=uint256(keccak256(block.timestamp, block.difficulty))%q;
        }while(notaries[r].flag==1);
        assigned_notary[r]=msg.sender;
        notaries[r].flag=1;
    }
    //function to add items that the bidder wants to bid on 
    function addItem(uint256 u,uint256 v)
    {
        if(bidders[msg.sender].index<bidders[msg.sender].n_items)
        {
            bidders[msg.sender].items.push([u,v]);
            bidders[msg.sender].index++;
        }
        
    }
    //sorting
//   function sort()
//     {
       
//         quickSort(data, 0, data.length - 1);
//     }
    // function quickSort(uint[] storage arr, uint left, uint right) internal 
    // {
    //     uint i = left;
    //     uint j = right;
    //     uint pivot = arr[left + (right - left) / 2];
    //     while (i <= j) {
    //         while (arr[i] < pivot) i++;
    //         while (pivot < arr[j]) j--;
    //         if (i <= j) {
    //             (arr[i], arr[j]) = (arr[j], arr[i]);
    //             i++;
    //             j--;
    //         }
    //     }
    //     if (left < j)
    //         quickSort(arr, left, j);
    //     if (i < right)
    //         quickSort(arr, i, right);
    // }

    //only for testing purpose
    function test() 
    {
       t=bidders[msg.sender].items[1][bidders[msg.sender].index-1];
    }
}
