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

plot = Array.new()

plot.push(Array.new(table[0].length,"   "))
i = 1
table.each{ |r|
  5.times{
    plot.push(Array.new(r.length,"   "))
  }
  e = r.index { |c| c != 0 }
  plot[i][e] = "---"
  plot[i+1][e] = " #{r[e]} "
  plot[i+2][e] = "---"
  lf = false
  rf = false
  r.reverse.each_with_index{ |v, j|
    ix = r.length - 1 - j
    if v != 0
      plot[i+3][ix] = " | "
      plot[i+4][ix] = " v "
      if ix != e
        # puts "plot[i-1][ix] #{plot[i-1][ix]}"
        if plot[i-1][ix] == " v "
          lf = true
        else
          rf = true
        end  
      end
    end
    if ix != e
      if lf
        plot[i][ix] = "<--"
      end
      if rf
        if plot[i-1][ix] == " v "
          plot[i][ix] = " | "
          plot[i+1][ix] = " v "
          plot[i+2][ix] = "-C>"
          plot[i+3][ix] = " | "
          plot[i+4][ix] = " v "
        else
          plot[i+2][ix] = "-->"
        end
      end
    end
  }
  puts "this"
  p plot[i-1]
  i+=5
}

puts "PLOT"
plot.each{ |r|
  p r
}