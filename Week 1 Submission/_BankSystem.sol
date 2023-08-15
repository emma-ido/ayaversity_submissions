// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

contract BankSystem {
   mapping(address => int) public accounts;

   event Sent(address from, address to, int amount);
   event Withdrawal(int amountWithdrawn, int balance);
   event Deposit(int amount);
   error InsufficientBalance(int requested, int available);

   function getMyAccountAddress() public view returns(address) {
      return msg.sender;
   }

   /**
    * Gets the balance for any account
    */
   function getBalance(address accountAddress) public view returns(int) {
      return accounts[accountAddress];
   }
   
   /**
    * Gets the balance for the callers account
    */
   function getMyBalance() public view returns(int) {
      return accounts[msg.sender];
   }

   function deposit(int amount) public {
      accounts[msg.sender] += amount;
      emit Deposit(amount);
   }

   function withdraw(int amount) public  {
      int currentBalance = accounts[msg.sender];

      if(currentBalance < amount) {
         revert InsufficientBalance(amount, currentBalance);
      }

      currentBalance -= amount;
      accounts[msg.sender] = currentBalance;
      emit Withdrawal(amount, accounts[msg.sender]);
   }

   function transfer(address destinationAccount, int amount) public {
      int currentBalance = accounts[msg.sender];

      if(currentBalance < amount) {
         revert InsufficientBalance(amount, currentBalance);
      }

      currentBalance -= amount;
      accounts[msg.sender] = currentBalance;
      accounts[destinationAccount] += amount;
      emit Sent(msg.sender, destinationAccount, amount);
   }
}
