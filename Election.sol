pragma solidity ^0.4.12;

// SPDX-License-Identifier: GPL-3.0

import "./Ownable.sol";
import "./SafeMath.sol";
import "./Whitelist.sol";

contract Election is Ownable, Whitelist {
    using SafeMath for uint256;

    struct Candidate {
        uint256 id;
        string name;
        uint voteCount;
        uint forVotes;
        uint againstVotes;
        uint neutralVotes;
    }

    mapping(address => bool) public voters;
    mapping(uint => Candidate) public candidates;
    uint public candidatesCount;
    address public president;
    address public scrutateur;
    address public secretaire;

    event votedEvent ( uint indexed _candidateId);

    constructor(
        address _president,
        address _scrutateur,
        address _secretaire
    ) public {
        president = _president;
        scrutateur = _scrutateur;
        secretaire = _secretaire;
    }

    function addCandidate(string memory _name) public onlyOwner {
        candidatesCount ++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0, 0, 0, 0);
    }

    function vote(uint _candidateId, uint _voteType) public {
        require(isWhitelisted(msg.sender), "This person is not on whitelist.");
        require(!voters[msg.sender], "Already voted for this candidate!!");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Error on candidate id.");

        voters[msg.sender] = true;
        candidates[_candidateId].voteCount++;

        if (_voteType == 1) {
            candidates[_candidateId].forVotes++;
        } else if (_voteType == 2) {
            candidates[_candidateId].againstVotes++;
        } else if (_voteType == 3) {
            candidates[_candidateId].neutralVotes++;
        } else {
            revert("Invalid vote type");
        }

        emit votedEvent(_candidateId);
    }
}
