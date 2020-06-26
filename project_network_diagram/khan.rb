# Algorithm from https://doi.org/10.1016/0305-0548(85)90041-3
# An algorithm for constructing project network diagrams on an ordinary line printer
# R.J.Willis†
nodes = [1, 2, 3, 4, 5]
startnode = 1
endnode = 5
edges = [
  [1, 2],
  [1, 3],
  [1, 4],
  [2, 3],
  [2, 5],
  [4, 5],
  [3, 5]  
]

edges.shuffle

# Khan's algorithm for topo-sort

pnd = []
nextnodes = [startnode]

until nextnodes.empty?
  v = nextnodes[0]
  nextnodes.delete(v)

  neighboredges = edges.select{|e| e[0] == v }
  p neighboredges
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

p pnd
