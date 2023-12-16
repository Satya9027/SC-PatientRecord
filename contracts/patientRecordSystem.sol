// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract patientRecord {

    address public admin;

    constructor(){
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "No access provided for users other than admin!");
        _;
    }

    struct Doctor {
        address id;
        string name;
        string qualification;
        string currentWorkPlace;
    }

    struct Patient {
        address patientAddress;
        string name;
        uint256 age;
        string[] disease;
    }
    
    struct Medicine {
        uint medicineId;
        string name;
        string expiryDate;
        string dose;
        uint256 price;
        uint availableUnits;
    }

    struct PrescribeMedicine {
        address doctorId;
        address patientId;
        uint[] medicineArray;
    }
    
    // PrescribeMedicine[] medicineArray;
    mapping(address => Patient) internal patients;
    mapping(address => Doctor) internal doctors;
    mapping(uint256 => Medicine) internal medicines;
    mapping(address => PrescribeMedicine) prescribeMedicine;
   
   // Modifier functions
    modifier onlyDoctor() {
        require(bytes(doctors[msg.sender].name).length > 0, "Only registered doctors can call this function");
        _;
    }

    modifier onlyPatient() {
        require(bytes(patients[msg.sender].name).length > 0, "Only patients can call this function");
        _;
    }
    
    // Register a doctor 
    function registerDoctor(address _id, string memory _name, string memory _qualification, string memory _workPlace) external onlyAdmin {
        require(bytes(_name).length > 0, "Name is required");
        require(bytes(_qualification).length > 0, "Qualification is required");
        require(bytes(_workPlace).length > 0, "Workplace details are required");
        doctors[_id].id = _id;
        doctors[_id].name = _name;
        doctors[_id].qualification = _qualification;
        doctors[_id].currentWorkPlace = _workPlace;
    }
    
    
    // Fetch dotor details
    function fetchDoctorDetails(address _id) external view onlyAdmin returns (
        string memory,
        string memory,
        string memory) {
        return(
            doctors[_id].name,
            doctors[_id].qualification,
            doctors[_id].currentWorkPlace
        );
    }
    
    // Register new patient
    function registerPatient(address _patientAddress, string memory _name, uint256 _age, string memory _disease) public {
        patients[_patientAddress].patientAddress = _patientAddress;
        patients[_patientAddress].name = _name;
        patients[_patientAddress].age = _age;
        patients[_patientAddress].disease.push(_disease);
    }
    
    // Register new patient
    function fetchPatientDetails(address _id) external view returns (
        string memory,
        uint256,
        string[] memory) {
        return (
        patients[_id].name, 
        patients[_id].age,
        patients[_id].disease
        );
    }

    // Update patient detail
    function updatePatientDetails(address _id, uint _age) external onlyPatient {
        patients[_id].age = _age;
    }

    // Update patient ldisease
    function updatePatientDisease(address _id, string memory _disease) external onlyDoctor {
        patients[_id].disease.push(_disease);
    }

    // Add medicine to inventory
    function addMedicine(uint _medicineId, string memory _name, string memory _expiryDate, string memory _dose, uint _price, uint _unitsAvailable) external onlyAdmin {
       medicines[_medicineId].medicineId = _medicineId;
       medicines[_medicineId].name = _name;
       medicines[_medicineId].expiryDate = _expiryDate;
       medicines[_medicineId].dose = _dose;
       medicines[_medicineId].price = _price;
       medicines[_medicineId].availableUnits = _unitsAvailable;
    }
    
    // Fetch medicine details
    function fetchMedicineDetails(uint256 _medicineId) external view returns (
        string memory,
        string memory,
        string memory,
        uint, 
        uint) {
        return(
            medicines[_medicineId].name,
            medicines[_medicineId].expiryDate,
            medicines[_medicineId].dose,
            medicines[_medicineId].price,
            medicines[_medicineId].availableUnits
        );
    }

    // Prescribe medicine
    function prescribeMedicineForPatient(address _doctorId, uint _medicineId, address _patientId) external onlyDoctor { 
        prescribeMedicine[_patientId].patientId = _patientId;
        prescribeMedicine[_patientId].doctorId = _doctorId;
        prescribeMedicine[_patientId].medicineArray.push(_medicineId);
    }

    // View patient details
    function viewPatientDetails(address _patientId) external view returns (
        address,
        string memory,
        uint) {
        return(
            patients[_patientId].patientAddress,
            patients[_patientId].name,
            patients[_patientId].age
        );
    }

        // View patient details by doctor
    function viewPatientDetailsByDoctor(address _patientId) external view onlyDoctor returns (
        address,
        string memory,
        uint,
        string[] memory) {
        return(
            patients[_patientId].patientAddress,
            patients[_patientId].name,
            patients[_patientId].age,
            patients[_patientId].disease
        );
    }

    // Fetch prescribed medicines for a patient
    function viewPrescribedMedicine(address _patientId) external view returns (
        uint[] memory) {
        return(
            prescribeMedicine[_patientId].medicineArray
        );
    }
}