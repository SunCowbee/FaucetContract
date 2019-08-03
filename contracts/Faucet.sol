pragma solidity ^0.4.17;

contract Faucet {

    address public manager;
    address[] public players;
    address public winner;

    function Faucet() public {
        manager = msg.sender;
    }

    function getManager() public view returns (address){
        return manager;
    }

    function enter() public payable {
        require(msg.value == 1 ether);
        players.push(msg.sender);
    }

    function getAllPlayers() public view returns (address[]){
        return players;
    }

    function getBalance() public view returns (uint){
        return this.balance;
    }

    function getPlayersCount() public view returns (uint){
        return players.length;
    }

    function random() private view returns (uint){
        return uint(keccak256(block.difficulty, now, players));
    }

    function pickWinner() public onlyManagerCanCall {
        uint index = random() % players.length;
        winner = players[index];
        players = new address[](0);
        winner.transfer(this.balance);
    }

    function refund() public onlyManagerCanCall {

        for (uint i = 0; i < players.length; i++) {
            players[i].transfer(1 ether);
        }
        players = new address[](0);
    }

    modifier onlyManagerCanCall(){
        require(msg.sender == manager);
        _;
    }

}