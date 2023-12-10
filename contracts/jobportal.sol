// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract JobPortal {

    address public admin;

    constructor() {
        admin = msg.sender;
    }

    struct user {
        address id;
        string name;
        string emailId;
        UserType userType;
        uint rating;
    }

    struct job {
        string jobId;
        string title;
        string description;
        uint salary;
        address employer;
        uint vacantSeats;
    }
    
    enum UserType {applicant, employer}

    mapping (address => user) UserDetails;
    mapping (string => job) JobDetails;

    event NewApplicantAdded(address indexed applicantAddress, string name, string _emailId, UserType);
    event NewJobAdded(string jobId, string jobTitle, string jobDescription, uint salary, address indexed employer);
    event JobApplication(string jobId, address indexed applicant);
    event ApplicantRating(address indexed applicantId, uint indexed rating);


    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    modifier onlyApplicant() {
        require(UserDetails[msg.sender].userType <= UserType.applicant, "Only applicant can perform this action");
        _;
    }

    modifier onlyEmployer() {
        require(UserDetails[msg.sender].userType >= UserType.employer, "Only employer can perform this action");
        _;
    }
    // Add a new applicant
    function addUser(address _id, string memory _name, string memory _emailId, UserType typeOfUser) public onlyAdmin {
        require(bytes(_name).length > 0, "Name is required");
        require(typeOfUser <= UserType.applicant, "Type is required");
        UserDetails[_id].id = _id;
        UserDetails[_id].name = _name;
        UserDetails[_id].emailId = _emailId;
        UserDetails[_id].userType = typeOfUser;
        UserDetails[_id].rating = 0;
        emit NewApplicantAdded(msg.sender, _name, _emailId, typeOfUser);
    }

    // Get Applicant Details
    function getUserDetails(address _id) public view returns (
        address,
        string memory, 
        string memory,
        uint,
        UserType) {
        return (
            UserDetails[_id].id,
            UserDetails[_id].name,
            UserDetails[_id].emailId,
            UserDetails[_id].rating,
            UserDetails[_id].userType
        );
    }

    function getUserType(address _id) public view returns (UserType) {
        return UserDetails[_id].userType;
    }

    // Add a new Job
    function addJob(string memory _jobId, string memory _jobTitle, string memory _jobDescription, uint _salary, address _employer, uint _vacantSeats) public onlyEmployer {
        require(bytes(_jobTitle).length > 0, "Job title is required");
        require(bytes(_jobDescription).length > 0, "Job description is required");
        JobDetails[_jobId].jobId = _jobId;
        JobDetails[_jobId].title = _jobTitle;
        JobDetails[_jobId].description = _jobDescription;
        JobDetails[_jobId].salary = _salary;
        JobDetails[_jobId].employer = _employer;
        JobDetails[_jobId].vacantSeats = _vacantSeats;    
        emit NewJobAdded(_jobId, _jobTitle, _jobDescription, _salary, _employer);
    }
    
    // Get Job Details
    function getJobDetails(string memory _jobId) public view returns (string memory, string memory, uint, address, uint) {
        return (
            JobDetails[_jobId].title,
            JobDetails[_jobId].description,
            JobDetails[_jobId].salary,
            JobDetails[_jobId].employer,
            JobDetails[_jobId].vacantSeats
        );
    }

    // Apply for Job
    function applyForJob(string memory _jobId) public onlyApplicant {
        require(JobDetails[_jobId].vacantSeats == 0 , "Job is not open for applications");
        emit JobApplication(_jobId, msg.sender);
    }

    // Add rating for applicant
    function rateApplicant(address _applicantId, uint _rating) public onlyEmployer {
        require(_rating >= 1 && _rating <= 5, "Rating must be between 1 and 5");
        UserDetails[_applicantId].rating = _rating;
        emit ApplicantRating(_applicantId, _rating);
    }

    
    // Get rating for applicant
    function getApplicantRating(address _applicantId) public view returns (address, string memory, uint) {
        return (
            UserDetails[_applicantId].id,
            UserDetails[_applicantId].name,            
            UserDetails[_applicantId].rating
        );
    }

}