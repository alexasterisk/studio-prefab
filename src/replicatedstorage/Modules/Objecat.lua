-- extends:
-- Instance.new
-- Instance:FindFirstChild
-- Instance:GetAttribute
-- Instance:SetAttribute

local Module = {};

function Module:Create(Type, Properties, Children)
	local Object = Instance.new(Type);
	
	if Properties then
		if typeof(Properties) == 'Instance' then
			Object.Parent = Properties;
		else
			for Property, Value in pairs(Properties) do
				Object[Property] = Value;
			end;
		end;
	end;
	
	if Children then
		for Name, Child in pairs(Children) do
			if type(Name) == 'string' then
				Child.Name = Name;
			end;
			
			Child.Parent = Object;
		end;
	end;
	
	return Object;
end;

function Module:Clone(Object, Properties)
	local Cloned = Object:Clone();
	
	if Properties then
		if typeof(Properties) == 'Instance' then
			Cloned.Parent = Properties;
		else
			for Property, Value in pairs(Properties) do
				Cloned[Property] = Value;
			end;
		end;
	end;
	
	return Cloned;
end;

function Module:Weld(Model, MainPart)
	assert(typeof(Model) == 'Instance');
	
	if typeof(MainPart == 'Instance') then
		for _, Child in ipairs(Model:GetChildren()) do
			if Child ~= MainPart and Child:IsA('BasePart') then
				self:Create('WeldConstraint', {
					Parent = MainPart,
					Part0 = MainPart,
					Part1 = Child
				});
			end;
		end;
	end;
	
	return Model;
end;

function Module:FindOrMake(Search, Type, Name)
	
	local WasCreated = false;
	local Object;
	
	for _, Child in ipairs(Search:GetChildren()) do
		if Child:IsA(Type) then
			if Name then
				if Child.Name == Name then
					Object = Child;

					break;
				end;
			else
				Object = Child;
				
				break;
			end;
		end;
	end;
	
	if not Name then
		Name = Type;
	end;
	
	if not Object then
		WasCreated = true;
		
		Object = Module:Create(Type, {
			Name = Name,
			Parent = Search
		});
	end;
	
	return Object, WasCreated;
end;

-- this does remove the ability of functions lol
function Module:AttributesToVariables(Object)
	local Metatable = {
		__index = function(_, Value)
			assert(type(Value) == 'string');
			
			if Object[Value] ~= nil then
				return Object[Value];
			else
				if Object:GetAttribute(Value) ~= nil then
					return Object:GetAttribute(Value);
				end;
			end;
		end,
		
		__newindex = function(Table, Index, Value)
			assert(type(Index) == 'string');
			
			if Object[Index] ~= nil then
				Object[Index] = Value;
			else
				Object:SetAttribute(Index, Value);
			end
			
			return Table[Index];
		end
	};
	
	return setmetatable({}, Object);
end;

return Module;
