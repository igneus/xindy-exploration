Feature: Merge rules
  As a confused user I want to explore all aspects of the merge rules

Scenario: Regexp replaces all matches
  Given a file named "rules.xdy" with:
  """
  (merge-rule "b" "a" :eregexp)
  """
  And a file named "index.idx" with:
  """
  \indexentry{aac}{1}
  \indexentry{bbb}{2}
  """
  When I successfully run xindy with "-M rules.xdy index.idx"
  Then the file named "index.ind" should contain:
  # replacing all occurrences of "b" with "a" makes "bbb" an "aaa", sorted before "aac"
  """
    % A
    \item bbb, 2
    \item aac, 1

  \end{theindex}
  """

Scenario: Regexp locked to the beginning
  Given a file named "rules.xdy" with:
  """
  (merge-rule "^b" "a" :eregexp)
  """
  And a file named "index.idx" with:
  """
  \indexentry{aac}{1}
  \indexentry{bbb}{2}
  """
  When I successfully run xindy with "-M rules.xdy index.idx"
  Then the file named "index.ind" should contain:
  # replacing the first "b" with "a" turns "bbb" to "abb", sorted *after* "aac"
  """
    % A
    \item aac, 1
    \item bbb, 2

  \end{theindex}
  """

Scenario: Regexp locked to the beginning does not have effect on second word
  Given a file named "rules.xdy" with:
  """
  (merge-rule "^b" "a" :eregexp)
  """
  And a file named "index.idx" with:
  """
  \indexentry{aaa acc}{1}
  \indexentry{aaa bbb}{2}
  """
  When I successfully run xindy with "-M rules.xdy index.idx"
  Then the file named "index.ind" should contain:
  # "bbb" is not transformed to "abb", otherwise it would be sorted before "acc"
  """
    % A
    \item aaa acc, 1
    \item aaa bbb, 2

  \end{theindex}
  """
