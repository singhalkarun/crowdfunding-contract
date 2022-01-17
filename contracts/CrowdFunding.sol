// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.8;

contract CrowdFunding {
    address public fundRaiser;
    uint public totalAmountFunded;
    uint public totalAmountWithdrawn;
    mapping(address => uint256) public donatedAmount;
    mapping(address => uint256) public withdrawnAmount;

    constructor() {
        fundRaiser = msg.sender;
    }

    event fundDonated(
        uint amount,
        address sender
    );

    event fundWithdrawn(
        uint amount,
        address receiver
    );

    function donateFund() external payable {
        require(msg.value != 0, "You need to deposit some amount of money!");
        totalAmountFunded += msg.value;

        donatedAmount[msg.sender] += msg.value;

        emit fundDonated(msg.value, msg.sender);
    }

    function getDonatedFund() public view returns(uint) {
        return donatedAmount[msg.sender];
    }

    function withdrawFunds(address payable _to, uint256 _total) external payable{
        require(
            msg.sender == fundRaiser,
            "You must be the owner to withdraw the funds"
        );    

        require(
            _total <= totalAmountFunded,
            "You have insuffient funds to withdraw"
        );
        _to.transfer(_total);
        totalAmountWithdrawn += _total;

        withdrawnAmount[_to] += _total;

        emit fundWithdrawn(_total, _to);        
        
    }
}