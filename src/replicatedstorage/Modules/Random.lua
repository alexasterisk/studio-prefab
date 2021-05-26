return function(Minimum, Maximum, Decimal)
	Minimum = Minimum or 0
	Maximum = Maximum or 1
	local Random = Random.new()
	if Decimal then
		return Random:NextInteger(Minimum, Maximum)
	else
		return Random:NextNumber(Minimum, Maximum)
	end
end
