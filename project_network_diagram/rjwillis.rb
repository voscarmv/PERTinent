# Algorithm from https://doi.org/10.1016/0305-0548(85)90041-3
# An algorithm for constructing project network diagrams on an ordinary line printer
# R.J.Willis†


edges =  [[26, 25], [26, 36], [27, 25], [27, 36], [28, 29], [28, 30], [28, 31], [29, 26], [30, 26], [31, 27], [32, 27], [33, 27], [34, 27], [35, 25], [35, 36], [36, 25], [36, 37], [37, 25], [38, 36], [39, 36], [44, 25], [45, 44], [50, 27], [51, 50], [52, 50], [53, 44], [54, 53], [55, 53], [56, 53], [57, 53], [58, 44], [59, 58], [60, 58], [61, 44], [62, 61], [63, 61], [64, 61], [65, 25], [66, 44]]
nodes = [25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 44, 45, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, -1]
startnode = -1
endnode = 25

startpoints = [28, 32, 33, 34, 35, 38, 39, 45, 51, 52, 54, 55, 56, 57, 59, 60, 62, 63, 64, 65, 66]

edges += startpoints.map{|n| [startnode, n]}
# [-1]


# nodes = [1, 2, 3, 4, 5]
# startnode = 1
# endnode = 5
# edges = [
#   [1, 2],
#   [1, 3],
#   [1, 4],
#   [2, 3],
#   [2, 5],
#   [4, 5],
#   [3, 5]  
# ]

edges.shuffle!

# Khan's algorithm for topo-sort

pnd = []
nextnodes = [startnode]

until nextnodes.empty?
  v = nextnodes[0]
  nextnodes.delete(v)

  neighboredges = edges.select{|e| e[0] == v }
  neighboredges.sort_by!{|x, y| y}
  pnd += neighboredges

  neighboredges.each{ |e|
    edges.delete(e)
    neighbor = e[1]
    incoming = edges.select{|e| e[1] == neighbor}
    p incoming
    if incoming.empty?
      nextnodes.push(neighbor)
    end
  }
end

prev = pnd[0][0]
nest1 = 1
pnd.map! { |e|
  if e[0] != prev
    nest1 += 1
    prev = e[0]
  end
  e = [e, nest1]
}

 pnd.each{|e| p e}
