defmodule ShorelineTest do
  use ExUnit.Case
  doctest Shoreline

  test "Network1" do
    network=%{'a'=>['b','c'], 'b'=>['a','d','e'], 'c'=>['a','e'], 'd'=>['b','e','f'], 'e'=>['b','c','d','f'], 'f'=>['d','e']}
    result=Shoreline.bfs(network,'a','e')
    assert  result== ['a','b','e'] || result==['a','c','e']
    result=Shoreline.bfs(network,'a','b')
    assert  result== ['a','b']
    result=Shoreline.bfs(network,'d','e')
    assert  result== ['d','e']
    result=Shoreline.bfs(network,'f','a')
    assert  result== ['f','d','b','a']|| result ==['f', 'e','c','a']|| result==['f','e','b','a']
  end

  test "Start and end in same node" do
    network=%{'a'=>['b','c'], 'b'=>['a','d','e'], 'c'=>['a','e'], 'd'=>['b','e','f'], 'e'=>['b','c','d','f'], 'f'=>['d','e']}
    result=Shoreline.bfs(network,'a','a')
    assert  result== ['a']
    result=Shoreline.bfs(network,'f','f')
    assert  result== ['f']
    result=Shoreline.bfs(network,'e','e')
    assert  result== ['e']

    network=%{'a'=>['b','c'], 'b' =>['a','d','e'],'c'=>['a'],'d'=>['b','f'],'e'=>['b','g','h'],'f'=>['d'],'g'=>['e','i','j'],'h'=>['e'],'i'=>['g','l'],'j'=>['g','l'],'l'=>['i','j']}

    assert  Shoreline.bfs(network,'a','a')==['a'] || Shoreline.bfs(network,'b','b') ==['b']||Shoreline.bfs(network,'i','i'==['i'])
  end

  test "Network 2 "do
    network=%{'a'=>['b','c'], 'b' =>['a','d','e'],'c'=>['a'],'d'=>['b','f'],'e'=>['b','g','h'],'f'=>['d'],'g'=>['e','i','j'],'h'=>['e'],'i'=>['g','l'],'j'=>['g','l'],'l'=>['i','j']}
    assert  Shoreline.bfs(network,'a','f')==['a','b','d','f']
    assert  Shoreline.bfs(network,'d','l')==['d','b','e','g','i','l']||Shoreline.bfs(network,'d','l')==['d','b','e','g','j','l']
    assert  Shoreline.bfs(network,'h','c')==['h','e','b','a','c']
    assert  Shoreline.bfs(network,'i','j')==['i','l','j']||Shoreline.bfs(network,'i','j')==['i','g','j']
  end

  test "Network3 " do
    network=%{'a'=>['b','c','i'],'b'=>['a','d'],'c'=>['a','d'],'d'=>['b','c','e','f'],'e'=>['d','g'],'f'=>['d','g'],'g'=>['e','f','h'],'h'=>['g','i'],'i'=>['a','h']}
    assert Shoreline.bfs(network,'a','g')==['a','i','h','g']

    cnd=Shoreline.bfs(network,'i','d')
    assert cnd==['i','a','b','d']||cnd==['i','a','c','d']

    cnd=Shoreline.bfs(network,'h','d')
    assert cnd==['h','g','e','d']||cnd==['h','g','f','d']
  end


  test "Network4" do
    network=%{'a'=>['b'],'b'=>['a']}
    assert Shoreline.bfs(network,'a','b')==['a','b']
    assert Shoreline.bfs(network,'b','a')==['b','a']
    assert Shoreline.bfs(network,'a','a')==['a']
  end

  test "Circular Network" do
    network=%{'a'=>['b','f'],'b'=>['b','c'],'c'=>['b','d'],'d'=>['c','e'],'e'=>['d','f'],'f'=>['a','e']}
    assert  Shoreline.bfs(network,'a','f')==['a','f']
    assert  Shoreline.bfs(network,'a','d')==['a','b','c','d']||Shoreline.bfs(network,'a','d')==['a','f','e','d']
    assert  Shoreline.bfs(network,'a','c')==['a','b','c']
  end

  test "Empty network" do
    network=%{}
    assert Shoreline.bfs(network,'','')==nil
  end


  test "Feeding List instead of map as network" do
    network=[]
    assert Shoreline.bfs(network,'','')==nil
  end


end
