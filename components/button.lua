local LowerClass = require 'lib.LowerClass.LowerClass'
local component = require 'lib.Badr.badr'

---@class ButtonClass : Badr
local ButtonClass = LowerClass('ButtonClass', component)

-- https://github.com/s-walrus/hex2color/blob/master/hex2color.lua
local function Hex(hex, value)
	return {
		tonumber(string.sub(hex, 2, 3), 16) / 256,
		tonumber(string.sub(hex, 4, 5), 16) / 256,
		tonumber(string.sub(hex, 6, 7), 16) / 256,
		value or 1 }
end

function ButtonClass:__init(t)
	component.__init(self, {
		font = love.graphics.getFont(),
		-- Styles
		opacity = 1,
		backgroundColor = Hex '#DBE2EF',
		hoverColor = Hex '#3F72AF',
		textColor = Hex '#112D4E',
		cornerRadius = 4,
		leftPadding = 12,
		rightPadding = 12,
		topPadding = 8,
		bottomPadding = 8,
		borderColor = { 1, 1, 1 },
		borderWidth = 0,
		border = false,
		angle = 0,
		scale = 1,
		-- Logic
		disabled = false,
	})
	self:include(t)
end

function ButtonClass:updatePosition(x, y)
	component.updatePosition(self, x, y)
	self.width = math.max(self.width, self.font:getWidth(self.text) + self.leftPadding + self.rightPadding)
	self.height = math.max(self.height, self.font:getHeight(self.text) + self.topPadding + self.bottomPadding)
end

function ButtonClass:mousepressed(x, y, button)
	if self:isInside(x, y) then
		return self:propegateEvent('onClick')
	end
end

function ButtonClass:mousemoved(x, y, dx, dy)
	local isInside = self:isInside(x, y)

	if self.hovering and not isInside then
		self.hovering = false
		return self.onExit and self:onExit()
	elseif not self.hovering and isInside then
		self.hovering = true
		return self.onEnter and self:onEnter()
	end
end

function ButtonClass:onEnter()
	love.mouse.setCursor(love.mouse.getSystemCursor('hand'))
end

function ButtonClass:onExit()
	love.mouse.setCursor()
end

function ButtonClass:draw()
	if not self.visible then return end

	love.graphics.push()
	love.graphics.rotate(self.angle)
	love.graphics.scale(self.scale, self.scale)
	love.graphics.setFont(self.font)

	-- Border
	if self.border then
		love.graphics.setColor(self.borderColor)
		love.graphics.setLineWidth(self.borderWidth)
		love.graphics.rectangle('line', self.x, self.y, self.width, self.height, self.cornerRadius)
		love.graphics.setColor({ 0, 0, 0 })
	end

	-- Background
	if self.hovering then
		love.graphics.setColor(self.hoverColor[1], self.hoverColor[2], self.hoverColor[3], self.opacity)
	else
		love.graphics.setColor({
			self.backgroundColor[1],
			self.backgroundColor[2],
			self.backgroundColor[3],
			self.opacity
		})
	end
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, self.cornerRadius)

	-- Text
	love.graphics.setColor(self.textColor[1], self.textColor[2], self.textColor[3], self.opacity)
	love.graphics.printf(self.text, self.x + self.leftPadding, self.y + self.topPadding,
		self.width - self.leftPadding - self.rightPadding, 'center')

	love.graphics.setColor({ 1, 1, 1 })
	love.graphics.pop()
end

return ButtonClass
