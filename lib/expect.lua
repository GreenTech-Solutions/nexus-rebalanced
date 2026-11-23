local expect = { tolerance = 1e-6 }

local total = 0
local applied = 0

function expect.same(current, expected)
  if type(current) == "number" and type(expected) == "number" then
    return math.abs(current - expected) < expect.tolerance
  end

  return current == expected
end

function expect.text(value)
  if value == nil then
    return "missing"
  end
  if type(value) == "number" then
    return string.format("%.9g", value)
  end

  return tostring(value)
end

function expect.state(holder, field, from, to)
  if not holder then
    return "other"
  end
  if expect.same(holder[field], from) then
    return "from"
  end
  if expect.same(holder[field], to) then
    return "to"
  end

  return "other"
end

function expect.set(label, holder, field, from, to)
  local state = expect.state(holder, field, from, to)
  total = total + 1

  if state == "from" then
    holder[field] = to
    applied = applied + 1
    log("nexus-rebalanced: " .. label .. " " .. expect.text(from) .. " -> " .. expect.text(to))
  elseif state == "to" then
    applied = applied + 1
  else
    local current = holder and holder[field]
    log("nexus-rebalanced: " .. label .. " is " .. expect.text(current) .. ", not " .. expect.text(from)
      .. ", left as it is")
  end

  return state
end

function expect.count(ok)
  total = total + 1
  if ok then
    applied = applied + 1
  end
end

function expect.summary(stage)
  log("nexus-rebalanced: " .. stage .. ": " .. applied .. " of " .. total .. " changes applied")
  if applied < total then
    log("nexus-rebalanced: " .. stage .. ": " .. (total - applied) .. " changes left as it is, see above")
  end
end

return expect
