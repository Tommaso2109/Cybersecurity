// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.22;

import "Lottery.sol";

contract Taxpayer {

 uint age; 

 bool isMarried; 

 bool iscontract;

 /* Reference to spouse if person is married, address(0) otherwise */
 address spouse; 


address  parent1; 
address  parent2; 

 /* Constant default income tax allowance */
 uint constant  DEFAULT_ALLOWANCE = 5000;

 /* Constant income tax allowance for Older Taxpayers over 65 */
  uint constant ALLOWANCE_OAP = 7000;

 /* Income tax allowance */
 uint tax_allowance; 

 uint income; 

uint256 rev;


//Parents are taxpayers
 constructor(address p1, address p2) {
   age = 0;
   isMarried = false;
   parent1 = p1;
   parent2 = p2;
   spouse = address(0);
   income = 0;
   tax_allowance = DEFAULT_ALLOWANCE;
   iscontract = true;
 } 


 //We require new_spouse != address(0);
 function marry(address new_spouse) public {
  require(new_spouse != address(0), "invalid spouse");
  require(new_spouse != address(this), "cannot marry self");
  // if already married to the same spouse, nothing to do
  if (spouse == new_spouse && isMarried) return;

  spouse = new_spouse;
  isMarried = true;

  // enforce symmetry
  Taxpayer sp = Taxpayer(new_spouse);
  if (sp.getSpouse() != address(this)) {
    sp.marry(address(this));
  }
  }

 
 function divorce() public {
    address old = spouse;
    spouse = address(0);
    isMarried = false;

    if (old != address(0)) {
        Taxpayer sp = Taxpayer(old);
      if (sp.getSpouse() == address(this)) {
            sp.divorce();
        }
    }
  }


 /* Transfer part of tax allowance to own spouse */
 function transferAllowance(uint change) public {
  tax_allowance = tax_allowance - change;
  Taxpayer sp = Taxpayer(address(spouse));
  sp.setTaxAllowance(sp.getTaxAllowance()+change);
 }

 function haveBirthday() public {
  age++;
 }
 
  function setTaxAllowance(uint ta) public {
    require(Taxpayer(msg.sender).isContract() || Lottery(msg.sender).isContract());
    tax_allowance = ta;
  }
  function getTaxAllowance() public view returns(uint) {
    return tax_allowance;
  }
  function isContract() public view returns(bool){
    return iscontract;
  }

  function joinLottery(address lot, uint256 r) public {
    Lottery l = Lottery(lot);
    l.commit(keccak256(abi.encode(r)));
    rev = r;
  }
   function revealLottery(address lot, uint256 r) public {
    Lottery l = Lottery(lot);
    l.reveal(r);
    rev = 0;
  }

  function getSpouse() public view returns(address) {
    return spouse;
  }

  function getIsMarried() public view returns(bool) {
      return isMarried;
  }

  function getAge() public view returns(uint) {
      return age;
  }


  function echidna_marriage_is_symmetric() public view returns (bool) {
      if (spouse == address(0)) return true;
      if (spouse.code.length == 0) return true; // evita EOA
      
      Taxpayer sp = Taxpayer(spouse);
      return sp.getSpouse() == address(this);
  }


  function echidna_no_self_marriage() public view returns (bool) {
    return spouse != address(this);
  }


  function echidna_marriage_flag_consistent() public view returns (bool) {
    if (spouse == address(0)) return isMarried == false;
    return isMarried == true;
  }




}
