Feature: Cycle prevention
  In order to maintain a directed acyclic graph
  A library user
  Wants dagnabit to prevent cycles from being introduced in the graph.

  Background:
    Given the vertices
      | datum |
      | 0     |
      | 1     |
      | 2     |

  Scenario: Loops cannot be introduced into the graph
    When I insert the edge (0, 0)

    Then the edge (0, 0) should not exist

  Scenario: Cycles cannot be introduced into the graph
    Given the edge (0, 1)
    And the edge (1, 2)

    When I insert the edge (2, 0)

    Then the edge (2, 0) should not exist

  Scenario: Predecessors can be created
    Some versions of the cycle check function contained an error that prevented
    links from being built like so:

        0 --(2)--> 1 --(1)--> 2

    The point of this scenario is to demonstrate that that error no longer exists.

    Given the edge (1, 2)

    When I insert the edge (0, 1)

    Then the edge (0, 1) should exist
