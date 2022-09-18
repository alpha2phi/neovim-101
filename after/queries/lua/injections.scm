(assignment_statement
(variable_list
  name: (identifier) @name
)
(expression_list
  (string content: ("string_content") @query)
) 
(#match? @name "^tql_")
)
