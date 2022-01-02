Feature: Minimal configuration
  I want to know the bare minimum setup required for generating an index for LaTeX
  And consequences of removing any of its elements

Scenario: Minimal configuration
  Given a file named "index.idx" with:
  """
  \indexentry{term}{1}
  """
  When I successfully run `xindy -M latex -M latex-loc-fmts index.idx`
  Then the file named "index.ind" should contain:
  """
    % T
    \item term, 1

  \end{theindex}
  """

Scenario: No 'latex' module
  Given a file named "index.idx" with:
  """
  \indexentry{term}{1}
  """
  When I successfully run `xindy -M latex-loc-fmts index.idx`
  Then the file named "index.ind" should contain:
  # no output
  """
  """

Scenario: No 'latex-loc-fmts' module
  Given a file named "index.idx" with:
  """
  \indexentry{term}{1}
  """
  When I successfully run `xindy -M latex index.idx`
  Then the file named "index.ind" should contain exactly:
  # output generated, but with no index entries
  """
  \begin{theindex}
    \providecommand*\lettergroupDefault[1]{}
    \providecommand*\lettergroup[1]{%
        \par\textbf{#1}\par
        \nopagebreak
    }


  \end{theindex}
  """
