local LowerClass = require 'lib.LowerClass'
local component = require 'lib.Badr.badr'

---@class Label : Badr
local Label = LowerClass('Label', component)

function Label:__init(t)
	-- If a string is passed, convert it to a table
	if type(t) == 'string' then t = { text = t } end

	component.__init(self, {
		font = love.graphics.getFont(),
		-- Styles
		opacity = 1,
		color = { 0, 0, 0 },
		-- Logic
		text = t.text or t,
		visible = t.visible or true,
		id = t.id,
	})
	self:include(t)
end

function Label:updatePosition(x, y)
	component.updatePosition(self, x, y)
	self.width = self.font:getWidth(self.text)
	self.height = self.font:getHeight(self.text)
end

function Label:draw()
	if not self.visible then return end
	love.graphics.setFont(self.font)
	love.graphics.setColor({
		self.color[1], self.color[2], self.color[3], self.opacity
	})
	love.graphics.print(self.text, self.x, self.y)
	love.graphics.setColor({ 1, 1, 1 })
end

return Label
