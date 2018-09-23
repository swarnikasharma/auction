var Auction = artifacts.require('Auction')
var assert = require('assert')

let contractCall
   contract('Auction',  (accounts) => {
    var n = new Array()
    for(i = 0; i < 15; i++) {
        n[i] = accounts[i];
    }
    for(j = 0; j < 10; j+=2) {
        const x = j;
    it('Check if notary is getting registered', async() => {
        contractCall = await Auction.deployed()     
        var count1 = await contractCall.get_notary()
        await contractCall.register_notary({from: n[x]})
        var count2 = await contractCall.get_notary()
        assert.equal(count2.c[0], count1.c[0] + 1, 'Notary is unregistered')
    })
    it('Check if bidder is getting registered', async() => { 
        contractCall = await Auction.deployed()    
        var count1 = await contractCall.get_bidder()
        await contractCall.register_bidder(2,18,3,{from: n[x+1]})
        var count2 = await contractCall.get_bidder()      
        assert.equal(count2.c[0], count1.c[0] + 1, 'Bidder is unregistered')
    })
    }
    for(m = 0; m < 5; m++) {
        const x = m;
    it('Check if items are being added', async() => {
        contractCall = await Auction.deployed()     
        var count1 = await contractCall.check_add_items_bidder()
        await contractCall.add_bid_items(2, 18, {from: n[x]})
        var count2 = await contractCall.check_add_items_bidder()
        assert.equal(count2.c[0], count1.c[0], 'Item was not added')
    })
    }
    for(k = 0; k < 5; k++) {
        const y = k;
    it('Check if the sorting is successful', async() => {
        contractCall = await Auction.deployed()
        await contractCall.sort({from: n[y]})
        var count1 = await contractCall.get_sort()
        assert.equal(count1.c[0], 1, 'Sorting is unsuccessful')
    })
    }
    for(l = 0; l < 1; l++) {
        const z = l;
    it('Check if the winners are correct', async() => {
        contractCall = await Auction.deployed()
        await contractCall.isEqual(1,2,5,16,8,13,{from: n[z]})
        var count1 = await contractCall.get_winner()
        assert.equal(count1.c[0], 1, 'Winners algorithm is unsuccessful')
    })
    }
    for(a = 0; a < 1; a++) {
        const z = a;
    it('Check if payment is correct', async() => {
        contractCall = await Auction.deployed()
        await contractCall.sqrt(16,{from: n[z]})
        var count1 = await contractCall.get_pay()
        assert.equal(count1.c[0], 0, 'Payment is unsuccessful')
    })
    }
})
