// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    //generating a random number
    uint256 private seed;

    //a new event
    event NewWave(address indexed from, uint256 timestamp, string message);

    //struct wave which can be custamize to hold what we want
    struct Wave {
        address waver; //address of the user who waved
        string message; //the message the user sent
        uint256 timestamp; //the timestamp when the user waved
    }

    //decalring a array waves which stores an array of structs. it holds all the waves anyone ever sent
    Wave[] waves;

    //this is an address => uint mapping, meaning we can associate an address with a number!
    //in this case , we will be storing the address with the last time the user waved at us.
    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("We have been constructed!");
        //set the initial seed
        seed = (block.timestamp + block.difficulty) % 100;
    }

    //function takes string called message, this is the message our user sends us from the frontend
    function wave(string memory _message) public {
        //we need to make sure the current timestamp is at least 30 sec bigger the last timestamp we stored
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Wait 30s"
        );
        //update the current timestamp we have for the user
        lastWavedAt[msg.sender] = block.timestamp;
        totalWaves += 1;
        console.log("%s has waved!", msg.sender);

        //storing the wave data in the array
        waves.push(Wave(msg.sender, _message, block.timestamp));

        //generating a new seed for the next user that sends a wave
        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);

        //give 50% chance that the user wins the prize
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            //giving eth to others
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contact has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contact.");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }

    //adding a function getAllWaves which will return the struct array, waves, to us. this will make it easy to retrieve the waves from our website

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d waves", totalWaves);
        return totalWaves;
    }
}
