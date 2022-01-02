Feature: Letter groups
  As a person fighting xindy in vain to build an index of biblical references
  I want to test various aspects of how "letter groups" work.

Scenario: Default letter groups
  Given a file named "index.idx" with:
  """
  \indexentry{ant}{1}
  \indexentry{bee}{2}
  """
  When I successfully run xindy with "index.idx"
  Then the file named "index.ind" should contain:
  """
    % A
    \item ant, 1

    \indexspace

    % B
    \item bee, 2

  \end{theindex}
  """

Scenario: Entries not matching any letter group
  Given a file named "index.idx" with:
  """
  \indexentry{ant}{1}
  \indexentry{bee}{2}
  """
  When I successfully run xindy with "-L klingon index.idx"
  Then the file named "index.ind" should contain:
  """
    % default
    \item ant, 1
    \item bee, 2

  \end{theindex}
  """

Scenario: Custom letter groups with default language
  Given a file named "custom_groups.xdy" with:
  """
  (define-letter-groups ("an" "be"))
  """
  And a file named "index.idx" with:
  """
  \indexentry{ant}{1}
  \indexentry{bee}{2}
  \indexentry{not-matching}{3}
  """
  When I successfully run xindy with "-M custom_groups.xdy index.idx"
  Then the file named "index.ind" should contain:
  # Custom letter groups have no effect, default letter groups of the Latin alphabet are used
  """
    % A
    \item ant, 1

    \indexspace

    % B
    \item bee, 2

    \indexspace

    % N
    \item not-matching, 3

  \end{theindex}
  """

Scenario: Custom letter groups with language not defining letter groups for letters of the Latin alphabet
  Given a file named "custom_groups.xdy" with:
  """
  (define-letter-groups ("an" "be"))
  """
  And a file named "index.idx" with:
  """
  \indexentry{ant}{1}
  \indexentry{bee}{2}
  \indexentry{not-matching}{3}
  """
  When I successfully run xindy with "-L klingon -M custom_groups.xdy index.idx"
  Then the file named "index.ind" should contain:
  """
    % default
    \item not-matching, 3

    \indexspace

    % an
    \item ant, 1

    \indexspace

    % be
    \item bee, 2

  \end{theindex}
  """

Scenario: Merge-rule overrides inclusion of a term in a letter group
  Given a file named "override.xdy" with:
  """
  (merge-rule "b" "a")
  """
  And a file named "index.idx" with:
  """
  \indexentry{ant}{1}
  \indexentry{bee}{2}
  """
  When I successfully run xindy with "-M override.xdy index.idx"
  Then the file named "index.ind" should contain:
  """
    % A
    \item bee, 2
    \item ant, 1

  \end{theindex}
  """
