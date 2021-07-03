local Module = {};
local Connections = {
	Scrollers = {},
	GuiObjects = {}
};

function Module:Add(Object, Additive, IsOnlyY)
	local Layout = Object:FindFirstChildWhichIsA('UIListLayout') or Object:FindFirstChildWhichIsA('UIGridLayout');

	local function Update()
		Object.Size = UDim2.new(0, IsOnlyY and Object.Size.X.Offset or Layout.AbsoluteContentSize.X, 0, Layout.AbsoluteContentSize.Y) + Additive;
	end;

	Connections.GuiObjects[Object] = {
		Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(Update),

		Object.AncestryChanged:Connect(function()
			if not Object.Parent then
				self:Remove(Object);
			end;
		end),

		Object.ChildAdded:Connect(function()
			spawn(Update);
		end);

		Object.ChildRemoved:Connect(Update)
	};

	Update();
end;

function Module:AddScroller(Scroller, Additive, IsOnlyY)
	local Layout = Scroller:FindFirstChildWhichIsA('UIListLayout') or Scroller:FindFirstChildWhichIsA('UIGridLayout');

	local function Update()
		Scroller.CanvasSize = UDim2.new(0, IsOnlyY and 0 or Layout.AbsoluteContentSize.X, 0, Layout.AbsoluteContentSize.Y + Additive);
	end;

	Connections.Scrollers[Scroller] = {
		Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(Update),

		Scroller.AncestryChanged:Connect(function()
			if not Scroller.Parent then
				self:RemoveScroller(Scroller);
			end;
		end),

		Scroller.ChildAdded:Connect(function()
			spawn(Update);
		end),

		Scroller.ChildRemoved:Connect(Update)
	};

	Update();
end;

function Module:Remove(Object)
	if Connections.GuiObjects[Object] then
		for _, Connection in pairs(Connections.GuiObjects) do
			if Connection then
				Connection:Disconnect();
			end;
		end;

		Connections.GuiObjects[Object] = nil;
	end;
end;

function Module:RemoveScroller(Scroller)
	if Connections.Scrollers[Scroller] then
		for _, Connection in pairs(Connections.Scrollers) do
			if Connection then
				Connection:Disconnect();
			end;
		end;

		Connections.Scrollers[Scroller] = nil;
	end;
end;

return Module;
