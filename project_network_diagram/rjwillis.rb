# Algorithm from https://doi.org/10.1016/0305-0548(85)90041-3
# An algorithm for constructing project network diagrams on an ordinary line printer
# R.J.Willis†
nodes = [1, 2, 3, 4, 5]
pnd = [
  [[1, 2], 1],
  [[1, 3], 1],
  [[1, 4], 1],
  [[2, 3], 2],
  [[2, 5], 2],
  [[4, 5], 3],
  [[3, 5], 4]  
]

table = Array.new(nodes.length){Array.new(1,0)}

pnd.each{ |activity|
  startnode = activity[0][0]
  nest1s = activity[1]

  endnode = activity[0][1]
  ix = pnd.index { |a| a[0][0] == endnode }

  if ix
    nest1e = pnd[ix][1]
  else
    nest1e = 5
  end

  x = 0
  cols = table.transpose
  found = false
  while x < cols.length do
    cols[x].delete_at(nest1e-1)
    cols[x].shift(nest1s)
    if cols[x].all?(0)
      table[nest1s-1][x] = startnode
      table[nest1e-1][x] = endnode
      found = true
      break
    end
    x += 1
  end
  until found do
    table.each{ |row|
      row.push(0)
    }
    cols = table.transpose
    cols[x].delete_at(nest1e-1)
    cols[x].shift(nest1s)
    if cols[x].all?(0)
      table[nest1s-1][x] = startnode
      table[nest1e-1][x] = endnode
      found = true
    end
    x += 1    
  end
}

puts "FINAL TABLE"
table.each{ |r|
  p r
}
