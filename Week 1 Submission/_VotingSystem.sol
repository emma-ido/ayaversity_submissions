// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

contract VotingSystem {
    mapping(address => bool) private voters;

    event VotingSuccessful(address voterAddress, address candidateAddress);
    event DeclarationSuccessful(string candidateName, address candidateAddress, uint votes);
    error CandidateAlreadyExists(address candidateAddress);
    error CandidateDoesNotExist(address suppliedCandidateAddress);
    error YouHaveAlreadyVoted(address voterAddress);
    error VotingUnsuccessful(address voterAddress, address candidateAddress);

    struct CandidateVotesPair {
        string candidateName;
        address candidateAddress;
        uint votes;
    }

    CandidateVotesPair[] private candidates;
    CandidateVotesPair[] private candidatesWithHighestVotes;
    uint private highestVotes;

    function getCandidatesWithHighestVotes() public view returns (CandidateVotesPair[] memory) {
        return candidatesWithHighestVotes;
    }

    function getVotesForCandidate(address candidateAddress) public view returns(uint votes) {
        if(!checkIfCandidateExists(candidateAddress)) {
            revert CandidateDoesNotExist(candidateAddress);
        }

        for (uint i = 0; i < candidates.length; i++) {
            if(candidates[i].candidateAddress == candidateAddress) {
                return candidates[i].votes;
            }    
        }

    }

    function viewMyAddress() public view returns(address) {
        return msg.sender;
    }

    function declareAsCandidate(string memory name) public {
        
        if(checkIfCandidateExists(msg.sender)) {
            revert CandidateAlreadyExists(msg.sender);
        }

        CandidateVotesPair memory newCandidate = CandidateVotesPair(name, msg.sender, 0);
        candidates.push(newCandidate);
        emit DeclarationSuccessful(name, msg.sender, 0);
    }

    function checkIfCandidateExists(address candidateAddress) public view returns(bool) {
        for (uint i = 0; i < candidates.length; i++) {
            if(candidates[i].candidateAddress == candidateAddress) {
                return true;
            }    
        }

        return false;
    }

    function voteForCandidate(address candidateAddress) public {
        if(voters[msg.sender]) {
            revert YouHaveAlreadyVoted(msg.sender);
        }
        
        if(!checkIfCandidateExists(candidateAddress)) {
            revert CandidateDoesNotExist(candidateAddress);
        }
        
        if(addVoteToCandidate(candidateAddress)) {
            voters[msg.sender] = true;
            emit VotingSuccessful(msg.sender, candidateAddress);
        } else {
            revert VotingUnsuccessful(msg.sender, candidateAddress);
        }
    }

    function updateRankings() private {
        for (uint i = 0; i < candidates.length; i++) {
            if(candidates[i].votes > highestVotes) {
                delete candidatesWithHighestVotes;
                candidatesWithHighestVotes.push(candidates[i]);
                highestVotes = candidates[i].votes;
            }

            if(candidates[i].votes == highestVotes) {
                 candidatesWithHighestVotes.push(candidates[i]);
            }
        }
    }

    function addVoteToCandidate(address candidateAddress) private returns(bool) {
        for (uint i = 0; i < candidates.length; i++) {
            if(candidates[i].candidateAddress == candidateAddress) {
                candidates[i].votes++;
                updateRankings();
                return true;
            }
        }

        return false;
    }

}

