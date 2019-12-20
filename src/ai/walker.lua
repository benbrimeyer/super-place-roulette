local RADIUS = 15

return function(parent)
	local humanoid = parent:FindFirstChildOfClass("Humanoid")
	local origin = parent.PrimaryPart.Position

	repeat
		wait(math.random(1, 3))
		humanoid:MoveTo(origin + Vector3.new(math.random() * RADIUS, 0, math.random() * RADIUS))
	until false
end