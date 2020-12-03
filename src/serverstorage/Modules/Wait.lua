-- ++ 2.12.2020 [Create mock Wait]
-- Have another Wait module as the Client Wait module uses RunService, which isn't available on the Server.

return function(Number)
    wait(Number)
    return Number
end