// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

contract Struct {
struct Player {
        string username;
        uint age;
        address account;
        string grade; 
        bool isAlive;
    }
    Player[] public ListPlayer;
    mapping(address=> Player) public MappingPlayer;
     function getMappingPlayer(address key) public view returns (Player memory) {
    return MappingPlayer[key];
    }
    function setMappingPlayer(address key, Player memory value) public {
        MappingPlayer[key]=value;
    }

    function AddPlayer( string memory username, uint age,address account,string memory grade, bool isAlive) public{
        Player memory  p;
        p.username=username;
        p.age=age;
        p.account=account;
        p.grade= grade;
        p.isAlive=isAlive;
        //set array
        ListPlayer.push(p);
        //set map
        setMappingPlayer(account,p);
    }
     
      function remove(uint _index) public {
       

        for (uint i = _index; i < ListPlayer.length - 1; i++) {
            ListPlayer[i] = ListPlayer[i + 1];
        }
        ListPlayer.pop();


    }
     function removeWhithAdress(address adress) public {
      
      delete MappingPlayer[adress];
    }


 function GetPlayerByMArray(address  account) public view returns (Player memory){
           Player  memory  p;

          for (uint i = 0; i < ListPlayer.length; i++) 
          {
            if(account==ListPlayer[i].account)
            {
             p=ListPlayer[i];
            }
        }

         
       return p;
     }
     function GetPlayerByMapPlayer(address  account) public view returns (Player memory){
           Player  memory  p;

           p= getMappingPlayer(account);

         
       return p;
     }
     function UpdatePlayer(string memory username, uint age,address account,string memory grade, bool isAlive)  public  {
       Player  memory  p;
        p =GetPlayerByMapPlayer(account);
        p.username=username;
        p.age=age;
        p.grade=grade;
        p.isAlive=isAlive;
          for (uint i = 0; i < ListPlayer.length; i++) 
          {
            if(account==ListPlayer[i].account)
            {
             ListPlayer[i]=p;
            }
        }
        MappingPlayer[account]=p;
    }

    
}