# Algorithm from https://doi.org/10.1016/0305-0548(85)90041-3
# An algorithm for constructing project network diagrams on an ordinary line printer
# R.J.Willis†
nodes = [1, 2, 3, 4, 5]
# pnd = [
#   [[1, 2], 1],
#   [[1, 3], 1],
#   [[1, 4], 1],
#   [[2, 3], 2],
#   [[2, 5], 2],
#   [[4, 5], 3],
#   [[3, 5], 4]  
# ]

pnd = [
  [[1, 2], 1],
  [[1, 3], 1],
  [[1, 4], 1],
  [[2, 5], 2],
  [[3, 5], 3],
  [[4, 5], 4]
]

table = Array.new(nodes.length){Array.new(1,0)}

pnd.each{ |activity|

  puts "TABLE START"
  table.each{ |r|
    p r
  }

  startnode = activity[0][0]
  nest1s = activity[1]

  endnode = activity[0][1]
  ix = pnd.index { |a| a[0][0] == endnode }

  if ix
    nest1e = pnd[ix][1]
  else
    nest1e = pnd.last[1]+1
  end

  puts "#{startnode},#{endnode}"
  x = table[nest1s - 1].index {|c| c != 0}
  unless x
    x = 0
  end
  cols = table.transpose

  found = false
  while x < cols.length do
    puts "colx"
    p cols[x]
    cols[x].delete_at(nest1e-1)
    cols[x].shift(nest1s)
    if cols[x].all?(0)
      table[nest1s-1][x] = startnode
      table[nest1e-1][x] = endnode
      found = true
      puts "found1"
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
      puts "found2"
    end
    x += 1    
  end

  puts "TABLE END"
  table.each{ |r|
    p r
  }

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
      plot[i+3][ix] = " v "
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
      if plot[i-1][ix] == " v "
        plot[i][ix] = " v "
        plot[i+1][ix] = " v "
        plot[i+2][ix] = " v "
        plot[i+3][ix] = " v "
        plot[i+4][ix] = " v "
      end
      if lf
        plot[i][ix] = "<<<"
        plot[i+1][ix] = "   "
        plot[i+2][ix] = "   "
        plot[i+3][ix] = "   "
        plot[i+4][ix] = "   "
      end
      if rf
        if plot[i-1][ix] == " v "
          plot[i][ix] = " v "
          plot[i+1][ix] = " v "
          plot[i+2][ix] = ">v>"
          plot[i+3][ix] = " v "
          plot[i+4][ix] = " v "
        else
          plot[i+2][ix] = ">>>"
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
  puts r.join
}