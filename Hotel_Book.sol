// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract HotelRoom {

    address owner;
    enum Status {Vacant, Occupied}
    Status public currentStatus;
    // Status public currentStatus = Status.Vacant;

    event Occupy(address book, uint cost);

    constructor () {
        owner = msg.sender;
        currentStatus = Status.Vacant;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "You are not the owner.");
        _;
    }

    modifier onlyWhileVacant() {
        require(currentStatus == Status.Vacant, "The room is not vacant.");
        _;
    }

    modifier costs(uint _amount) {
        require(_amount <= msg.value, "10 ether!");
        _;
    }

    function book() public payable costs(10 ether) onlyWhileVacant {
        currentStatus = Status.Occupied; // 사용 중인 상태로 바꾸고
        payable(owner).transfer(msg.value); // 집주인한테 돈 보내주기

        emit Occupy(msg.sender, msg.value);
    }

    function reset() public onlyOwner {
        require(currentStatus == Status.Occupied, "the room is already vacant.");
        currentStatus = Status.Vacant;
    }
}