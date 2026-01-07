-- local function module_exists(name)
-- 	if package.loaded[name] then
-- 		return true
-- 	else
-- 		local status, _ = pcall(require, name)
-- 		return status
-- 	end
-- end
--
-- if not module_exists("no-status") then
-- 	os.execute("ya pack -i")
-- end
--
require("no-status"):setup()
require("full-border"):setup()

Header:children_add(function()
	if ya.target_family() ~= "unix" then
		return ui.Line({})
	end
	return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
end, 500, Header.LEFT)
