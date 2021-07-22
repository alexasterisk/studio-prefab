local function PerformCleanupTask(Task, ...)
	if type(Task) == 'function' then
		Task(...);
	elseif typeof(Task) == 'RBXScriptSignal' then
		Task:Disconnect();
	elseif typeof(Task) == 'Instance' then
		Task:Destroy();
	elseif type(Task) == 'table' then
		if type(Task.Destroy) == 'function' then
			Task:Destroy();
		elseif type(Task.Disconnect) == 'function' then
			Task:Disconnect();
		end;
	end;
end;

local Module = {};
Module._CleanupTasks = {};
Module._IsCleaned = {};
Module.__index = Module;

function Module:Add(Task)
	if self._IsCleaned == true then
		PerformCleanupTask(Task);
	end;

	if type(Task) == 'function' or typeof(Task) == 'RBXScriptSignal' or typeof(Task) == 'Instance' then
		table.insert(self._CleanupTasks, Task);
	elseif type(Task) == 'table' then
		if type(Task.Destroy) == 'function' or type(Task.Disconnect) == 'function' then
			table.insert(self._CleanupTasks, Task);
		else
			error('[MAID]: Received object table as cleanup task, but couldn\'t detect a :Destroy() method!');
		end;
	else
		error(string.format('[MAID]: Cleanup task of type "%s" is not supported!', typeof(Task)));
	end;
end;

function Module:Remove(Task)
	local CleanupTasks = self._CleanupTasks;
	Task = table.find(CleanupTasks, Task);

	if Task then
		table.remove(CleanupTasks, Task);
	end;
end;

function Module:Clean(...)
	for _, Task in ipairs(self._CleanupTasks) do
		PerformCleanupTask(Task, ...);
	end;

	self._CleanupTasks = {};
	self._IsCleaned = true;
end;

local Maid = {};

function Maid.new()
	local maid = {};
	maid._CleanupTasks = {};
	maid._IsCleaned = false;

	setmetatable(maid, Module);
	return maid;
end;

function Maid:CleanAll(...)
	PerformCleanupTask(...);
end;

return Maid;