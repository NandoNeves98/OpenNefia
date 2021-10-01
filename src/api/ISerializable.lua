-- All classes must have a `__serial_id` configured for serialization purposes.
-- Any arbitrary class can be serialized without needing to implement this
-- interface, assuming it contains no function or userdata fields.
--
-- For convenience, `__serial_id` defaults to the require path of the class if
-- none is specified. *However*, if you later move the class to a new location
-- and want to maintain save compatibility, you should explicitly define
-- `__serial_id` as the original require path before you moved the class.
--
-- You can also use any arbitrary string for `__serial_id`, but it is *highly
-- recommended* that you use a UUID to ensure there are no clashes with other
-- mods - the ID must be globally unique across all mods.
--
-- Serialization for a class can be configured by defining a `__serial_opts`
-- table with these fields:
--
-- `load_type`: What stage of the loading process the data should be loaded at.
--
-- - `deferred` (default) - First the raw class table is deserialized, then
--   after all data is loaded, the class' deserializer is run on each class
--   instance that is found. The :serialize() function must return a single
--   table with the class' metatable assigned, usually `self`. The
--   :deserialize() function will receive the deserialized table with its class
--   metatable assigned as a single argument, so all of its methods will be
--   accessable. After :serialize() is called, :deserialize() will be called on
--   the object once more, in order to restore any state mutated inside of
--   :serialize(). Calling :serialize() followed by :deserialize() should not
--   change any state in the object, i.e. it must be an idempotent operation.
--
-- - `immediate` - The class will be insantiated as soon as the deserializer
--   reaches its table. The :serialize() function will accept an arbitrary
--   number of return values, and none of them should be class instances. The
--   :deserialize() function will receive each of these return values as
--   separate arguments, and expects a single class instance to be returned. You
--   can either construct one yourself or return a reference to one that already
--   exists.
--
-- `deferred` is the default option and should work in most cases, without
-- needing to implement `ISerializable` yourself. `immediate` is for things like
-- entries in `data` where the existing reference in `data` is the one that
-- needs to be returned, instead of a new instance.

return class.interface("ISerializable",
                       {
                          serialize = "function",
                          deserialize = "function",
                          __serial_id = "string",
                          -- {
                          --     load_type = "deferred", "immediate"
                          -- }
                          __serial_opts = { type = "table", optional = true }
                       })
