// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NUTTZ is ERC20, Ownable {

    address payable Owner;// Owner of the contract
    address StakingContract;// Here I will add Staking contract address
    uint256 TaxPercentage;

    constructor() ERC20("NUTTZ", "NTZ") {
        Owner = payable(msg.sender);
    }

    function SetStakingContractAdd(address _StakingContaract) public onlyOwner{
        StakingContract = _StakingContaract;
    }

    function SetTaxPercentage(uint256 _TaxPercentage) public onlyOwner {
        TaxPercentage  = _TaxPercentage;
    }

    function transfer(address to,uint256 amount) public override returns(bool) {
        address owner = _msgSender();
        require(TaxPercentage >= 0,"Tax Pecentage is not set yet by owner");
        uint256 Taxamount = amount * TaxPercentage/100;
        _transfer(owner, to, amount-Taxamount);
        _transfer(owner, StakingContract, Taxamount);
        return true;
    }

    receive() external payable {}

}
