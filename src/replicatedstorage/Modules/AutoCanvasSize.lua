local Module = {};
local Connections = {};

function Module:Connect(Scroller, IsOnlyY)
	local Layout = Scroller:FindFirstChildWhichIsA('UIListLayout') or Scroller:FindFirstChildWhichIsA('UIGridLayout');

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
