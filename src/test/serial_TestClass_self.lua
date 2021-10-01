local SkipList = require("api.SkipList")

local serial_TestClass_self = class.class("serial_TestClass_self")

function serial_TestClass_self:init(foo, bar)
   self.foo = foo
   self.bar = bar
   self.serializing = false
   self.piyo = 42
   self.list = SkipList:new()
   self.list:insert(1, 1)
   self.list:insert(2, 2)
   self.list:insert(3, 3)
end

function serial_TestClass_self:hoge(serializing)
   self.serializing = serializing
   if self.serializing then
      self.piyo = self.piyo / 2
   else
      self.piyo = self.piyo * 2
   end
end

function serial_TestClass_self:serialize()
   self:hoge(true)
end

function serial_TestClass_self:deserialize()
   self:hoge(false)
end

return serial_TestClass_self
