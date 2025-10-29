// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LoanChain - Immutable record of borrowed and repaid funds
/// @author ...
/// @notice Stores loan and repayment records transparently on-chain

contract LoanChain {

    // Structure to store each loan transaction
    struct LoanRecord {
        uint256 id;
        address borrower;
        uint256 amountBorrowed;
        uint256 amountRepaid;
        uint256 timestamp;
        string status; // "Borrowed" or "Repaid"
    }

    // Array to hold all records
    LoanRecord[] public records;

    // Event logs for blockchain transparency
    event LoanBorrowed(uint256 id, address borrower, uint256 amount, uint256 timestamp);
    event LoanRepaid(uint256 id, address borrower, uint256 amount, uint256 timestamp);

    uint256 private nextId = 1;

    /// @notice Record a new loan borrow transaction
    /// @param amount Amount borrowed by the sender
    function borrow(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");

        records.push(LoanRecord({
            id: nextId,
            borrower: msg.sender,
            amountBorrowed: amount,
            amountRepaid: 0,
            timestamp: block.timestamp,
            status: "Borrowed"
        }));

        emit LoanBorrowed(nextId, msg.sender, amount, block.timestamp);
        nextId++;
    }

    /// @notice Record a loan repayment transaction
    /// @param amount Amount repaid by the sender
    function repay(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");

        records.push(LoanRecord({
            id: nextId,
            borrower: msg.sender,
            amountBorrowed: 0,
            amountRepaid: amount,
            timestamp: block.timestamp,
            status: "Repaid"
        }));

        emit LoanRepaid(nextId, msg.sender, amount, block.timestamp);
        nextId++;
    }

    /// @notice Get total number of records
    function getTotalRecords() external view returns (uint256) {
        return records.length;
    }

    /// @notice Retrieve a specific record by ID (1-based)
    function getRecord(uint256 id) external view returns (LoanRecord memory) {
        require(id > 0 && id <= records.length, "Invalid record ID");
        return records[id - 1];
    }
}

