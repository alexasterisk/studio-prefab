local Module = {};
local Connections = {};

local function GetHorizontalAmount(Table)
	local Current = -1;
	local Absolutes = {};
	
	for _, Object in pairs(Table) do
		local AbsoluteY = Object.AbsolutePosition.Y;
		
		if Absolutes[AbsoluteY] then
			table.insert(Absolutes[AbsoluteY], Object);
		else
			Absolutes[AbsoluteY] = {Object};
		end;
	end;
	
	for _, Objects in pairs(Absolutes) do
		if #Objects > Current then
			Current = #Objects;
		end;
	end;
	
	return Current;
end;

local function GetVerticalAmount(Table)
	local Current = -1;
	local Absolutes = {};
	
	for _, Object in pairs(Table) do
		local AbsoluteX = Object.AbsolutePosition.X;
		
		if Absolutes[AbsoluteX] then
			table.insert(Absolutes[AbsoluteX], Object);
		else
			Absolutes[AbsoluteX] = {Object};
		end;
	end;
	
	for _, Objects in pairs(Absolutes) do
		if #Objects > Current then
			Current = #Objects;
		end;
	end;
	
	return Current;
end;

function Module:Connect(Scroller, IsOnlyY)
	local Layout = Scroller:FindFirstChildWhichIsA('UIListLayout') or Scroller:FindFirstChildWhichIsA('UIGridLayout');
	
	local function GetObjects()
		local Objects = {};
		
		for _, Object in ipairs(Scroller:GetChildren()) do
			if Object:IsA('GuiObject') then
				table.insert(Objects, Object);
			end;
		end;
		
		return Objects;
	end
	
	local function Update()
		Scroller.CanvasSize = UDim2.new(0, IsOnlyY and 0 or Layout.AbsoluteContentSize.X, 0, Layout.AbsoluteContentSize.Y + 25);
	end;
	
	Connections[Scroller] = {
		Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(Update),

		Scroller.AncestryChanged:Connect(function()
			if not Scroller.Parent then
				self:Disconnect(Scroller);
			end;
		end),
		
		Scroller.ChildAdded:Connect(function()
			spawn(Update);
		end),
		
		Scroller.ChildRemoved:Connect(Update)
	};
	
	Update();
end;

function Module:Disconnect(Scroller)
	if Connections[Scroller] then
		for _, Connection in pairs(Connections) do
			if Connection then
				Connection:Disconnect();
			end;
		end;
		
		Connections[Scroller] = nil;
	end;
end;

return Module;
