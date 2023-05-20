const { expect } = require("chai"); // Chai is a BDD / TDD assertion library for node and the browser that can be delightfully paired with any javascript testing framework.
const { ethers } = require("hardhat");

describe("NuttzToken", function () {
  
  before(async function () {
    NuttzToken = await ethers.getContractFactory("NuttzToken");
    Contract = await NuttzToken.deploy();
    await Contract.deployed();
  });
  

  it("Should ....", async function () {
   
    expect(x).to.equal(y);
  });


});