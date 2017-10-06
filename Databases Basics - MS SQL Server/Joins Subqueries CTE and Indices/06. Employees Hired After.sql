SELECT  e.FirstName,
  e.LastName,
  e.HireDate,
  d.Name AS [DeptName]
  FROM Employees AS e
  JOIN Departments AS d ON (D.DepartmentID = E.DepartmentID AND
  e.HireDate > '1.1.1999' AND (d.Name IN ('Sales', 'Finance')))
  ORDER BY e.HireDate
