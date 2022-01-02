Feature: Merge rule precedence
  As a user struggling with some merge rules
  I want to clarify how they interact when applying to the same term

Scenario: First matching rule in a file wins
  Given a file named "rules.xdy" with:
  """
  (merge-rule "a" "b")
  (merge-rule "a" "c")
  """
  And a file named "index.idx" with:
  """
  \indexentry{ant}{1}
  """
  When I successfully run xindy with "-M rules.xdy index.idx"
  Then the file named "index.ind" should contain:
  # "a" was replaced with "b"
  """
    % B
    \item ant, 1
  """

Scenario: First matching rule in the order of loading files wins
  Given a file named "a_rules.xdy" with:
  """
  (merge-rule "a" "b")
  """
  And a file named "b_rules.xdy" with:
  """
  (merge-rule "a" "c")
  """
  And a file named "index.idx" with:
  """
  \indexentry{ant}{1}
  """
  When I successfully run xindy with "-M a_rules.xdy -M b_rules.xdy index.idx"
  Then the file named "index.ind" should contain:
  # "a" was replaced with "b"
  """
    % B
    \item ant, 1
  """

Scenario: Rules do not get applied over each other
  Given a file named "rules.xdy" with:
  """
  (merge-rule "a" "b")
  (merge-rule "b" "c")
  """
  And a file named "index.idx" with:
  """
  \indexentry{ant}{1}
  """
  When I successfully run xindy with "-M rules.xdy index.idx"
  Then the file named "index.ind" should contain:
  # "a" was replaced with "b", further replacement of "b" with "c" did not take place
  """
    % B
    \item ant, 1
  """

Scenario: All non-conflicting (regexp) rules get applied
  Given a file named "rules.xdy" with:
  """
  (merge-rule "^a" "b")
  (merge-rule "a$" "z")
  """
  And a file named "index.idx" with:
  """
  \indexentry{aa}{1}
  \indexentry{bc}{2}
  """
  When I successfully run xindy with "-M rules.xdy index.idx"
  Then the file named "index.ind" should contain:
  # both rules got applied, turning "aa" to "bz" - if only the first got applied,
  # "aa" turned "ba" would sort before "bc"
  """
    % B
    \item bc, 2
    \item aa, 1
  """

Scenario: All non-conflicting (plain string replace) rules get applied
  Given a file named "rules.xdy" with:
  """
  (merge-rule "a" "b")
  (merge-rule "d" "b")
  """
  And a file named "index.idx" with:
  """
  \indexentry{ad}{1}
  \indexentry{bc}{2}
  """
  When I successfully run xindy with "-M rules.xdy index.idx"
  Then the file named "index.ind" should contain:
  # both rules got applied, turning "ad" to "bb" - if only the first got applied,
  # "ad" turned "bd" would sort after "bc"
  """
    % B
    \item ad, 1
    \item bc, 2
  """
