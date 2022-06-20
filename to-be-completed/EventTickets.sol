// SPDX-License-Identifier: UNLICENCED
pragma solidity ^0.8.0;

contract EventTicket{
    address payable public owner;

    uint TICKET_PRICE = 100 wei;

    struct Event{
        string description;
        string website;
        uint256 totalTickets;
        uint sales;
        mapping (address => uint) buyers;
        bool isOpen;
    }

    Event myEvent;

    event LogBuyTickets(address purchaser,uint ticket);
    event LogGetRefund(address requester,uint ticket);
    event LogEndSale(address owner,uint256 totalAmount);

    modifier checkOwner{
        require(msg.sender == owner,'Function caller must be a owner');
        _;
    }
    modifier checkValue(uint ticketP){
        _;
        uint256 totalPrice = ticketP * TICKET_PRICE;
        uint256 amountToRefund = msg.value - totalPrice;
        payable(msg.sender).transfer(amountToRefund);
    }

    constructor(string memory _description,string memory _website,uint256 _totalTickets){
        owner = payable(msg.sender);
        myEvent.description = _description;
        myEvent.website = _website;
        myEvent.totalTickets = _totalTickets;
        myEvent.isOpen = true;
        myEvent.sales = 0;
    }
    

    function readEvent() public view returns(
        string memory description, 
        string memory website,
        uint totalTickets,
        uint sales,
        bool isOpen
    ){
       return(
           myEvent.description,
           myEvent.website,
           myEvent.totalTickets,
           myEvent.sales,
           myEvent.isOpen
       );
    }

    function getBuyerTicketCount(address buyer) public view returns(uint256 ticketBought){
        return myEvent.buyers[buyer];
    }

    function buyTickets(uint ticketP) external payable{
        require(myEvent.isOpen == true);
        uint totalPrice = ticketP * TICKET_PRICE;
        require(msg.value > totalPrice);
        uint remainingTicket = myEvent.totalTickets - myEvent.sales;
        require(remainingTicket > ticketP);

        myEvent.totalTickets = myEvent.totalTickets - ticketP;
        myEvent.buyers[msg.sender] = ticketP;
        myEvent.sales = myEvent.sales + ticketP;
        payable(msg.sender).transfer(msg.value - totalPrice);
        emit LogBuyTickets(msg.sender,ticketP);
    }

    function getRefund(uint ticketToRefund) public {
        require(myEvent.buyers[msg.sender] != 0 && myEvent.buyers[msg.sender] >= ticketToRefund);
        
        uint amountToRefund = ticketToRefund * TICKET_PRICE;
        payable(msg.sender).transfer(amountToRefund);
        myEvent.sales = myEvent.sales - ticketToRefund;
        emit LogGetRefund(msg.sender, ticketToRefund);
        
    }

    function endSale() public payable{
        require(msg.sender == owner);

        uint totalPrice = myEvent.sales * TICKET_PRICE;
        payable(msg.sender).transfer(totalPrice);
        myEvent.isOpen = false;
        emit LogEndSale(msg.sender,totalPrice);
    }

}
