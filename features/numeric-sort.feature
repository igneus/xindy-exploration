Feature: Numeric sort
  As a developer struggling with results of the numeric sort (using the numeric-sort module)
  I want to see how exactly it behaves

Scenario: Sorting entries with numbers without numeric sort
  Given a file named "index.idx" with:
  """
  \indexentry{term 1}{1}
  \indexentry{term 10}{1}
  \indexentry{term 3}{1}
  """
  When I successfully run `xindy -M latex -M latex-loc-fmts index.idx`
  Then the file named "index.ind" should contain:
  # 10 is before 3
  """
    % T
    \item term 1, 1
    \item term 10, 1
    \item term 3, 1

  \end{theindex}
  """

Scenario: Numeric sorting entries with separate numbers
  Given a file named "index.idx" with:
  """
  \indexentry{term 1}{1}
  \indexentry{term 10}{1}
  \indexentry{term 3}{1}
  """
  When I successfully run `xindy -M latex -M latex-loc-fmts -M numeric-sort index.idx`
  Then the file named "index.ind" should contain:
  """
    % T
    \item term 1, 1
    \item term 3, 1
    \item term 10, 1

  \end{theindex}
  """

Scenario: Numeric sorting entries with numbers in words
  Given a file named "index.idx" with:
  """
  \indexentry{term1}{1}
  \indexentry{term10}{1}
  \indexentry{term3}{1}
  """
  When I successfully run `xindy -I latex -M latex -M latex-loc-fmts -M numeric-sort index.idx`
  Then the file named "index.ind" should contain:
  """
    % T
    \item term1, 1
    \item term3, 1
    \item term10, 1

  \end{theindex}
  """
