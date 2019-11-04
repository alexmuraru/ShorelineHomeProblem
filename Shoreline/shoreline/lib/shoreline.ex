defmodule Shoreline do
  @moduledoc """
  How did you represent the social network? Why did you choose this representation?
    I represented the network by a map that illustrates an adjacency list of an unweighted graph where the vertices are the users and the edges the friend relationships between them.
    One strong reason i picked the adjacency list approach is that complexity of BFS/DFS are related to O(V+E) while the matrix representation would be related to O(V^2)
    Each user is represented by a char eg. 'a','b'..etc and each of them points out to a list of neighbours ('a'=> ['b','c'..etc],'b'=>['a',..])
    This representation seemed right for the given case knowing the fact that a user must have friends, so the implementation seems more right with the map approach than the list of lists


  What algorithm did you use to compute the shortest chain of friends?
    Breadth first seach (bfs/3) -> use BFS until I find the node that I'm interested in while I'm adding all elements I go through in a map
    After desired node is found i start from the ending node and i go upwards to the starting node in the map, adding the elements in a list I reverse at the end in -> resultProcessing/4

  What alternatives did you consider? Why did you choose this algorithm over the alternatives?
    Depth first Search, since it's an unweighted graph problem. In some cases DFS may be more space efficient, but it would go deeper in graph, since waisting more processing power than BFS
    on relatively small networks

  Please enumerate the test cases you considered and explain their relevance
    Some of the test cases are presented in test_helper.exs located in /test directory
    All presented test cases present 1 or more loops so it would verify if there is a problem with infinite loop
    The possible answers were computed on paper, with the graph drawn, so i could properly identify all the shortest paths the BFS algorithm could take

    -> test "Network1","Network 2","Network 3","Network 4" would try the cases where the start node would be 1,2 or more vertices apart from the end node of the search, this ensures some verify cases on
    the next layer of search consisting, Network 2 being slightly bigger then Network 1,3 or 4
    of the childern of current node
    -> test "Start and end in same node" will try the edge cases where the given start node is the same as the end node
    -> test "Circular Network" ensures the validation of a ring-type network where every user has only 2 friends
    -> test "Empty network" validates the return of a nil value in case of feeding an empty network (%{})
    -> test "Feeding List instead of map as network" is trying the feeding of invalid type of network, the result expected should also be a null
"""

  def bfs(network,startNode,endingNode) do
    if is_map(network) && network != %{} do
    if startNode == endingNode do
      [startNode]
    else
      rez=doQueueNotEmpty([startNode],network,endingNode,%{},[])
      resultProcessing(startNode,endingNode,rez,[endingNode])
    end
  end
  end

  def doQueueNotEmpty(queue,network,endingNode,result,visited) when queue != [] do
    [val|queue]=queue
    visited = visited ++ [val] |> Enum.uniq
    children = Enum.filter(network[val], fn x-> !Enum.member?(visited, x) end)
    queue=queue ++ flat(children)
    visited = visited ++ flat(children)
     |> Enum.uniq

    result=Map.put(result,val,children)
    if Enum.member?(queue, endingNode) do
      Map.put(result,endingNode,[])
    else
      doQueueNotEmpty(queue,network,endingNode,result,visited)
    end
  end

  def flat(var) do
    cond do
      is_list(var)==true -> var
      is_list(var)==false -> [var]
    end
  end

  def isVisited?(node,visited) do
    rez=Enum.filter(visited, fn x-> x==node end)
    if rez == [], do: false, else: true
  end

  def resultProcessing(startNode,endingNode,map,result) do
    if startNode != endingNode do
      {key,_}=map|>Enum.find(fn {key,val}->Enum.member?(val, endingNode) end)
      endingNode=key
      result=result ++ [key]
      resultProcessing(startNode,endingNode,map,result)
    else
      Enum.reverse(result)
    end
  end

  def onTheFlyTest() do
    network=%{'a'=>['b','c'], 'b' =>['a','d','e'],'c'=>['a'],'d'=>['b','f'],'e'=>['b','g','h'],'f'=>['d'],'g'=>['e','i','j'],'h'=>['e'],'i'=>['g','l'],'j'=>['g','l'],'l'=>['i','j']}
    start='f'
    endN='a'
    bfs(network,start,endN)
    |>Enum.join(" ")
    |>IO.puts
  end
end
