pragma solidity ^0.8.0;

contract ProofofExistence{
    // state
    bytes32 public proof;

    function notarize(string memory document)public{
        proof = proofFor(document);
    }

    function proofFor(string memory document) public pure returns(bytes32){
        return sha256(abi.encodePacked(document));
    }
}
