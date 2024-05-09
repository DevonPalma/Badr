# Badar 🌕

Badar _(Full moon in Arabic)_ is a declarative, retained\* and flexbox inspired ui library, with focus on reactivity and composition in mind.

### Getting Started

Badar adapts the `löve2d` mentality. You can define a variable in `love.load`, and invoke `render` in `love.draw`. Other callback functions (e.g, `mousepressed`, `mousemoved`) are used in the same manner.

- [API](docs/Core.md)
- [Callback functions](docs/Callback-functions.md)
- [How to create custom components?](docs/Custom-component-guide.md)
- [Components ✨](components) ([_docs_](docs/components))

### Usage

```lua
function love.load()
    local container = require 'path.to.badar.lua'
    local button = require 'components.button'
    local text = require 'components.text'

    local counter = text(0)
    main = container({ width = screenWidth, height = screenHeight })
        .style({ padding = { 16, 16, 16, 16 } })
        .content({
            counter,
            button('add').onClick(function()
                counter.text = counter.text + 1
            end)
        }, { direction = 'column', gap = 8 })
end

function love.draw()
    main:render()
end

function love.mousepressed(x, y, button, istouch)
    main:mousepressed(button)
end
```

---

Todo:

- [] resize callback function

## License

This library is free software; you can redistribute it and/or modify it under
the terms of the MIT license. See [LICENSE](LICENSE) for details.
