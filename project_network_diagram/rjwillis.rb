# Algorithm from https://doi.org/10.1016/0305-0548(85)90041-3
# An algorithm for constructing project network diagrams on an ordinary line printer
# R.J.Willis†

pnd = [
  [[1, 2], 1],
  [[1, 3], 1],
  [[1, 4], 1],
  [[2, 3], 2],
  [[2, 5], 2],
  [[4, 5], 3],
  [[3, 5], 4]  
]

table = Array.new(5){Array.new(4,0)}

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
  
  # x = table[nest1s].index{ |c| c == 0 }

  x = 0
  cols = table.transpose
  puts "Transpose"
  cols.each{ |r|
    p r
  }

  puts "Table"
  table.each{ |r|
    p r
  }  

  puts "startnode = #{startnode}"
  puts "endnode = #{endnode}"
  puts "nest1s = #{nest1s}"
  puts "nest1e = #{nest1e}"
  while x < 4 do
    puts "x = #{x}"
    puts "cols[x]"
    p cols[x]
    # colx = col[x][nest1s-1...]
    puts "then delete at cols[x][#{nest1s-1}] = #{cols[x][nest1s-1]}"
    cols[x].delete_at(nest1s-1)
    puts "after delete"
    p cols[x]
    puts "first delete at cols[x][#{nest1e-2}] = #{cols[x][nest1e-2]}"
    cols[x].delete_at(nest1e-2)
    puts "cols"
    p cols[x]
    cols[x].shift(nest1s-1)
    if cols[x].all?(0)
      table[nest1s-1][x] = startnode
      table[nest1e-1][x] = endnode
      break
    end

    # if nest1s + 1 == nest1e
    #   table[nest1s-1][x] = startnode
    #   table[nest1e-1][x] = endnode
    #   break
    # end
    # if colx[nest1s...(nest1e-1)].all?{|v| v == 0}  
    #   table[nest1s-1][x] = startnode
    #   table[nest1e-1][x] = endnode
    #   break
    # end

    table.each{ |r|
      p r
    }
    
    x += 1
  end
}

puts "FINAL TABLE"
table.each{ |r|
  p r
}
