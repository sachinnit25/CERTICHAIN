// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CertiChain - Simple Blockchain-Based Certificate System
/// @author ...
/// @notice This is a beginner-friendly example of an on-chain certification registry.

contract CertiChain {
    // Owner (admin) who can issue certificates
    address public owner;

    // Certificate structure
    struct Certificate {
        string studentName;
        string courseName;
        string institution;
        uint256 dateIssued;
        address issuedBy;
    }

    // Mapping of certificate IDs to certificate data
    mapping(uint256 => Certificate) public certificates;

    // Counter for certificate IDs
    uint256 public certCount;

    // Events
    event CertificateIssued(
        uint256 indexed certId,
        string studentName,
        string courseName,
        string institution,
        uint256 dateIssued,
        address issuedBy
    );

    // Only the contract owner can issue certificates
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can issue certificates");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Issue a new certificate
    /// @param _studentName Name of the student receiving the certificate
    /// @param _courseName Name of the course completed
    /// @param _institution Name of the issuing institution
    function issueCertificate(
        string memory _studentName,
        string memory _courseName,
        string memory _institution
    ) external onlyOwner {
        certCount++;
        certificates[certCount] = Certificate({
            studentName: _studentName,
            courseName: _courseName,
            institution: _institution,
            dateIssued: block.timestamp,
            issuedBy: msg.sender
        });

        emit CertificateIssued(
            certCount,
            _studentName,
            _courseName,
            _institution,
            block.timestamp,
            msg.sender
        );
    }

    /// @notice Verify if a certificate exists
    /// @param _certId The ID of the certificate to verify
    /// @return certificate details (name, course, institution, etc.)
    function verifyCertificate(uint256 _certId)
        external
        view
        returns (Certificate memory)
    {
        require(_certId > 0 && _certId <= certCount, "Certificate does not exist");
        return certificates[_certId];
    }
}

