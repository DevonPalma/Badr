# Badar 🌕

Badar _(Full moon in Arabic)_ is a declarative, retained\* and flexbox inspired ui library, with focus on reactivity and composition in mind.

### Getting Started

- [API](docs/Core.md)
- [Callback functions](docs/Callback-functions.md)
- [How to create custom components?](docs/Custom-component-guide.md)

### Usage

Badar uses [classic](https://github.com/rxi/classic) as a dependency (not included).

```lua
function love.load()
    local container = require 'path.to.badar.lua'

    local button = container({ width = 25, height = 25 }):style({ color = { 1, 0, 0 } })
    local square = container({ width = 10, height = 10 }):style({ color = { 1, 0, 0 }, filled = true })

    main = container({ minWidth = screenWidth, minHeight = screenHeight, hideBorder = true })
        :content({
            square,
            button:onClick(function()
                square:update(function(sq)
                    sq.width = sq.width + 10;
                    return sq
                end)
            end),
        }):style({
            padding = { 16, 16, 16, 16 }
        }):layout({
            direction ='column'
        })
end

function love.draw()
    main:render()
end

function love.mousepressed(x, y, button, istouch)
    main:mousepressed(button)
end
```

## License

This library is free software; you can redistribute it and/or modify it under
the terms of the MIT license. See [LICENSE](LICENSE) for details.
