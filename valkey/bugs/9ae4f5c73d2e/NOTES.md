Starts a server, sets busy-reply-threshold 10, runs a script that loops `pcall(function() while true do end end)`,
then issues SCRIPT KILL and pings.
Clean: the script is killed and PING answers PONG. Buggy: the line hook is no longer set after the timeout
error, pcall swallows the kill error, the script survives and PING still returns BUSY.
