// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0


pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Stakingcontract{
ERC20 public token;
uint256 public rewardRate = 100; // Beispiel-Belohnungsrate
uint256 public totalStaked;
uint256 public stakingPeriod;
bool public paused;
address public owner;
address[] public Staker;
mapping(address => uint256) public stakedAmounts;
mapping(address => uint256) public rewardBalances;
mapping(address => uint256) public lastStakedTime;
mapping(address => bool) public whitelist;
//mapping(address => bool) public isStaker;

//verschiedene Events
event Staked(address indexed user, uint256 amount);
event Unstaked(address indexed user, uint256 amount);
event RewardPaid(address indexed user, uint256 reward);
event EmergencyWithdraw(address indexed user, uint256 amount);

//modifier
modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
}

modifier whenNotPaused() {
        require(!paused, "Staking is paused");
        _;
}

//constructor
constructor(ERC20 _token) {
        token = _token;
        owner = msg.sender;
}

function stake(uint256 amount) external whenNotPaused {
        require(amount > 0, "Amount must be greater than 0"); //mindest-Amount
        token._transfer(msg.sender, address(this), amount); //Transfer-Befehl
        stakedAmounts[msg.sender] += amount;  // Mappen des neu-gestaketen Amounts auf den Key-Value (Empfangsadresse)
        totalStaked += amount; // Insgesamt gestaketen coins von allen Usern
        lastStakedTime[msg.sender] = block.timestamp; //Mappen der Zeit des Stakes auf den Empfänger-Key
        Staker.push(msg.sender);  //Adresse wird zu adressen der Staker hinzugefügt

             //Alternative weniger gas fees
             //if (!isStaker[msg.sender]) {  // Überprüfen ob der Benutzer bereits ein Staker ist
             //isStaker[msg.sender] = true;
             //   }

        emit Staked(msg.sender, amount);   // Hier wird ein log gespeichert
}
function unstake(uint256 amount)external whenNotPaused{
    require( amount > 0  && amount <= stakedAmounts[msg.sender], "Amount must be greater than 0 and smaller then the staked Amount"); //mindest-Amount
    _updateReward(msg.sender);
    stakedAmounts[msg.sender] -= amount;  // Mappen des neu-gestaketen Amounts auf den Key-Value (Empfangsadresse)
    totalStaked -= amount; // Insgesamt gestaketen coins von allen Usern
    token._transfer(address(this), msg.sender, amount); //Transfer-Befehl
    emit Unstaked(msg.sender, amount);
}


function restake(){}
function calcReward(){}
function distributeReward(){}
function setRewardRate(){}
function SetStakingPeriod(){}
function pause(){}
function unpause(){}
function stakedAmount(){}
function totalStaked(){}
function rewardBalance(){}
function EmWithdraw(){}
function AddtoWhitelist(){}
function RemfromWhielist(){}
function _updateReward(){}
}