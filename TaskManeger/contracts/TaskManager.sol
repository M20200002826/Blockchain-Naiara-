pragma solidity 0.5.4;

contract TaskManager{

    uint public nTasks;

    //enum TaskPhase (ToDo = 0, InProgress = 1, Done = 2, ....)
    enum TaskPhase {ToDo, InProgress, Done, Blocked, Review, Postponed, Canceled}

    struct TaskStruct{
        address name;
        string diagnostico;
        TaskPhase phase;
        // Priority 1-5: 1 higher, 5 less important
        uint CPF; 
    }

    TaskStruct[] private tasks;
    // TraskStruct[] public Tasks;

    mapping (address => uint[]) private myTasks;
    // mapping (address => uint[]) public myTasks;

    event TaskAdded(address name, string diagnostico, TaskPhase phase, uint CPF);

    modifier onlyOwner(uint _taskIndex){
        if(tasks[_taskIndex].owner == msg.sender){
            _;
        }
    }

    constructor() public{
        nTasks = 0;
        addTask ("Inserir dados", TaskPhase.Done,1);
        addTask ("Realizar exames", TaskPhase.ToDo, 1);
        addTask ("Diagnostico", TaskPhase.ToDo, 5);
    }

    function getTask(uint _taskIndex) public view
        returns (address name, string memory diagnostico, TaskPhase phase, uint CPF){

            owner = tasks[_taskIndex].name;
            name = tasks[_taskIndex].diagnostico;
            phase = tasks[_taskIndex].phase;
            priority = tasks[_taskIndex].CPF;

        }

    function listMyTasks() public view returns(uint[] memory){
        return myTasks[msg.sender];
    }

    function addTask(string memory _diagnostico, TaskPhase _phase, uint _CPF) public returns (uint index){
        require((_priority >= 1 && _priority <= 5), "Priority must be between 1 and 5");
        TaskStruct memory taskAux = TaskStruct ({
            name: msg.sender,
            diagnostico: _diagnostico,
            phase: _phase,
            CPF: _CPF
        });
        index = tasks.push(taskAux) - 1;
        nTasks++;
        myTasks[msg.sender].push(index);
        emit TaskAdded(msg.sender, _diagnostico, _phase, _CPF);   
    }

    function updatePhase(uint _taskIndex, TaskPhase _phase) public onlyOwner(_taskIndex){
        tasks[_taskIndex].phase = _phase;
    }

}    