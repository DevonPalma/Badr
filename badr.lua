--
-- Badr
--
-- Copyright (c) 2024 Nabeel20
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--

local LowerClass = require 'lib.LowerClass'
local TreeMixin = require 'lib.LowerClass.mixins.TreeMixin'

---@class Badr : Class, TreeMixin
---@field new fun(self: Badr, t: table): Badr
---@field x number
---@field y number
---@field height number
---@field width number
---@field parent TreeMixin
---@field id string
---@field visible boolean
---@field children TreeMixin[]
local Badr = LowerClass:new("Badr", TreeMixin)

function Badr:__init(t)
	--- Generate default values
	self:include({
		x = 0,
		y = 0,
		height = 0,
		width = 0,
		parent = nil,
		id = tostring(love.timer.getTime()),
		visible = true,
		children = {},
	})

	-- Mixin the table above
	self:include(t)
end

-- ---------------------- Adding / Subtracting Children --------------------- --

function Badr:add(child, index)
	if not LowerClass.is(child, Badr) then return self end

	self:addChild(child, index)

	self:updatePosition(self.x, self.y)
	return self
end

Badr.__add = Badr.add


function Badr:sub(component)
	if not LowerClass.is(component, Badr) then return self end

	self:removeChild(component)

	self:updatePosition(self.x, self.y)

	return self
end

Badr.__sub = Badr.sub

---Ensures a component has it's position updated
---@param x any
---@param y any
function Badr:updatePosition(x, y)
	-- Update this component's position
	self.x = x
	self.y = y

	local offsetX, offsetY = x, y -- Track positions for placing children

	-- Iterate over children, placing them based on layout
	for _, child in ipairs(self.children) do
		if self.column then
			-- Place child vertically, updating offsetY by child height + gap
			child:updatePosition(offsetX, offsetY)
			offsetY = offsetY + child.height + (self.gap or 0)
			-- Update Badr's height to accommodate all children
			self.height = offsetY - y
		elseif self.row then
			-- Place child horizontally, updating offsetX by child width + gap
			child:updatePosition(offsetX, offsetY)
			offsetX = offsetX + child.width + (self.gap or 0)
			-- Update Badr's width to accommodate all children
			self.width = offsetX - x
		end
	end
end

-- --------------------------------- Utility -------------------------------- --

-- Returns child with specific id
function Badr:getChild(id)
	assert(type(id) == "string", 'Badar; Provided id must be a string.')
	if self.id == id then
		return self
	end

	for _, child in ipairs(self.children) do
		local found = child:getChild(id)
		if found then
			return found
		end
	end
end

Badr.__mod = Badr.getChild

function Badr:isInside(x, y)
	return x >= self.x and x <= self.x + self.width and
		y >= self.y and
		y <= self.y + self.height
end

function Badr:animate(props)
	props(self)
	for _, child in ipairs(self.children) do
		child:animate(props)
	end
end

function Badr:draw()
	if not self.visible then return end;
	if #self.children > 0 then
		for _, child in ipairs(self.children) do
			child:draw()
		end
	end
end

function Badr:update()
	if self.onUpdate then
		self:onUpdate()
	end
	for _, child in ipairs(self.children) do
		child:update()
	end
end

function Badr:propegateEvent(eventName, ...)
	for _, child in ipairs(self.children) do
		if child:propegateEvent(eventName, ...) then
			return true
		end
	end
	if self[eventName] then
		return self[eventName](self, ...)
	end
end

return Badr
