local Module = {};
local Connections = {Scrollers = {}, GuiObjects = {}};

function Module:Add(Object, Additive, IsOnlyY, Default)
	local Layout  = Object:FindFirstChildWhichIsA('UIListLayout') or Object:FindFirstChildWhichIsA('UIGridLayout');

	local function Update()
		Object.Size = UDim2.new(Default or 0, IsOnlyY and Object.Size.X.Offset or Layout.AbsoluteContentSize.X, 0, Layout.AbsoluteContentSize.Y + Additive);
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
	Connections.GuiObjects[Object] = nil;
end;

function Module:RemoveScroller(Scroller)
	Connections.Scrollers[Scroller] = nil;
end;

return Module;