# return "exit"
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
    nest1e = nodes.length
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
cols = table.transpose
table.each_with_index{ |r, k|
  5.times{
    plot.push(Array.new(r.length,"   "))
  }
  e = r.index { |c| c != 0 }
  puts "Plot node #{e} value #{r[e]}"
  plot[i][e] = "---"
  plot[i+1][e] = r[e]
  plot[i+2][e] = "---"
  lf = false
  rf = false
  l1 = true
  r1 = true
  r.reverse.each_with_index{ |v, j|
    ix = r.length - 1 - j
    if v != 0
      colcpy = cols[ix].dup
      colcpy.shift(k+1)
      puts "val #{v}"
      puts "col #{colcpy}"
      puts "col shift #{colcpy}"
      puts "col shift index #{colcpy.index {|c| c != 0}}"
      below = colcpy.index {|c| c != 0}
      if below
        if colcpy[below] == 27
          puts "BELOWUNM!! #{colcpy[below]}"
          gets      
        end  
      end
      if below
        plot[i+3][ix] = " v "
        plot[i+4][ix] = " v "
      end
      if ix != e
        # puts "plot[i-1][ix] #{plot[i-1][ix]}"
        if plot[i-1][ix] == " v "
          lf = true
        else
          if below 
            rf = true
            plot[i+3][ix] = " v "
            plot[i+4][ix] = " v "
          end
        end
      else
        if lf
          lf = false
        end
        if rf
          rf = false
        end
      end
    end
    if ix != e
      colcpy = cols[ix].dup
      colcpy.shift(k+1)
      puts "val #{v}"
      puts "col #{colcpy}"
      puts "col shift #{colcpy}"
      puts "col shift index #{colcpy.index {|c| c != 0}}"
      below = colcpy.index {|c| c != 0}
      if plot[i-1][ix] == " v "
        if !lf && !rf
          plot[i][ix] = " v "
          plot[i+1][ix] = " v "
          plot[i+2][ix] = " v "
          plot[i+3][ix] = " v "
          plot[i+4][ix] = " v "
        end
        if !lf && rf
          plot[i][ix] = " v "
          plot[i+1][ix] = " v "
          plot[i+2][ix] = ">+>"
          plot[i+3][ix] = " v "
          plot[i+4][ix] = " v "
        end
        if lf && !rf
          if v != 0
            if l1
              plot[i][ix] = "<< "
              l1 = false
            else
              plot[i][ix] = "<v<"
            end  
          else
            plot[i][ix] = "<+<"
            plot[i+1][ix] = " v "
            plot[i+2][ix] = " v "
            plot[i+3][ix] = " v "
            plot[i+4][ix] = " v "
          end
        end
        if lf && rf
          if below
            plot[i][ix] = "<+<"
            plot[i+1][ix] = " v "
            plot[i+2][ix] = ">+>"
            plot[i+3][ix] = " v "
            plot[i+4][ix] = " v "
          else
            plot[i][ix] = "<v<"
            plot[i+1][ix] = "   "
            plot[i+2][ix] = ">v>"
            plot[i+3][ix] = " v "
            plot[i+4][ix] = " v "  
          end
        end
      else
        if !lf && rf
          if r1
            plot[i+2][ix] = ">> "
            r1 = false
          else
            if below
              plot[i+2][ix] = ">v>"
            else
              plot[i+2][ix] = ">>>"
            end
          end
        end
        if lf && !rf
          if l1
            plot[i][ix] = "<< "
            l1 = false
          else
            plot[i][ix] = "<<<"
          end
        end
        if lf && rf
          if l1
            plot[i][ix] = "<< "
            l1 = false
          else
            plot[i][ix] = "<<<"
          end
          if r1
            plot[i+2][ix] = ">> "
            r1 = false
          else
            if below
              plot[i+2][ix] = ">v>"
            else
              plot[i+2][ix] = ">>>"
            end
          end
        end
      end
    end
    if r[e] == 26
      gets
    end

  }
  # puts "this"
  # p plot[i-1]
  i+=5
  # gets
}

puts "PLOT"
plot.each{ |r|
  puts r.join
}

# i = 7
# n1 = nil
# n2 = nil
# while i < 30 do
#   puts "Testing nodes"
#   j = plot[i].index{|x| x.class == Integer}
#   above = plot[i-2][j]
#   below = plot[i+2][j]
#   above_corner = plot[i-1][j+1]
#   below_corner = plot[i+1][j+1]

#   p above
#   p below
#   p above_corner
#   p below_corner

#   if above == " v " && below == " v " && above_corner[0] != "<" && below_corner[0] != ">"
#     p "Found first node"
#     n1 = [i,j]
#   end

#   if n1
#     s = i + 5
#     t = plot[s].index{|x| x.class == Integer}
#     above = plot[s-2][t]
#     below = plot[s+2][t]
#     above_corner = plot[s-1][t+1]
#     below_corner = plot[s+1][t+1]
  
#     if above == " v " && below == " v " && above_corner[0] != "<" && below_corner[0] != ">"
#       p "Found second node"
#       n2 = [s,t]
#     end

#     if n1 && n2
#       p "Check if nodes are compatible for sliding"
#       r1 = n1[0]
#       c1 = n1[1]

#       r2 = n2[0]
#       c2 = n2[1]

#       compare_row1_1 = plot[r1-1].map{|x| x == "---" || x.class == Integer ? " v " : x}
#       compare_row1_2 = plot[r1].map{|x| x == "---" || x.class == Integer ? " v " : x}
#       compare_row1_3 = plot[r1+1].map{|x| x == "---" || x.class == Integer ? " v " : x}

#       compare_row2_1 = plot[r2-1].map{|x| x == "---" || x.class == Integer ? " v " : x}
#       compare_row2_2 = plot[r2].map{|x| x == "---" || x.class == Integer ? " v " : x}
#       compare_row2_3 = plot[r2+1].map{|x| x == "---" || x.class == Integer ? " v " : x}

