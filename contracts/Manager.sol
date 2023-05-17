//SPDX-License-Identifier: MIT  
pragma solidity ^0.8.0;

contract Manager {

    struct Ticket {
        uint8 status;  // 0 - TODO; 1 - Busy; 2 - Done;
        string name;  // The name of the person who created this ticket
    }

    Ticket[] public tickets;  // list all ticket's

    // Create a new ticket and add it to the list.
    function createTicket(string memory _name) external {
        tickets.push(Ticket(0, _name));  // The first parameter is the status of the ticket(TODO)
    }

    // Then there are two functions where we update the name of the person who created the ticket and the status of the ticket. 
    // To do this, we access the list(tickets) by id.
    function updateTicketName(uint _index, string memory _name) external {
        tickets[_index].name = _name;
    }

    function updateTicketStatus(uint _index, uint8 _status) external {
        tickets[_index].status = _status;
    }
    
    // Here, we get the entire list of tickets
    function getTickets() external view returns(Ticket[] memory) {
        return tickets;
    }

}