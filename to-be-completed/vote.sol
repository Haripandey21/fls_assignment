// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract cityPoll {
    
    struct City {
        string cityName;
        uint256 vote;
        //you can add city details if you want
    }


    mapping(uint256 => City) public cities; //mapping city Id with the City ctruct - cityId should be uint256
    mapping(address => bool) hasVoted; //mapping to check if the address/account has voted or not

    address owner;
    uint256 public cityCount = 0; // number of city added
    
    constructor()  {
    
    //TODO set contract caller as owner
    //TODO set some intitial cities.
     owner = msg.sender;
        cities[cityCount] = City("kirtipur",0);
    
        cityCount++;
    
    }
 
 function addCity(string memory _cityName) public{
        cities[cityCount] = City(_cityName,0);
        cityCount ++;
    }
   function vote(uint256 cityID) public {
        City storage myVote = cities[cityID];
        myVote.vote ++;
    }

    function getCity(uint256 cityID) public view returns(string memory){
        City storage myCity = cities[cityID];
        return myCity.cityName;
    }

     function getVote(uint256 cityID) public view returns (uint256) {
         City storage myCity = cities[cityID];
         return myCity.vote;
     }
}
    