#       if compare_row1_1 == compare_row2_1 && compare_row1_2 == compare_row2_2 && compare_row1_3 == compare_row2_3

#         p "Before"
#         p plot[r1]
#         p plot[r2]
  
#         plot[r1][c2], plot[r2][c2] = plot[r2][c2], plot[r1][c2]
#         plot[r1+1][c2], plot[r2+1][c2] = plot[r2+1][c2], plot[r1+1][c2]
#         plot[r1-1][c2], plot[r2-1][c2] = plot[r2-1][c2], plot[r1-1][c2]
  
#         p "After"
#         p plot[r1]
#         p plot[r2]

#         plot.slice!(r1+2, 5)

#         next
#         # sliceis.each{|r|
#         #   p r.join
#         # }
#         # Eliminate unnecesary column
#       end

#     end

#   end

#   i += 5
# end

def collision(r1, r2)
  if r1.length != r2.length
    nil
  end
  r1.zip(r2).each{ |c1, c2| 
    if c1 == "<<<" || c1 == "<< " || c1 == "<+<" || c1 == "---" || c1 == "<v<"
      if c2 == ">>>" || c2 == ">> " || c2 == ">+>" || c2 == "---" || c2 == ">v>" || c2 == "<<<" || c2 == "<< " || c2 == "<+<" || c2 == "---" || c2 == "<v<"
        puts "c1 #{c1} c2 #{c2}"
        return true
      end
    end
  }
  return false
end

i = 7

while i < plot.length 
  j = i - 1
  k = j - 3
  puts "Node #{plot[i].select{|x| x.class == Integer}}"
  until collision(plot[j], plot[k])
    k -= 1
  end
  puts "Shift to #{k}"

  node_col = plot[i].index{|x| x.class == Integer}

  rowstodelete = j - k
  k += 3

  if k < i-1
    puts "DO SHIFT!"
    # Destination

    m1 = node_col
    while plot[i-1][m1] == "<v<" || plot[i-1][m1] == "<< " || plot[i-1][m1] == "---" || plot[i-1][m1] == "<+<" || plot[i-1][m1] == "   " || plot[i-1][m1] == "<<<" 
      plot[k][m1] = plot[i-1][m1]
      plot[k+1][m1] = plot[i][m1]
      m1 += 1
    end

    m2 = node_col
    while plot[i+1][m2] == ">v>" || plot[i+1][m2] == ">> " || plot[i+1][m2] == "---" || plot[i+1][m2] == ">+>" || plot[i+1][m2] == "   " || plot[i+1][m2] == ">>>" || m2 < m1
      plot[k+1][m2] = plot[i][m2]
      plot[k+2][m2] = plot[i+1][m2]
      (k+3..i+1).each{ |ix|
        # puts "is #{ix}"
        # puts "plot ix m #{plot[ix][m]}"
        plot[ix][m2] = plot[i+2][m2]
      }
      m2 += 1
    end


    # plot[k] = plot[k][0...node_col] + plot[i-1][node_col..-1]
    # plot[k+1] = plot[k+1][0...node_col] + plot[i][node_col..-1]
    # plot[k+2] = plot[k+2][0...node_col] + plot[i+1][node_col..-1]

    # plot.delete_at(i)
    until plot[k+6].any?{|x| x.class == Integer}
      # puts "DELETE xxxxxxx"
      plot.delete_at(k+5)
    end

    i = k+6
    # gets
    # break
    # 5.times{plot.delete_at(i-1)}
  else
    # puts "DONT SHIFT"
    i += 1
    until plot[i].any?{|x| x.class == Integer}
      i += 1
      if i > plot.length - 1
        break
      end  
    end
    i+=5
  end

  # puts "COMPRESSED PLOT STEP"
  # plot.each{ |r|
  #   puts r.join
  # }
end

puts "TABLE"
table.each{ |r|
  p r
}

puts "PLOT"
plot.each{ |r|
  puts r.join
}

puts "COMPRESSED PLOT"
plot.each{ |r|
  puts r.join
}
puts "CHANGE"